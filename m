Return-Path: <linux-kernel-owner+w=401wt.eu-S1757470AbXI2OKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbXI2OKO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 10:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbXI2OKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 10:10:00 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:44408 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbXI2OJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 10:09:59 -0400
Message-ID: <46FE5C98.1030507@aitel.hist.no>
Date: Sat, 29 Sep 2007 16:09:28 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: x86-64 sporadic hang in  2.6.23rc7 and 2.6.22
References: <46F8273B.8030904@aitel.hist.no> <1190669351.4035.254.camel@chaos>
In-Reply-To: <1190669351.4035.254.camel@chaos>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 2007-09-24 at 23:08 +0200, Helge Hafting wrote:
>   
>> The two kernels mentioned hangs occationally.
>> Typically when I compile something and pass the time
>> by surfing the web.
>>
>> A few minutes and then I notice that the mouse (and everything else in X)
>> stops.  kbd LEDs does not react to numlock/capslock.
>> The only thing that still works is sysrq+B
>> So far this has happened while running X, so no messages.
>>
>> I have gone back to 2.6.22rc4, which seems to work.
>>
>> This is a single opteron, although on a dual-slot board.
>>     
>
> Can you switch to serial console, so we can get some information out of
> that box? Sysrq-B is working, so we can get info from other sysrq
> functions as well.
>   
I didn't need the serial - it crashes during console work too.
I think a "make clean" was in progress at the time. There must be work 
going on
in order to crash.

This time 2.6.22rc4 died on me with a general protection fault

I got two reports, the first one scrolled partially off screen but
the whole trace was there:

shrink_dcache_memory
shrink_slab
kswapd
autoremove_wake_function
thread_return
trace_hardirqs_on
kswapd
kswapd
kthtread
child_rip
restore_args
kthread
child_rip

Then I got:
spinlock lockup on cpu #0, kswapd 0/212
_raw_spin_lock
shrink_dcache_parent
shrink_dcache_parent
proc_flush_task
release_task
do_exit
die
error_exit
prune_dcache
[From here on, it continues exactly like the first report:]
shrink_dcache_memory
shrink_slab
kswapd
autoremove_wake_function
thread_return
trace_hardirqs_on
kswapd
kswapd
kthtread
child_rip
restore_args
kthread
child_rip


sysrq P says:
cpu 0
pid 212 comm: kswapd0  not tainted 2.6.22-rc4 #18
RIP: __delay

I took a picture of the screen, in case the register dumps are interesting.
Wonder what this is - dcache trouble? swap trouble?
Helge Hafting
