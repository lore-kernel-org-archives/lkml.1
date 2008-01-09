Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbYAIAJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbYAIAJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbYAIAJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:09:05 -0500
Received: from gw.goop.org ([64.81.55.164]:37118 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbYAIAJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:09:03 -0500
Message-ID: <4784102F.4080702@goop.org>
Date: Tue, 08 Jan 2008 16:07:11 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
References: <patchbomb.1199829603@localhost> <20080108224244.GA3768@elte.hu> <20080108231226.GA10744@elte.hu> <478405DA.40303@goop.org> <20080108232803.GA19906@elte.hu>
In-Reply-To: <20080108232803.GA19906@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> right now i'm trying to bisect this crash on 64-bit:
>
>  Calling initcall 0xffffffff80395877: pci_init+0x0/0x2b()
>  ------------[ cut here ]------------
>  kernel BUG at arch/x86/mm/pageattr_64.c:176!
>  [...]
>  Call Trace:
>   [<ffffffff8021db68>] change_page_attr_addr+0x9e/0x119
>   [<ffffffff8021d44f>] ioremap_change_attr+0x49/0x58
>   [<ffffffff8021d626>] iounmap+0xbe/0xe0
>   [<ffffffff804dfc95>] quirk_usb_early_handoff+0x396/0x3a5
>   [<ffffffff80396ea0>] pci_fixup_device+0x90/0x9e
>   [<ffffffff80395889>] pci_init+0x12/0x2b
>   [<ffffffff808c9545>] kernel_init+0xd0/0x23c
>   [<ffffffff8020bec8>] child_rip+0xa/0x12
>   [<ffffffff808c9475>] kernel_init+0x0/0x23c
>   [<ffffffff8020bebe>] child_rip+0x0/0x12
>
> config and bootlog attached.
>
> it's one of these patches:
>
>  Subject: x86: move all asm/pgtable constants into one place
>  Subject: x86: avoid name conflict for Voyager leave_mm
>  Subject: x86/pgtable: unify pagetable accessors
>   

Hm, you got the same crash the with my last attempt at this.   I'll take 
a closer look at that first patch.  The global flag differences between 
32 and 64 bit was a bit weird.

    J
