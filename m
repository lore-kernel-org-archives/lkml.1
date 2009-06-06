Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbZFFPq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbZFFPq7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 11:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZFFPqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 11:46:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:4411 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZFFPqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 11:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=kQtzR4pJBFBQSyIAGJBZ6WrWxb70iOzwo6UBLP7webuv8Xm5KXVck7u9AP/0ZF+BDZ
         BQFsNPc+/M91owDQeWoOkmpkrEIKwXM4Ql7TK97Tbi7whvkN9eHWf7VVi4ZbruEZm638
         6hjfAGpX39gMWp0BFMj+w70/0fA0CRcsBWiA4=
Message-ID: <4A2A8F6A.80705@gmail.com>
Date: Sat, 06 Jun 2009 17:46:50 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.2 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>
CC: Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [sound] mpd loops on current -next
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found a regression in current -next caused by
c44941e05900fe85f6091456f9e313b446a97ae9
(PCM midlevel: Do not update hw_ptr_jiffies when hw_ptr is not changed)

When mpd is playing, it loops with a pattern such as:
16:05:02.762544 ioctl(14, 0x4122, 0x3)  = 0
16:05:02.762565 ioctl(14, 0x4122, 0)    = 0
16:05:02.762587 ioctl(14, 0x4122, 0x1)  = 0
16:05:02.762609 ioctl(14, 0x4122, 0x3)  = 0
16:05:02.762630 ioctl(14, 0x4122, 0)    = 0
16:05:02.762652 ioctl(14, 0x4122, 0)    = 0
16:05:02.762674 poll([{fd=13, events=POLLIN|POLLERR|POLLNVAL}], 1, -1) =
1 ([{fd=13, revents=POLLIN}])
16:05:02.762698 ioctl(14, 0x4122, 0x3)  = 0
16:05:02.762720 ioctl(14, 0x4122, 0)    = 0
16:05:02.762742 ioctl(14, 0x4122, 0x1)  = 0
16:05:02.762765 ioctl(14, 0x4122, 0x3)  = 0
16:05:02.762787 ioctl(14, 0x4122, 0)    = 0
16:05:02.762809 ioctl(14, 0x4122, 0)    = 0

Reverting the patch makes the problem disappear.
