Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbXJ0UcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbXJ0UcS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 16:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbXJ0UcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 16:32:08 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45279 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbXJ0UcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 16:32:07 -0400
Date: Sat, 27 Oct 2007 22:32:04 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
In-Reply-To: <20071027202449.GF9816@martell.zuzino.mipt.ru>
Message-ID: <Pine.LNX.4.64.0710272227580.30465@fbirervta.pbzchgretzou.qr>
References: <20071020235546.GB1825@martell.zuzino.mipt.ru>
 <Pine.LNX.4.64.0710251734190.17781@fbirervta.pbzchgretzou.qr>
 <20071027202449.GF9816@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 28 2007 00:24, Alexey Dobriyan wrote:
>
>> (Which would be the logical choice if it were a function and not a 
>> macro...) That would flag up all violations ("without cast to different 
>> pointer" or so) while usually not breaking compilation.
>> 
>> Of course, irq_flags_t is probably the best long-term solution if one 
>> wants to hide a struct. (Even then perhaps, use a pointer instead?)
>
>IIRC, Christoph mentioned:
>
>	irq_flags_t flags;
>
>	flags = spin_lock_irqXXX(&lock);
>	spin_unlock_irqYYY(&lock, flags);
>
>where XXX and YYY are still to be found good names :^) It's also a solution
>without flag day and with more sane lock part -- "how flags are modified
>if they are passed by value?"
>
>I start to like this proposal but I can't come up with good names.
>

The BSD way: just add a number -- spin_lock_irq2()
Of course names are preferable.

	irq_spin_lock and irq_spin_unlock?
	spinirq_lock, spinirq_unlock?
	spin_lock_irq_disable, spin_lock_irq_enable (a bit verbose...)

Maybe the 'irq' part should be completely dropped from the name,
as with -rt extensions, it behaves differently, does not it?
(Or was it preemption?)
If it was a home project, I'd just flag it, if it was a business project,
I'd add the number, for Linux - ha, too big for me :-)
