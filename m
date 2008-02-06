Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbYBFUdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbYBFUdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 15:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbYBFUdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 15:33:35 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:25431 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbYBFUde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 15:33:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=a9S/hYy1fmDOKdpljf9hO0N9Q+GV5h+vu0Wp3lx68zlXrQr0O3jKnPwSjet/EQKRYnHAsQm099YnYicGQm8CJhPKdj+cPU2Qakty5EC/gilEDsAqWagbH4IxhJAdV1IgaqSkK7k0GX7AYTAurkNiUX/JucHp7utUgXIoVijD+Es=
Message-ID: <84144f020802061233g70eebd88v1ab898c00bdb775@mail.gmail.com>
Date: Wed, 6 Feb 2008 22:33:33 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: kerndev@sc-software.com
Subject: Re: Bug: 2.6.24-smp: Eeek! page_mapcount(page) went negative! (-1)
Cc: "Hugh Dickins" <hugh@veritas.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0802061214550.4601@sc-software.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802061003370.4601@sc-software.com>
	 <Pine.LNX.4.64.0802061948380.32204@blonde.site>
	 <Pine.LNX.4.64.0802061214550.4601@sc-software.com>
X-Google-Sender-Auth: 3c305eb6e0612af4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Feb 6, 2008 10:21 PM,  <kerndev@sc-software.com> wrote:
> From reboot after last hang on 02/03/08, I found this...
>
> Feb  5 23:26:26 sc-software kernel: ------------[ cut here ]------------
> Feb  5 23:26:26 sc-software kernel: kernel BUG at mm/slab.c:591!
> Feb  5 23:26:26 sc-software kernel: invalid opcode: 0000 [#1] PREEMPT SMP
> Feb  5 23:26:26 sc-software kernel: Modules linked in: shpchp pci_hotplug ohci1394 ieee1394
> Feb  5 23:26:26 sc-software kernel:
> Feb  5 23:26:26 sc-software kernel: Pid: 6040, comm: modprobe Not tainted (2.6.24 #1)
> Feb  5 23:26:26 sc-software kernel: EIP: 0060:[<c017960f>] EFLAGS: 00010046 CPU: 1
> Feb  5 23:26:26 sc-software kernel: EIP is at kfree+0x8f/0xa0
> Feb  5 23:26:26 sc-software kernel: EAX: 40000000 EBX: f5915380 ECX: c1bb4498 EDX: c1bb4498
> Feb  5 23:26:26 sc-software kernel: ESI: eff354a0 EDI: f5815280 EBP: f0067e78 ESP: f0067e68
> Feb  5 23:26:26 sc-software kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Feb  5 23:26:26 sc-software kernel: Process modprobe (pid: 6040, ti=f0066000 task=f00b5550 task.ti=f0066000)
> Feb  5 23:26:26 sc-software kernel: Stack: 00000282 f5915380 eff354a0 b7fb87b0 f0067f1c c01ac9ac 00000003 00001812
> Feb  5 23:26:26 sc-software kernel:        f0067e98 0805ba64 00000418 0805ba64 f0067eb4 0805ba64 00001812 00000000
> Feb  5 23:26:26 sc-software kernel:        f5815280 00000001 00000000 0805be7c 0805ba64 0805aa64 08048000 00000000
> Feb  5 23:26:26 sc-software kernel: Call Trace:
> Feb  5 23:26:26 sc-software kernel:  [<c0103e5a>] show_trace_log_lvl+0x1a/0x30
> Feb  5 23:26:26 sc-software kernel:  [<c0103f2a>] show_stack_log_lvl+0x9a/0xc0
> Feb  5 23:26:26 sc-software kernel:  [<c01040d7>] show_registers+0xc7/0x250
> Feb  5 23:26:26 sc-software kernel:  [<c010441f>] die+0x11f/0x220
> Feb  5 23:26:26 sc-software kernel:  [<c01045b1>] do_trap+0x91/0xd0
> Feb  5 23:26:26 sc-software kernel:  [<c0104859>] do_invalid_op+0x89/0xa0
> Feb  5 23:26:26 sc-software kernel:  [<c0657c22>] error_code+0x72/0x78
> Feb  5 23:26:26 sc-software kernel:  [<c01ac9ac>] load_elf_binary+0x8cc/0xcf0
> Feb  5 23:26:26 sc-software kernel:  [<c0181864>] search_binary_handler+0xc4/0x250
> Feb  5 23:26:26 sc-software kernel:  [<c0181b35>] do_execve+0x145/0x190
> Feb  5 23:26:26 sc-software kernel:  [<c0101c82>] sys_execve+0x32/0xa0
> Feb  5 23:26:26 sc-software kernel:  [<c0103102>] syscall_call+0x7/0xb

This means we pass a non-slab pointer from load_elf_binary() to
kfree() which doesn't seem likely to be a software bug reading the
code. As Hugh suggested, please run memtest86+.
