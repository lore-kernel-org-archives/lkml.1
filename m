Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbXDFTgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbXDFTgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbXDFTgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:36:33 -0400
Received: from www.osadl.org ([213.239.205.134]:33855 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751932AbXDFTgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:36:32 -0400
Subject: Re: [PATCH] Deprecate SA_xxx interrupt flags -V2
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070406122228.3dc06c79.akpm@linux-foundation.org>
References: <20070114081905.135797900@inhelltoy.tec.linutronix.de>
	 <20070114081926.912658228@inhelltoy.tec.linutronix.de>
	 <20070123120245.ec3b0772.akpm@osdl.org>
	 <1169584278.21181.86.camel@localhost.localdomain>
	 <1175867366.28263.454.camel@localhost.localdomain>
	 <20070406122228.3dc06c79.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 21:36:57 +0200
Message-Id: <1175888217.28263.465.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 12:22 -0700, Andrew Morton wrote:
> Yeah.  I tried something like this and code broke.  For example,
> arch/mips/sni/irq.c has
> 
> struct irqaction sni_isa_irq = {
> 	.handler = sni_isa_irq_handler,
> 	.name = "ISA",
> 	.flags = SA_SHIRQ
> };

Grr. I fixed that one at least once.

> there are presumably only a few such stragglers left in the tree but there
> are probably more instances out-of-tree.
>
> But I think we should just apply your patch anyway.  Only a small
> proportion of things will break and we do need to be rid of the old
> definitions one day.

For above use cases there is no way of emiting a deprecation warning.
OTOH it leads the user directly to the place, where he can find the fix.
Removing them completely might leave folks clueless.

> It would be great if someone could do another pass across the tree,
> clean up the remaining SA_* usages.

The above seems the only one in Linus tree. I check -mm as well.

	tglx


