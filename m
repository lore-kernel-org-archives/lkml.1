Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbXDBIRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbXDBIRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 04:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbXDBIRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 04:17:19 -0400
Received: from rwcrmhc14.comcast.net ([204.127.192.84]:50909 "EHLO
	rwcrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbXDBIRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 04:17:18 -0400
X-Greylist: delayed 46922 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2007 04:17:18 EDT
Message-ID: <4610BC15.5030800@ieee.org>
Date: Mon, 02 Apr 2007 04:17:25 -0400
From: Dave Sperry <dave_sperry@ieee.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Poor UDP performance using 2.6.21-rc5-rt5
References: <461004CE.1030009@ieee.org> <20070402072111.GA21356@elte.hu>
In-Reply-To: <20070402072111.GA21356@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Dave Sperry <dave_sperry@ieee.org> wrote:
>
>> I have a dual core Opteron machine that exhibits poor UDP performance 
>> (RT consumes more than 2X cpu) with the 2.6.21-rc5-rt5 as compared to 
>> 2.6.21-rc5. Top shows the IRQ handler consuming a lot of CPU.
>
> update: even with acpi_pm clocksource on vanilla i can reproduce similar 
> overhead using netperf.
>
> 	Ingo
>
Hi Ingo
I checked the clock source and in both the vanilla and rt cases and they 
were both acpi_pm

Here's the oprofile for my vanilla case:

 CPU: AMD64 processors, speed 2211.37 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Cycles outside of halt state) with a 
unit mask of 0x00 (No unit mask) count 100000
samples  %        image name               app name                 
symbol name
36264    18.2763  forcedeth.ko             forcedeth                
nv_nic_irq_optimized
25602    12.9029  vmlinux                  vmlinux                  
spurious_interrupt
10067     5.0736  forcedeth.ko             forcedeth                
nv_start_xmit_optimized
8671      4.3700  vmlinux                  vmlinux                  
unregister_kprobe
8270      4.1679  vmlinux                  vmlinux                  
ctrl_dumpfamily
8042      4.0530  vmlinux                  vmlinux                  
expand_files
5064      2.5521  vmlinux                  vmlinux                  kfree
4365      2.1999  libc-2.5.so              libc-2.5.so              
__sendto_nocancel
4067      2.0497  vmlinux                  vmlinux                  
unix_bind
4010      2.0210  vmlinux                  vmlinux                  bad_gs
3929      1.9801  vmlinux                  vmlinux                  
__alloc_skb
3859      1.9449  vmlinux                  vmlinux                  
stack_segment
3107      1.5659  vmlinux                  vmlinux                  
__find_get_block
2816      1.4192  vmlinux                  vmlinux                  
vfs_create
2611      1.3159  vmlinux                  vmlinux                  
ide_end_drive_cmd
2604      1.3124  vmlinux                  vmlinux                  
ide_end_request
2560      1.2902  vmlinux                  vmlinux                  
find_get_page
2458      1.2388  vmlinux                  vmlinux                  
hrtimer_run_queues
2456      1.2378  vmlinux                  vmlinux                  
get_wchan
2403      1.2111  forcedeth.ko             forcedeth                
nv_tx_done_optimized
2231      1.1244  vmlinux                  vmlinux                  
do_sys_poll

Any thoughts?

Thanks
Dave
