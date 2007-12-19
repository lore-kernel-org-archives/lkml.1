Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbXLSP5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbXLSP5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 10:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbXLSP5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 10:57:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:16202 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbXLSP5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 10:57:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=KQPNVEsHiDrfvFUwJoD0iDUFnJ2DETkUQ8TelXMsorQhja9Pd4wLFhpmX8D4JhLbRHX1d0AxMe3SnAgf3R7Vvau+Cc3Vatthao7H2X9whhc5RATd7X8jQ1/l0k3yTHkL95A/HC8SjswSnBQbmt98pSgYAa8W1laOTPiUtaGoc4k=
Message-ID: <3efb10970712190757m18f8851cq54061ff109790805@mail.gmail.com>
Date: Wed, 19 Dec 2007 16:57:04 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH v2 0/6] atmel_serial: Cleanups, irq handler splitup & DMA
Cc: "Andrew Victor" <linux@maxim.org.za>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       "Russell King" <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org
In-Reply-To: <1198077130-9021-1-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1198077130-9021-1-git-send-email-hskinnemoen@atmel.com>
X-Google-Sender-Auth: dc5dbd5024f0a995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Haavard,

Sorry.. But I get an Oops on Preempt-RT with the latest set of
patches. I did not see it earlier today with the other set of patches.

Here it is...

Remy

