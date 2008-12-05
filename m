Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbYLENCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbYLENCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYLENCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:02:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56340 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbYLENCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:02:00 -0500
Date: Fri, 5 Dec 2008 14:01:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [trivial] fix missing space in printk
Message-ID: <20081205130149.GA15851@elte.hu>
References: <4939139C.8090806@msgid.tls.msk.ru> <20081205121046.GA28662@elte.hu> <493922E1.4050501@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493922E1.4050501@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Tokarev <mjt@tls.msk.ru> wrote:

> > 
> > btw., the reason for that bug was the incorrect line break in the 
> > middle of a string - we humans just dont notice a missing space in 
> > that context.
> > 
> > So in the final commit i've moved the string to a single line, see it 
> > attached below.
> 
> Oh well.  Thanks.  There's another very similar thing in
> arch/x86/kernel/pci-dma.c, via_no_dac() (attached).

applied - see below. I guess it has your signoff, correct?

> By the way, where such tiny/trivial things should go?

if it touches x86 code, then they can go via the x86 tree.

	Ingo

---------------->
>From a0286c94f07636380082608196d41dd725a83229 Mon Sep 17 00:00:00 2001
From: Michael Tokarev <mjt@tls.msk.ru>
Date: Fri, 5 Dec 2008 15:47:29 +0300
Subject: [PATCH] x86: fix missing space in printk, #2

Impact: clean up printk

Signed-off-by: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/pci-dma.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 1926248..dc57299 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -300,8 +300,8 @@ fs_initcall(pci_iommu_init);
 static __devinit void via_no_dac(struct pci_dev *dev)
 {
 	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI && forbid_dac == 0) {
-		printk(KERN_INFO "PCI: VIA PCI bridge detected."
-				 "Disabling DAC.\n");
+		printk(KERN_INFO
+			"PCI: VIA PCI bridge detected. Disabling DAC.\n");
 		forbid_dac = 1;
 	}
 }
