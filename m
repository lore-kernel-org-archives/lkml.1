Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbZFVONr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbZFVONr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756742AbZFVONj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:13:39 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:63727 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876AbZFVONi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:13:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uP7Cc6GFFGS93+wNTNQq3Y7vkj8bCSM1TM/9bIPHZbKyy8ahEpTJa3/8gtYSvxb7nr
         iaCVBTrc2iw55Ub6VR8VZ7qdXMxFnwGTqgJ0YbNXWVFJeJn28FY48ZVBcl47DqGmefYg
         ts1vz9B1asCqxmgl49vjoCQQNbDJdqbFrQOlw=
MIME-Version: 1.0
In-Reply-To: <20090619134446.GI24573@n2100.arm.linux.org.uk>
References: <366f00c80906180218p539f9df9md30f629787fabeb2@mail.gmail.com>
	 <20090619134446.GI24573@n2100.arm.linux.org.uk>
Date: Mon, 22 Jun 2009 19:43:40 +0530
Message-ID: <366f00c80906220713o7ad61a8elb6b278b7313107d8@mail.gmail.com>
Subject: Re: Rootfs in eMMC: Kernel panic ...Attempted to kill init!
From: Sudeep K N <sudeepholla.maillist@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Thanks for the suggestion.
With the logs it is clear that crash is in the userspace.
I am getting one of the 2 logs(below) randomly.
>From trial#2,
pgd = c60bc000
[00000000] *pgd=061ee031, *pte=00000000, *ppte=00000000
I could understand that the page tables are not proper.
I am not able understand how to proceed.

Trial#1:
VFS: Mounted root (ext2 filesystem).
Freeing init memory: 108K
linuxrc (1): undefined instruction: pc=40008100
Code: e08e3003 eb002842 e2801008 e58c217c (e0812103)
Kernel panic - not syncing: Attempted to kill init!
CPU0: stopping
[<c0028950>] (dump_stack+0x0/0x14) from [<c0023384>] (do_IPI+0xd4/0x140)
[<c00232b0>] (do_IPI+0x0/0x140) from [<c0023a88>] (__irq_svc+0x48/0xdc)
Exception stack(0xc01fbf40 to 0xc01fbf88)
bf40: 00000000 c01fa000 c01fbf88 00000000 c0025754 c01fa000 00320000 00000004
bf60: c001d000 410fc090 c001dfc0 c01fbf94 c01fbf98 c01fbf88 c0025794 c0025798
bf80: 60000013 ffffffff
 r9:c01fa000 r8:00000001 r7:00000002 r6:00000401 r5:f0410100 r4:ffffffff
[<c0025754>] (default_idle+0x0/0x4c) from [<c0025634>] (cpu_idle+0x64/0x94)
[<c00255d0>] (cpu_idle+0x0/0x94) from [<c0184d38>] (rest_init+0x6c/0x80)
 r5:c021691c r4:c0223398
[<c0184ccc>] (rest_init+0x0/0x80) from [<c0008bf4>] (start_kernel+0x2f0/0x358)
[<c0008904>] (start_kernel+0x0/0x358) from [<0000807c>] (0x807c)


Trial#2:
VFS: Mounted root (ext2 filesystem).
Freeing init memory: 108K
pgd = c60bc000
[00000000] *pgd=061ee031, *pte=00000000, *ppte=00000000

Pid: 1, comm:              linuxrc
BUG: using smp_processor_id() in preemptible [00000000] code: linuxrc/1
caller is __show_regs+0x18/0x238
[<c0028950>] (dump_stack+0x0/0x14) from [<c0116120>]
(debug_smp_processor_id+0xb8/0xdc)
[<c0116068>] (debug_smp_processor_id+0x0/0xdc) from [<c00253b0>]
(__show_regs+0x18/0x238)
 r7:00000017 r6:0000000b r5:00000000 r4:c6029fb0
[<c0025398>] (__show_regs+0x0/0x238) from [<c00256ec>] (show_regs+0x40/0x50)
[<c00256ac>] (show_regs+0x0/0x50) from [<c002ad88>] (__do_user_fault+0x5c/0xa4)
 r5:00000000 r4:c6024cc0
[<c002ad2c>] (__do_user_fault+0x0/0xa4) from [<c002b050>]
(do_page_fault+0x204/0x23c)
 r7:c61f1e14 r6:c61165a0 r5:c6024cc0 r4:00010000
