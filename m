Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbZF2IyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbZF2IyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 04:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbZF2IyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 04:54:02 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:60866 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbZF2IyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 04:54:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ToO0fDc1ZFcfXSXIwyhiDPYtigS8ScGPIdsDfP2FPuXGvKL5F/a3/o2eaxba6heR5g
         fUFgtUBwaGRBSuRUiEw5j4PXlvR4CgKK4rmWplYyzUOrcRPb4Bwjw0dKCN89WKH8Ir2P
         Ayqkl7VIY3MmaE2JVbeYNOjkCBFyVPeDA8d2E=
MIME-Version: 1.0
In-Reply-To: <2375c9f90906281908k7aa089a3v932dd368d572194b@mail.gmail.com>
References: <a5d9929e0906270807s4c0ef74ap2296dce4c790ea9a@mail.gmail.com> 
	<2375c9f90906281908k7aa089a3v932dd368d572194b@mail.gmail.com>
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Mon, 29 Jun 2009 09:53:41 +0100
Message-ID: <a5d9929e0906290153g305427c6j37f96db060cb4738@mail.gmail.com>
Subject: Re: Crashes during boot on 2.6.30 / 2.6.31-rc, random programs
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Well, it doesnt complain about MAX_STACK_TRACE_ENTRIES anymore, but
now it gives me:

BUG: MAX_LOCK_DEPTH too low!
turning off the locking correctness validator.
Pid: 1672, comm: qemu-kvm Not tainted 2.6.30-wl #2
Call Trace:
 [<c07da76f>] ? printk+0x22/0x3b
 [<c0463de9>] __lock_acquire+0xa77/0xb05
 [<c0463f2e>] lock_acquire+0xb7/0xeb
 [<c04be96c>] ? mm_take_all_locks+0xb3/0xf1
 [<c04be96c>] ? mm_take_all_locks+0xb3/0xf1
 [<c07dd476>] _spin_lock_nest_lock+0x30/0x71
 [<c04be96c>] ? mm_take_all_locks+0xb3/0xf1
 [<c04be96c>] mm_take_all_locks+0xb3/0xf1
 [<c04cc741>] do_mmu_notifier_register+0x9f/0x14e
 [<c04cc83d>] mmu_notifier_register+0x1e/0x31
 [<f9e461b8>] kvm_dev_ioctl+0xfd/0x25d [kvm]
 [<f9e460bb>] ? kvm_dev_ioctl+0x0/0x25d [kvm]
 [<c04e4df6>] vfs_ioctl+0x29/0x91
 [<c04e52f4>] do_vfs_ioctl+0x496/0x4e3
 [<c07dfb82>] ? do_page_fault+0x229/0x26a
 [<c0408e41>] ? sched_clock+0x9/0xd
 [<c0461218>] ? lock_release_holdtime+0x39/0x143
 [<c07dfb82>] ? do_page_fault+0x229/0x26a
 [<c04e5396>] sys_ioctl+0x55/0x86
 [<c04037f3>] sysenter_do_call+0x12/0x38

which looks like its younger brother :-). (Also appears on other
programs, not just qemu-kvm)

Should i increase its value too? Am i not just masking something else
by doing this?

Thank you for your time,
Joao Correia
Centro de Informatica
Universidade da Beira Interior
Portugal

On Mon, Jun 29, 2009 at 3:08 AM, Américo Wang<xiyou.wangcong@gmail.com> wrote:
> On Sat, Jun 27, 2009 at 11:07 PM, Joao
> Correia<joaomiguelcorreia@gmail.com> wrote:
>> Hello
>>
>
> Hello,
>
>> Since midway through the 2.6.30 series, and continuing on the rc1 for
>> .31, im having this at every boot, during the boot process:
>>
>> (...)
>> Jun 26 21:07:03 hightech kernel: NET: Registered protocol family 10
>> Jun 26 21:07:03 hightech kernel: lo: Disabled Privacy Extensions
>> Jun 26 21:07:03 hightech kernel: BUG: MAX_STACK_TRACE_ENTRIES too low!
>> Jun 26 21:07:03 hightech kernel: turning off the locking correctness validator.
>> Jun 26 21:07:03 hightech kernel: Pid: 672, comm: modprobe Not tainted
>> 2.6.31-rc1 #1
>
> Could you please try the patch from Ingo below?
>
> http://article.gmane.org/gmane.linux.kernel/852005
>
> Does it help?
>
> That value was already doubled from 131072 when the last time it was seen. :)
>
> Thanks.
>
