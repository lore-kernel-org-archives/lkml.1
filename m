Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYJYJNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYJYJNp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 05:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYJYJNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 05:13:37 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38553 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbYJYJNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 05:13:36 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4902E2FA.10209@s5r6.in-berlin.de>
Date: Sat, 25 Oct 2008 11:12:26 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrea Righi <righi.andrea@gmail.com>, Dave Jones <davej@redhat.com>,
       Dave Airlie <airlied@redhat.com>
Subject: Re: lockdep splat from ioctl and mmap fops sharing lock
References: <87ljwgj8p1.fsf@saeurebad.de> <87ej27jtvx.fsf@saeurebad.de>	<49009375.1070209@s5r6.in-berlin.de> <8763njjmqt.fsf@saeurebad.de>
In-Reply-To: <8763njjmqt.fsf@saeurebad.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> Stefan Richter <stefanr@s5r6.in-berlin.de> writes:
> 
>> Johannes Weiner wrote:
>>> raw1394_ioctl() doing usercopy under fi->state_mutex
>>> raw1394_mmap() taking fi->state_mutex under mmap_sem
...
>> was the usage of mmap_sem changed after 2.6.27 or were my tests
>> insufficient?
> 
> In linux-next/-mm, copy_to/from_user have lockdep annotations telling
> that they might fault and therefor acquire the mmap_sem in #PF.
> 
> But since faults on ioctl parameters are so rare, without these
> annotations you would probably never see a warning.

Thanks for the report and explanation.  I logged this as 
http://bugzilla.kernel.org/show_bug.cgi?id=11823 (dv1394, won't fix) and 
http://bugzilla.kernel.org/show_bug.cgi?id=11824 (raw1394, to be fixed 
in the 2.6.28-rc timeframe since it is a post 2.6.27 regression).
-- 
Stefan Richter
-=====-==--- =-=- ==--=
http://arcgraph.de/sr/
