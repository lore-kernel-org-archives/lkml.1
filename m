Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532AbXLAFQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbXLAFQn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 00:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbXLAFQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 00:16:30 -0500
Received: from gate.crashing.org ([63.228.1.57]:54928 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbXLAFQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 00:16:29 -0500
Subject: Re: use of fixmap on non-x86/sh?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Paul Mundt <lethal@linux-sh.org>
Cc: Kumar Gala <galak@kernel.crashing.org>, davem@davemloft.net,
       wli@holomorphy.com, mingo@redhat.com, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071201010350.GA15027@linux-sh.org>
References: <D16EA8BE-3C87-4345-8832-AB6112EE0FEA@kernel.crashing.org>
	 <20071201010350.GA15027@linux-sh.org>
Content-Type: text/plain
Date: Sat, 01 Dec 2007 16:15:37 +1100
Message-Id: <1196486137.13230.128.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-01 at 10:03 +0900, Paul Mundt wrote:
> There are of course things that make this more attractive on x86,
> especially with regards to the global bit and preservation across a
> TLB
> flush, there's a note in arch/sh/mm/init.c above __set_fixmap() about
> that. fixmap doesn't really have any special behaviour that makes an
> architecture implementation problematic at least.

On ppc, we are mostly looking into memory mapped config space, which for
some new PCIe bridges is huge (about 512M per port on the 440SPe). Those
processors have 36 bits physical addresses and 32 bits virtual.

So I suppose we can just move our current kmap_atomic implementation out
of highmem, call it fixmap, and add a slot for use by PCI config space
access (those are fully spinlocked, so the per-cpu aspect is just what
we need, just like kmap_atomic).

Ben.


