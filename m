Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbXCPX0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbXCPX0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 19:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbXCPX0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 19:26:25 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:43294 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbXCPX0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 19:26:23 -0400
Date: Sat, 17 Mar 2007 00:23:32 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: Linux 2.6.21-rc4
In-Reply-To: <6bffcb0e0703161155o1e153725jd3f4a01fb5fa0d55@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0703170022200.23117@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> 
 <45FAD77A.1070709@googlemail.com>  <20070316102650.267e2c55.akpm@linux-foundation.org>
 <6bffcb0e0703161155o1e153725jd3f4a01fb5fa0d55@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 16 2007 19:55, Michal Piotrowski wrote:
>> > I've got *bad* news. Bug described here
>> > http: //www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#0889
>> > http: //www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#1165
>> > probably leaked into mainline.
>> > 
>> > Fsck!
>> 
>> fsck indeed.  I don't even understand what's happening with that one - it
>> seems like the kernel schedules a user process, but never deschedules it
>> again.
>> 
>
> Tomorrow, I'll try to find out how to reproduce this bug.

>From #0889:

 "I have noticed some strange system behavior. When i try to build a
 kernel (medium load) - X, keyboard, mouse and sound hangs."

Note that ping is handled in interrupt or softirq context. So something has
locked up. Try without X? Or perhaps attack a serial console/netconsole, and
when it hangs, use Sysrq to dump the process' states.


Jan
-- 