root@134:~ [   13.760735] Unable to handle kernel NULL pointer
dereference at virtual address 00000000
[   13.760735] pgd = c0004000
[   13.760735] [00000000] *pgd=00000000
[   13.760735] stopped custom tracer.
[   13.760735] Internal error: Oops: 817 [#1] PREEMPT
[   13.760735] CPU: 0    Not tainted  (2.6.23.12-rt14 #76)
[   13.760735] PC is at rt_spin_lock_slowlock+0x84/0x1c8
[   13.760735] LR is at rt_spin_lock_slowlock+0x54/0x1c8
[   13.760735] pc : [<c01a46f4>]    lr : [<c01a46c4>]    psr: 60000093
[   13.760735] sp : c02e1d38  ip : c02dd5a0  fp : c02e1d94
[   13.760735] r10: c3c3cc21  r9 : c001ec58  r8 : 00000001
[   13.760735] r7 : c001e800  r6 : c0212aec  r5 : c02e0000  r4 : a0000013
[   13.760735] r3 : c02dd5a0  r2 : c02dd5a0  r1 : c0212afc  r0 : 00000000
[   13.760735] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment kernel
[   13.760735] Control: c000717f  Table: 23d98000  DAC: 00000017
[   13.760735] Process softirq-tasklet (pid: 9, stack limit = 0xc02e0268)
[   13.760735] Stack: (0xc02e1d38 to 0xc02e2000)
[   13.760735] 1d20:
    00000001 00000000
[   13.760735] 1d40: c02e1d5c c02e1d50 0000001f c02dcd20 00000000
00000000 c02e1d94 c02e1d68
[   13.760735] 1d60: 00000000 c0029844 c02e1da4 c02e0000 c0212aec
c001e800 c001e800 00000001
[   13.760735] 1d80: c001ec58 c3c3cc21 c02e1dac c02e1d98 c01a4b28
c01a4680 c001e800 c0212aec
[   13.760735] 1da0: c02e1dbc c02e1db0 c01a4b44 c01a4ad8 c02e1dd4
c02e1dc0 c010e298 c01a4b44
[   13.760735] 1dc0: 0000001b c3c3cc1c c02e1de4 c02e1dd8 c010e2bc
c010e288 c02e1ea4 c02e1de8
[   13.760735] 1de0: c01007e0 c010e2bc c3c3cc22 c3c3cd22 00000000
00000000 c0035d18 c00359b4
[   13.760735] 1e00: 00000001 c01f40a4 c02e1e2c c02e1e18 c0035f7c
c0035cf4 00000001 c01f40a4
[   13.760735] 1e20: c02e1e3c c02e1e30 c0036230 c02e0000 c02e1e54
c02e1e40 c01a4af8 c02e0000
[   13.760735] 1e40: c02e1e64 c02e1e50 c01a4af8 c002a4d8 c001e800
c001e92c c02e1e74 c02e1e68
[   13.760735] 1e60: c01a4b44 c01a4ad8 c02e1e8c c02e0000 c02e1e94
c02e1e80 c01a4af8 c3c3cd1c
[   13.760735] 1e80: c3c3cc1c c001e800 c3c3cc00 00000005 c001e92c
00000001 c02e1edc c02e1ea8
[   13.760735] 1ea0: c00fb38c c00ffa64 c02e1ecc c001e80c c01a4af8
c001e800 c001e92c c001e800
[   13.760735] 1ec0: 0000001b 00000001 c02e1efe 00000004 c02e1ef4
c02e1ee0 c00fb450 c00fb2a0
[   13.760735] 1ee0: c0212aec 00001a1b c02e1f2c c02e1ef8 c011188c
c00fb424 00000015 1b002da0
[   13.760735] 1f00: c02e1f24 c0212bcc 000f4240 00000000 00000004
00000000 00000020 c0209e14
[   13.760735] 1f20: c02e1f54 c02e1f30 c0035858 c01112b0 c0209c20
c0209c20 c0209c20 ffffffdf
[   13.760735] 1f40: c0209e20 c02e0000 c02e1f64 c02e1f58 c003599c
c00357a0 c02e1fd4 c02e1f68
[   13.760735] 1f60: c00363b4 c0035974 00000000 c02cb580 61741f94
656c6b73 00302f74 c003e3e4
[   13.760735] 1f80: c02dd9e0 00000002 c02e1fbc c02e1f98 c01a31b0
c0051154 00000000 c02e0000
[   13.760735] 1fa0: c0209e14 0000001f 00000000 c02e0000 c0209e14
c003623c 00000000 00000000
[   13.760735] 1fc0: 00000000 00000000 c02e1ff4 c02e1fd8 c004510c
c003624c 00000000 00000000
[   13.760735] 1fe0: 00000000 00000000 00000000 c02e1ff8 c00336d8
c00450bc 7475706e 74616420
[   13.760735] Backtrace:
[   13.760735] [<c01a4670>] (rt_spin_lock_slowlock+0x0/0x1c8) from
[<c01a4b28>] (__rt_spin_lock+0x60/0x6c)
[   13.760735] [<c01a4ac8>] (__rt_spin_lock+0x0/0x6c) from
[<c01a4b44>] (rt_spin_lock+0x10/0x14)
[   13.760735]  r5:c0212aec r4:c001e800
[   13.760735] [<c01a4b34>] (rt_spin_lock+0x0/0x14) from [<c010e298>]
(uart_start+0x20/0x34)
[   13.760735] [<c010e278>] (uart_start+0x0/0x34) from [<c010e2bc>]
(uart_flush_chars+0x10/0x14)
[   13.760735]  r5:c3c3cc1c r4:0000001b
[   13.760735] [<c010e2ac>] (uart_flush_chars+0x0/0x14) from
[<c01007e0>] (n_tty_receive_buf+0xd8c/0xe70)
[   13.760735] [<c00ffa54>] (n_tty_receive_buf+0x0/0xe70) from
[<c00fb38c>] (flush_to_ldisc+0xfc/0x184)
[   13.760735] [<c00fb290>] (flush_to_ldisc+0x0/0x184) from
[<c00fb450>] (tty_flip_buffer_push+0x3c/0x40)
[   13.760735] [<c00fb414>] (tty_flip_buffer_push+0x0/0x40) from
[<c011188c>] (atmel_tasklet_func+0x5ec/0x5fc)
[   13.760735]  r5:00001a1b r4:c0212aec
[   13.760735] [<c01112a0>] (atmel_tasklet_func+0x0/0x5fc) from
[<c0035858>] (__tasklet_action+0xc8/0x194)
[   13.760735] [<c0035790>] (__tasklet_action+0x0/0x194) from
[<c003599c>] (tasklet_action+0x38/0x40)
[   13.760735]  r8:c02e0000 r7:c0209e20 r6:ffffffdf r5:c0209c20 r4:c0209c20
[   13.760735] [<c0035964>] (tasklet_action+0x0/0x40) from
[<c00363b4>] (ksoftirqd+0x178/0x228)
[   13.760735] [<c003623c>] (ksoftirqd+0x0/0x228) from [<c004510c>]
(kthread+0x60/0x94)
[   13.760735] [<c00450ac>] (kthread+0x0/0x94) from [<c00336d8>]
(do_exit+0x0/0x7e0)
[   13.760735]  r6:00000000 r5:00000000 r4:00000000
[   13.760735] Code: e5963010 e595200c e3c33003 e1530002 (05800000)
[   14.189445] note: softirq-tasklet[9] exited with preempt_count 1
[   14.194328] BUG: sleeping function called from invalid context
softirq-tasklet(9) at kernel/rtmutex.c:637
[   14.204094] in_atomic():1 [00000001], irqs_disabled():0
[   14.208977] [<c0023d48>] (dump_stack+0x0/0x14) from [<c002a5a8>]
(__might_sleep+0xe0/0x104)
[   14.217766] [<c002a4c8>] (__might_sleep+0x0/0x104) from
[<c01a4af8>] (__rt_spin_lock+0x30/0x6c)
[   14.226555]  r4:c02e0000
[   14.228508] [<c01a4ac8>] (__rt_spin_lock+0x0/0x6c) from
[<c01a4b44>] (rt_spin_lock+0x10/0x14)
[   14.237297]  r5:c02dd5a0 r4:c02dd818
[   14.240227] [<c01a4b34>] (rt_spin_lock+0x0/0x14) from [<c00338e8>]
(do_exit+0x210/0x7e0)
[   14.249016] [<c00336d8>] (do_exit+0x0/0x7e0) from [<c0023c4c>]
(die+0x1c8/0x214)
[   14.255852] [<c0023a84>] (die+0x0/0x214) from [<c0024f38>]
(__do_kernel_fault+0x6c/0x7c)
[   14.263664] [<c0024ecc>] (__do_kernel_fault+0x0/0x7c) from
[<c0025164>] (do_page_fault+0x21c/0x238)
[   14.272453]  r7:c02e1cf0 r6:c02dd5a0 r5:c01f0370 r4:ffffffff
[   14.278313] [<c0024f48>] (do_page_fault+0x0/0x238) from
[<c001f250>] (do_DataAbort+0x3c/0xa0)
[   14.287102] [<c001f214>] (do_DataAbort+0x0/0xa0) from [<c001fa60>]
(__dabt_svc+0x40/0x60)
[   14.294914] Exception stack(0xc02e1cf0 to 0xc02e1d38)
[   14.299797] 1ce0:                                     00000000
c0212afc c02dd5a0 c02dd5a0
[   14.308586] 1d00: a0000013 c02e0000 c0212aec c001e800 00000001
c001ec58 c3c3cc21 c02e1d94
[   14.316398] 1d20: c02dd5a0 c02e1d38 c01a46c4 c01a46f4 60000093 ffffffff
[   14.324211]  r8:00000001 r7:c001e800 r6:c0212aec r5:c02e1d24 r4:ffffffff
[   14.331047] [<c01a4670>] (rt_spin_lock_slowlock+0x0/0x1c8) from
[<c01a4b28>] (__rt_spin_lock+0x60/0x6c)
[   14.340812] [<c01a4ac8>] (__rt_spin_lock+0x0/0x6c) from
[<c01a4b44>] (rt_spin_lock+0x10/0x14)
[   14.348625]  r5:c0212aec r4:c001e800
[   14.352531] [<c01a4b34>] (rt_spin_lock+0x0/0x14) from [<c010e298>]
(uart_start+0x20/0x34)
[   14.360344] [<c010e278>] (uart_start+0x0/0x34) from [<c010e2bc>]
(uart_flush_chars+0x10/0x14)
[   14.369133]  r5:c3c3cc1c r4:0000001b
[   14.372062] [<c010e2ac>] (uart_flush_chars+0x0/0x14) from
[<c01007e0>] (n_tty_receive_buf+0xd8c/0xe70)
[   14.381828] [<c00ffa54>] (n_tty_receive_buf+0x0/0xe70) from
[<c00fb38c>] (flush_to_ldisc+0xfc/0x184)
[   14.390617] [<c00fb290>] (flush_to_ldisc+0x0/0x184) from
[<c00fb450>] (tty_flip_buffer_push+0x3c/0x40)
[   14.399406] [<c00fb414>] (tty_flip_buffer_push+0x0/0x40) from
[<c011188c>] (atmel_tasklet_func+0x5ec/0x5fc)
[   14.409172]  r5:00001a1b r4:c0212aec
[   14.413078] [<c01112a0>] (atmel_tasklet_func+0x0/0x5fc) from
[<c0035858>] (__tasklet_action+0xc8/0x194)
[   14.421867] [<c0035790>] (__tasklet_action+0x0/0x194) from
[<c003599c>] (tasklet_action+0x38/0x40)
[   14.431633]  r8:c02e0000 r7:c0209e20 r6:ffffffdf r5:c0209c20 r4:c0209c20
[   14.437492] [<c0035964>] (tasklet_action+0x0/0x40) from
[<c00363b4>] (ksoftirqd+0x178/0x228)
[   14.446281] [<c003623c>] (ksoftirqd+0x0/0x228) from [<c004510c>]
(kthread+0x60/0x94)
[   14.454094] [<c00450ac>] (kthread+0x0/0x94) from [<c00336d8>]
(do_exit+0x0/0x7e0)
[   14.460930]  r6:00000000 r5:00000000 r4:00000000


2007/12/19, Haavard Skinnemoen <hskinnemoen@atmel.com>:
> The following patchset cleans up the atmel_serial driver a bit,
> moves a significant portion of the interrupt handler into a tasklet,
> and adds DMA support. This is the result of a combined effort by Chip
> Coldwell, Remy Bohmer and me. The patches should apply cleanly onto
> Linus' latest git tree.
>
> With DMA, I see transfer rates around 92 kbps when transferring a big
> file using ZModem (both directions are roughly the same.)
>
> Note that break and error handling doesn't work too well with DMA
> enabled. This is a common problem with all the efforts I've seen
> adding DMA support to this driver (including my own). The PDC error
> handling also accesses icount without locking. I'm tempted to just
> ignore the problem for now and hopefully come up with a solution
> later.
>
> Everyone, please give it a try and/or review the code.
>
> Chip Coldwell (1):
>       atmel_serial: Add DMA support
>
> Haavard Skinnemoen (3):
>       atmel_serial: Use cpu_relax() when busy-waiting
>       atmel_serial: Use existing console options only if BRG is running
>       atmel_serial: Fix bugs in probe() error path and remove()
>
> Remy Bohmer (2):
>       atmel_serial: Clean up the code
>       atmel_serial: Split the interrupt handler
>
>  drivers/serial/atmel_serial.c |  938 ++++++++++++++++++++++++++++++++---------
>  1 files changed, 738 insertions(+), 200 deletions(-)
>
