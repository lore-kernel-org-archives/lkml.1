Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYBQDlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYBQDlF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 22:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYBQDkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 22:40:55 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:37805 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbYBQDky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 22:40:54 -0500
Message-ID: <47B7ACBE.1090904@linux.vnet.ibm.com>
Date: Sun, 17 Feb 2008 09:10:46 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux390@de.ibm.com, linux-s390@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] 2.6.25-rc2-mm1 - kernel oops while bootup on s390x
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B70C3A.4050600@linux.vnet.ibm.com> <20080216114527.48408288.akpm@linux-foundation.org> <alpine.LFD.1.00.0802162048120.7583@apollo.tec.linutronix.de> <alpine.LFD.1.00.0802162050020.7583@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802162050020.7583@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Sat, 16 Feb 2008, Thomas Gleixner wrote:
>> On Sat, 16 Feb 2008, Andrew Morton wrote:
>>>> The 2.6.25-rc2-mm1 kernel panic's while boot up on the s390x
>>>>
>>>> Unable to handle kernel pointer dereference at virtual kernel address 0000000000
>>>> 000000
>>>> Oops: 0004 #1¨ SMP
>>> First question is: does this happen in current mainline?

This is not happening with the current mainline 2.6.24.{1,2}.
>>>
>>> If not, it would be useful if someone could test futex-fix-init-order.patch
>>> and futex-runtime-enable-pi-and-robust-functionality.patch on curent
>>> mainline, because those are planned for 2.6.25.
>> See: http://lkml.org/lkml/2008/2/16/109
>>
>> It unearthed a BUG in the S390 exception fixup tables :)
> 
> Oops, wrong reference.
> 
>       http://lkml.org/lkml/2008/2/16/95
> 
> Thanks,
> 	tglx

To conform the patches causing the panic, I tested the 2.6.24.2 kernel with the futex-fix-init-order.patch and
futex-runtime-enable-pi-and-robust-functionality.patch applied and they seem to cause the kernel
panic.

Unable to handle kernel pointer dereference at virtual kernel address 0000000000
000000
Oops: 0004 #1¨ SMP
Modules linked in:
CPU: 0 Not tainted 2.6.25-rc2-mm1-autotest #1
Process swapper (pid: 1, task: 000000003f830000, ksp: 000000003f83ba48)
Krnl PSW : 0704a00180000000 000000000024b2be (futex_atomic_cmpxchg_std+0x12/0x28
)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:2 CC:2 PM:0 EA:3
Krnl GPRS: 0000000000000074 00000000fffffff2 0000000000000000 0000000000000000
           0000000000000000 0000000000000001 0000000000000000 00000000004d0764
           0000000000000000 00000000004d8768 0000000000000000 000000003f83bdb0
           0000000000000040 0000000000343950 00000000000627e4 000000003f83bdb0
Krnl Code: 000000000024b2b2: b90400bf           lgr     %r11,%r15
           000000000024b2b6: a718fff2           lhi     %r1,-14
           000000000024b2ba: b2790100           sacf    256
          >000000000024b2be: ba342000           cs      %r3,%r4,0(%r2)
           000000000024b2c2: 1813               lr      %r1,%r3
           000000000024b2c4: b2790000           sacf    0
           000000000024b2c8: b9140021           lgfr    %r2,%r1
           000000000024b2cc: e3b0b0700004       lg      %r11,112(%r11)
Call Trace:
(<000000003f83bda8>¨ 0x3f83bda8)
 <00000000004bdeec>¨ init+0x30/0x104
 <00000000004b0c40>¨ kernel_init+0x1e0/0x370
 <000000000001a5c6>¨ kernel_thread_starter+0x6/0xc
 <000000000001a5c0>¨ kernel_thread_starter+0x0/0xc

 <4>--- end trace 561bb236c800851f ¨---
note: swapper1¨ exited with preempt_count 1
Kernel panic - not syncing: Attempted to kill init!

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
