Return-Path: <linux-kernel-owner+w=401wt.eu-S933020AbXDRIJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbXDRIJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 04:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933036AbXDRIJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 04:09:47 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:46633 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933020AbXDRIJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 04:09:46 -0400
Message-ID: <4625D239.90801@free.fr>
Date: Wed, 18 Apr 2007 10:09:29 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andi Kleen <andi@firstfloor.org>, linux.kernel@free.fr
Subject: Re: Disabling x86 System Management Mode
References: <46235447.3080000@free.fr> <p73odlo55q2.fsf@bingen.suse.de> <4624FA85.9010704@free.fr>
In-Reply-To: <4624FA85.9010704@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:

> # : >/var/log/kern.log; cat /proc/interrupts; /bin/time insmod houba.ko; 
> cat /proc/interrupts; rmmod houba
>            CPU0
>   0:     519083    XT-PIC-XT        timer
>   2:          0    XT-PIC-XT        cascade
>   9:          0    XT-PIC-XT        acpi
>  10:       9786    XT-PIC-XT        eth0
>  11:          5    XT-PIC-XT        eth1
>  12:          5    XT-PIC-XT        eth2
>  14:      16920    XT-PIC-XT        ide0
> NMI:          0
> ERR:          0
> 0.00user 0.00system 5:00.00elapsed 0%CPU (0avgtext+0avgdata 0maxresident)k
> 0inputs+0outputs (0major+111minor)pagefaults 0swaps
>            CPU0
>   0:     549094    XT-PIC-XT        timer
>   2:          0    XT-PIC-XT        cascade
>   9:          0    XT-PIC-XT        acpi
>  10:       9791    XT-PIC-XT        eth0
>  11:          5    XT-PIC-XT        eth1
>  12:          5    XT-PIC-XT        eth2
>  14:      16970    XT-PIC-XT        ide0
> NMI:          0
> ERR:          0
> 
> (HZ=100)
> 30011 timer interrupts
> 5 eth0 interrupts
> 50 ide0 interrupts
> 
> # cat /var/log/kern.log
> Apr 17 18:22:27 SEND kernel: INIT
> Apr 17 18:27:27 SEND kernel: 2350080 29995
> Apr 17 18:27:27 SEND kernel: 2369792 1
> Apr 17 18:27:27 SEND kernel: 2440192 1
> Apr 17 18:27:27 SEND kernel: 2441216 1
> Apr 17 18:27:27 SEND kernel: 2583296 1
> Apr 17 18:27:27 SEND kernel: 2852096 1
> Apr 17 18:27:27 SEND kernel: EXIT
> 
> First column is the cycle count clamped to a multiple of 256.
> (1266.7 MHz CPU)
> Second column is occurence count.
> 
> In the second experiment, I added the IRQ disable/enable around foo.
> 
> # : >/var/log/kern.log; cat /proc/interrupts; /bin/time insmod houba.ko; 
> cat /proc/interrupts; rmmod houba
>            CPU0
>   0:     583666    XT-PIC-XT        timer
>   2:          0    XT-PIC-XT        cascade
>   9:          0    XT-PIC-XT        acpi
>  10:      10084    XT-PIC-XT        eth0
>  11:          5    XT-PIC-XT        eth1
>  12:          5    XT-PIC-XT        eth2
>  14:      17012    XT-PIC-XT        ide0
> NMI:          0
> ERR:          0
> 0.00user 0.01system 5:00.00elapsed 0%CPU (0avgtext+0avgdata 0maxresident)k
> 0inputs+0outputs (0major+110minor)pagefaults 0swaps
>            CPU0
>   0:     613677    XT-PIC-XT        timer
>   2:          0    XT-PIC-XT        cascade
>   9:          0    XT-PIC-XT        acpi
>  10:      10089    XT-PIC-XT        eth0
>  11:          5    XT-PIC-XT        eth1
>  12:          5    XT-PIC-XT        eth2
>  14:      17070    XT-PIC-XT        ide0
> NMI:          0
> ERR:          0
> 
> 30011 timer interrupts
> 5 eth0 interrupts
> 58 ide0 interrupts
> 
> # cat /var/log/kern.log
> Apr 17 18:33:12 SEND kernel: INIT
> Apr 17 18:38:12 SEND kernel: 2350080 30000
> Apr 17 18:38:12 SEND kernel: EXIT
> 
> In this experiment, all the calls to foo had a latency between
> 2350080 and 2350335 cycles (1.88528 to 1.88548 ms).
> 
> I don't think I can conclude anything based on this experiment.
> 
> I'll let it run all night long.

With the IRQ disable/enable around foo:

# : >/var/log/kern.log; cat /proc/interrupts; /bin/time insmod houba.ko; 
cat /proc/interrupts; rmmod houba
            CPU0
   0:      14659    XT-PIC-XT        timer
   2:          0    XT-PIC-XT        cascade
   9:          0    XT-PIC-XT        acpi
  10:        144    XT-PIC-XT        eth0
  11:          5    XT-PIC-XT        eth1
  12:          5    XT-PIC-XT        eth2
  14:      21526    XT-PIC-XT        ide0
NMI:          0
ERR:          0
0.00user 0.01system 12:30:00elapsed 0%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+110minor)pagefaults 0swaps
            CPU0
   0:    4516164    XT-PIC-XT        timer
   2:          0    XT-PIC-XT        cascade
   9:          0    XT-PIC-XT        acpi
  10:        414    XT-PIC-XT        eth0
  11:          5    XT-PIC-XT        eth1
  12:          5    XT-PIC-XT        eth2
  14:      21620    XT-PIC-XT        ide0
NMI:          0
ERR:          0

4501505 timer interrupts (I had set N to 4500000)
270 eth0 interrupts
94 ide0 interrupts

# cat /var/log/kern.log
Apr 17 19:03:26 SEND kernel: INIT
Apr 18 07:33:26 SEND kernel: 2350080 4500000
Apr 18 07:33:26 SEND kernel: EXIT

I'd say the CPU does not appear to enter SMM on this system.
(Unless the SMI handler restores the TSC as suggested by Andi.)

I need to refine my detection code.