[<c002ae4c>] (do_page_fault+0x0/0x23c) from [<c0023448>]
(do_DataAbort+0x3c/0xa0)
[<c002340c>] (do_DataAbort+0x0/0xa0) from [<c0023ea0>]
(ret_from_exception+0x0/0x10)
Exception stack(0xc6029fb0 to 0xc6029ff8)
9fa0:                                     00000000 40021000 20000000 40020e08
9fc0: 00000000 00000050 40021000 00000000 00000000 00000001 00000000 bef31c54
9fe0: 00000000 bef31980 400090d4 40009100 00000010 ffffffff
 r8:00000000 r7:00000000 r6:40021000 r5:00000050 r4:ffffffff
CPU: 1    Not tainted  (2.6.27 #3)
PC is at 0x40009100
LR is at 0x400090d4
pc : [<40009100>]    lr : [<400090d4>]    psr: 00000010
sp : bef31980  ip : 00000000  fp : bef31c54
r10: 00000000  r9 : 00000001  r8 : 00000000
r7 : 00000000  r6 : 40021000  r5 : 00000050  r4 : 00000000
r3 : 40020e08  r2 : 20000000  r1 : 40021000  r0 : 00000000
Flags: nzcv  IRQs on  FIQs on  Mode USER_32  ISA ARM  Segment user
Control: 00c5387f  Table: 060bc00b  DAC: 00000015
[<c00256ac>] (show_regs+0x0/0x50) from [<c002ad88>] (__do_user_fault+0x5c/0xa4)
 r5:00000000 r4:c6024cc0
[<c002ad2c>] (__do_user_fault+0x0/0xa4) from [<c002b050>]
(do_page_fault+0x204/0x23c)
 r7:c61f1e14 r6:c61165a0 r5:c6024cc0 r4:00010000
[<c002ae4c>] (do_page_fault+0x0/0x23c) from [<c0023448>]
(do_DataAbort+0x3c/0xa0)
[<c002340c>] (do_DataAbort+0x0/0xa0) from [<c0023ea0>]
(ret_from_exception+0x0/0x10)
Exception stack(0xc6029fb0 to 0xc6029ff8)
9fa0:                                     00000000 40021000 20000000 40020e08
9fc0: 00000000 00000050 40021000 00000000 00000000 00000001 00000000 bef31c54
9fe0: 00000000 bef31980 400090d4 40009100 00000010 ffffffff
 r8:00000000 r7:00000000 r6:40021000 r5:00000050 r4:ffffffff
Kernel panic - not syncing: Attempted to kill init!
CPU0: stopping
[<c0028950>] (dump_stack+0x0/0x14) from [<c0023384>] (do_IPI+0xd4/0x140)
[<c00232b0>] (do_IPI+0x0/0x140) from [<c0023a88>] (__irq_svc+0x48/0xdc)
Exception stack(0xc01fbf40 to 0xc01fbf88)
bf40: 00000000 c01fa000 c01fbf88 00000000 c0025754 c01fa000 00320000 00000004
bf60: c001d000 410fc090 c001dfc0 c01fbf94 c01fbf98 c01fbf88 c0025794 c0025798
bf80: 60000013 ffffffff
 r9:c01fa000 r8:00000001 r7:00000002 r6:00000401 r5:f0410100 r4:ffffffff
[<c0025754>] (default_idle+0x0/0x4c) from [<c0025634>] (cpu_idle+0x64/0x94)
[<c00255d0>] (cpu_idle+0x0/0x94) from [<c0184d38>] (rest_init+0x6c/0x80)
 r5:c021691c r4:c0223398
[<c0184ccc>] (rest_init+0x0/0x80) from [<c0008bf4>] (start_kernel+0x2f0/0x358)
[<c0008904>] (start_kernel+0x0/0x358) from [<0000807c>] (0x807c)

On Fri, Jun 19, 2009 at 7:14 PM, Russell King - ARM
Linux<linux@arm.linux.org.uk> wrote:
> On Thu, Jun 18, 2009 at 02:48:10PM +0530, Sudeep K N wrote:
>> After mounting the rootfs in eMMC, it panics.
>> Panic log as below.  When I traced, I observed it fails while its
>> execution "run_init_process"
>> I have tried with different init process,i.e. init=/linuxrc,
>> init=/bin/busybox, init=/sbin/init
>> Even I tried initramfs and the switch_root/pivot_root to rootfs on
>> eMMC partition.
>> In all the cases, I got the same panic.
>> Can anybody help me in understanding the exact reason for this panic?
>
> Enable CONFIG_DEBUG_USER and pass user_debug=31 - that should get
> more detail on the problem that's killing init.
>



-- 
Regards,
Sudeep
