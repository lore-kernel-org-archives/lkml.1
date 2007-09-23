Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbXIWQUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbXIWQUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 12:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbXIWQUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 12:20:05 -0400
Received: from echo.digadd.de ([195.47.195.234]:33313 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755515AbXIWQUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 12:20:03 -0400
Message-ID: <46F69224.2020003@digadd.de>
Date: Sun, 23 Sep 2007 19:19:48 +0300
From: "Christian P. Schmidt" <charlie@digadd.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>
Subject: Re: Memory allocation problem with 2.6.22 after suspend/resume cycle
References: <46F53793.3020102@digadd.de> <200709230000.09722.rjw@sisk.pl> <46F65E56.8090701@digadd.de> <200709231503.47727.rjw@sisk.pl>
In-Reply-To: <200709231503.47727.rjw@sisk.pl>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday, 23 September 2007 14:38, Christian P. Schmidt wrote:
>> Rafael J. Wysocki wrote:
>>> On Saturday, 22 September 2007 17:41, Christian P. Schmidt wrote:
>>>> Hi all,
>>>>
>>>> I'm having a strange problem, of course not reproducible. Sometimes
>>>> after a suspend (to ram) and resume cycle, the kernel will try to free
>>>> all memory. This means, all running applications are flushed to swap (as
>>>> long as it is available), caches and buffers stay at around 15MB each.
>>>>
>>>> The following video (traded quality for bandwidth) shows what happens on
>>>> the way from no swap to "swapon -a" (that's the unreadable thing in the
>>>> small shell): http://digadd.de/swapping.avi
>>>>
>>>> The system:
>>>> Linux dnnote 2.6.22.5 #1 SMP PREEMPT Sat Aug 25 18:39:21 AST 2007 x86_64
>>>> Intel(R) Core(TM)2 CPU T7400 @ 2.16GHz GenuineIntel GNU/Linux
>>> Are you using an ATI binary graphics driver?
>> Yes. I do not (yet) have a choice... can't wait for the open source drivers.
> 
> That, most probably, is the source of the problem.  Please see:
> http://bugzilla.kernel.org/show_bug.cgi?id=8943

I do however not agree with Andrew's conclusion, as the memory is not
"used", so I wouldn't expect a memory leak. As soon as I turn swapping
off everything is loaded again, and works. If there was a leak it should
use the memory, shouldn't it?
If the problem would be 100% reproducible I could try without, but as
is, I have up to two weeks with 2-3 cycles daily (sometimes more, as I
receive untraceable SERR from my PCI-E WLAN after which I do not receive
interrupts any more - only a suspend/resume cycle helps...) before the
problem occurs.

Anyway, is there a way of unloading the module temporarily without
shutting X down?

>>>> A 32bit Kernel is unable to suspend/resume at all. No idea why. dmesg
>>>> shows nothing, logs show nothing. Any ideas for debugging are welcome.
>>> Well, that's interesting.
>>>
>>> Can you try in the minimal configuration (ie. boot with init=/bin/bash,
>>> mount /sys, mount /proc and run "echo mem > /sys/power/disk)?
>> Which? the 32bit or the 64bit?
> 
> 32-bit, but please do that without the ATI driver.

Did it. As before, suspends, but when I resume, I hear the CD-ROM spin
up, the backlight comes on, and nothing more. The system is a Lenovo
Thinkpad T60 8744-4XG, BIOS 1.09.

Regards,
Christian
