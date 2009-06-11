Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbZFKQ3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbZFKQ3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbZFKQ25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:28:57 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48522 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbZFKQ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:28:56 -0400
Subject: Re: [PATCH] init: setup traps before mem_init()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0906111622510.13992@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0906111622510.13992@melkki.cs.Helsinki.FI>
Date: Thu, 11 Jun 2009 19:28:57 +0300
Message-Id: <1244737737.6281.8.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 16:25 +0300, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> 32-bit x86 does WP protect test in mem_init() so we must setup traps before we
> call mem_init() during boot. This patch should fix the following bug 
> reported by Ingo Molnar:
> 
>   We have a hard crash in the WP-protect code:
> 
>   [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...BUG: Int 14: CR2 ffcff000
>   [    0.000000]      EDI 00000188  ESI 00000ac7  EBP c17eaf9c  ESP c17eaf8c
>   [    0.000000]      EBX 000014e0  EDX 0000000e  ECX 01856067  EAX 00000001
>   [    0.000000]      err 00000003  EIP c10135b1   CS 00000060  flg 00010002
>   [    0.000000] Stack: c17eafa8 c17fd410 c16747bc c17eafc4 c17fd7e5 000011fd f8616000 c18237cc
>   [    0.000000]        00099800 c17bb000 c17eafec c17f1668 000001c5 c17f1322 c166e039 c1822bf0
>   [    0.000000]        c166e033 c153a014 c18237cc 00020800 c17eaff8 c17f106a 00020800 01ba5003
>   [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.30-tip-02161-g7a74539-dirty #52203
>   [    0.000000] Call Trace:
>   [    0.000000]  [<c15357c2>] ? printk+0x14/0x16
>   [    0.000000]  [<c10135b1>] ? do_test_wp_bit+0x19/0x23
>   [    0.000000]  [<c17fd410>] ? test_wp_bit+0x26/0x64
>   [    0.000000]  [<c17fd7e5>] ? mem_init+0x1ba/0x1d8
>   [    0.000000]  [<c17f1668>] ? start_kernel+0x164/0x2f7
>   [    0.000000]  [<c17f1322>] ? unknown_bootoption+0x0/0x19c
>   [    0.000000]  [<c17f106a>] ? __init_begin+0x6a/0x6f
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

OK, I tested this on 32-bit and it works just fine.

			Pekka

