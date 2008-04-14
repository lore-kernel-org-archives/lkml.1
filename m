Return-Path: <linux-kernel-owner+w=401wt.eu-S1761370AbYDNVEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbYDNVEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 17:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbYDNVE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 17:04:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33065
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752216AbYDNVE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 17:04:28 -0400
Date: Mon, 14 Apr 2008 14:04:28 -0700 (PDT)
Message-Id: <20080414.140428.52588590.davem@davemloft.net>
To: m.kozlowski@tuxland.pl
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sparc64 2.6.25-rc7 bug: kswapd oops
From: David Miller <davem@davemloft.net>
In-Reply-To: <200804142219.03962.m.kozlowski@tuxland.pl>
References: <200804142219.03962.m.kozlowski@tuxland.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date: Mon, 14 Apr 2008 22:19:03 +0200

This one looks like it might not be sparc64 specific, so CC:'ing
linux-kernel.

> 	I got this on 2.6.25-rc7 when the box was under heavy load. I was compiling
> kernel and (unfortunately) at the same time upgrading system. So ... the box went oops
> and I'm left with unusable box due to missing coreutils :) As soon as I bring it back
> to life I'll try to reproduce that on 2.6.25-rc9. It seems it happend when the box
> was running out of ram and started (or was close to) swapping. Hm ... not sure though.
> I'll get back if I get anything more substantial.
> 
 ...
> Unable to handle kernel NULL pointer dereference
> tsk->{mm,active_mm}->context = 00000000000019db
> tsk->{mm,active_mm}->pgd = fffff8008ea56000
>               \|/ ____ \|/
>               "@'/ .. \`@"
>               /_| \__/ |_\
>                  \__U_/
> kswapd0(140): Oops [#1]
> TSTATE: 0000008880009602 TPC: 00000000004d91ec TNPC: 00000000004d91f0 Y: 00000000    Not tainted
> TPC: <prune_dcache+0xb4/0x220>
> g0: fffff800bf1d71d1 g1: 0000000000762288 g2: 0000000000000000 g3: fffff800afb5f140
> g4: fffff800bf0ae900 g5: fffff8007f94c000 g6: fffff800bf1d4000 g7: 0000000000000001
> o0: 0000000000000000 o1: 0000000000000001 o2: 0000000000000001 o3: fffff800bf1d78e0
> o4: 0000000000811800 o5: 000000000000000f sp: fffff800bf1d7241 ret_pc: 00000000004d9160
> RPC: <prune_dcache+0x28/0x220>
> l0: fffff800afb5f100 l1: fffff800bf4b6fc0 l2: fffff800afb5ebb8 l3: 0000000000762000
> l4: 0000000000762000 l5: 0000000000786c00 l6: 00000000007608c0 l7: 0000000000000008
> i0: 0000000000000021 i1: 0000000000000000 i2: 0000000000000000 i3: 0000000000000000
> i4: 0000000000000000 i5: 000000000000000f i6: fffff800bf1d7301 i7: 00000000004d93b4
> I7: <shrink_dcache_memory+0x5c/0x80>
> Caller[00000000004d93b4]: shrink_dcache_memory+0x5c/0x80
> Caller[00000000004a8704]: shrink_slab+0xec/0x200
> Caller[00000000004a8c28]: kswapd+0x410/0x500
> Caller[0000000000481780]: kthread+0x48/0x80
> Caller[0000000000427290]: kernel_thread+0x38/0x60
> Caller[0000000000481a08]: kthreadd+0x150/0x1c0
> Instruction DUMP: c258c000  c458e008  c4706008 <c2708000> c670e008  c670c000  c25ce290  c7684000  29001d88 
> note: kswapd0[140] exited with preempt_count 1
> --
> To unsubscribe from this list: send the line "unsubscribe sparclinux" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
