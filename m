Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbYIARob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbYIARob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 13:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbYIARoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 13:44:23 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:59747 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912AbYIARoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 13:44:23 -0400
Message-ID: <48BC2A03.9000104@lwfinger.net>
Date: Mon, 01 Sep 2008 12:44:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Sun, 31 Aug 2008, Larry Finger wrote:
> 
>> An ancient laptop of mine started throwing errors from b43legacy when I
>> started using 2.6.27 on it. This has been bisected to commit bfc0f59 "x86:
>> merge tsc calibration". Incidentally, I was appalled at the number of build
>> errors that were found while bisecting in this region. Every commit from
>> 2.6.26-rc9-00715 to at least -00719 had include errors that had to be fixed
>> before it would compile. Those fixes are the only reason that the builds below
>> are "dirty".
>>
>> The CPU in this computer is an AMD-K6 at stepping 0c and running at 450 MHz.
>>
>> The critical differences in the dmesg output between the "good" and "bad"
>> results indicate a factor of 2 difference in the clock speed, and are shown
>> below:
> 
>> +Clocksource tsc unstable (delta = 500037272 ns)
> 
>> -Clocksource tsc unstable (delta = 83950402 ns)
> 
> In both cases the TSC is ahead of the pm_timer, which looks like the
> pm_timer is behaving strange.
> 
> Can you please disable the pm_timer (in the kernel config,
> unfortunately there is no command line option for that) for a test and
> provide the relevant output of demsg ?

It took a while to figure out how to kill the pm_timer. I finally did 
it by changing the default to no rather than yes. I also reset the 
bisection and compiled a full -rc4 kernel.

What I hope is the relevant output of dmesg is below. The clock rate 
is correctly determined, and the b43legacy errors are gone.

Thanks - Larry

Linux version 2.6.27-rc4-wl-15747-g2e3bbe3-dirty (finger@larrylap) 
(gcc version 4.3.1 20080507 (prerelease) [gcc-4_3-branch revision 
135036] (SUSE Linux) ) #36 Mon Sep 1 12:19:13 ACT 2008

--snip--

Kernel command line: root=/dev/sda3 vga=0x314 resume=/dev/sda2 
splash=silent
Initializing CPU#0
PID hash table entries: 1024 (order: 10, 4096 bytes)
TSC calibrated against PIT
Detected 428.823 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 252692k/262080k available (1442k kernel code, 8836k reserved, 
613k data, 188k init, 0k highmem)
virtual kernel memory layout:
     fixmap  : 0xffffa000 - 0xfffff000   (  20 kB)
     vmalloc : 0xd0800000 - 0xffff8000   ( 759 MB)
     lowmem  : 0xc0000000 - 0xcfff0000   ( 255 MB)
       .init : 0xc0306000 - 0xc0335000   ( 188 kB)
       .data : 0xc0268b54 - 0xc0302208   ( 613 kB)
       .text : 0xc0100000 - 0xc0268b54   (1442 kB)
Checking if this processor honours the WP bit even in supervisor 
mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay loop (skipped), value calculated using timer 
frequency.. 857.64 BogoMIPS (lpj=1715292)
