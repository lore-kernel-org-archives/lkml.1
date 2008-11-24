Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYKXSFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYKXSFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 13:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYKXSFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 13:05:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33271 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbYKXSFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 13:05:21 -0500
Message-ID: <492AECC2.50202@zytor.com>
Date: Mon, 24 Nov 2008 10:04:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@mailshack.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86: introduce ENTRY(KPROBE)_X86  assembly helpers
 to catch unbalanced declaration
References: <20081123175125.GA32472@uranus.ravnborg.org> <20081123175846.GF12710@localhost> <20081123181248.GA338@uranus.ravnborg.org> <20081123182103.GH12710@localhost> <20081123185417.GA21106@elte.hu> <20081123185726.GL12710@localhost> <20081123190025.GD21106@elte.hu> <20081123192243.GP12710@localhost> <20081123193133.GA2794@elte.hu> <20081123194828.GQ12710@localhost> <20081124091031.GA8187@mailshack.com>
In-Reply-To: <20081124091031.GA8187@mailshack.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> 
> The problem is that ENTRY(interrupt) is done in init.rodata, and
> ENTRY(irq_entries_start) is done in .text. So inside the .S-file,
> they are nested, but in the .o-file they are separate. Instead of
> removing ENTRY(irq_entries_start), I think we should just expand to:
> 
> 	.section .init.rodata,"a"
> 	.p2align 5
> 	.global interrupt
> interrupt:
> 
> and
> 
> 	size interrupt, .-interrupt
> 
> But the only importance I can think of is that this keeps both
> the "interrupt" array and irq_entries_start visible in debugging
> information.
> 
> Alternatively, we could probably do away with the interrupt
> array entirely. We _know_ how the irq stubs are structured and
> irq_entries_start is in principle enough information to reconstruct
> all information in interrupt.
> 

I'd rather not get rid of the interrupt array.  But more fundamentally,
interrupt is a data symbol, not an entry point.

	-hpa
