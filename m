Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbYBDGpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbYBDGpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 01:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYBDGp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 01:45:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38705 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbYBDGp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 01:45:29 -0500
Date: Mon, 4 Feb 2008 08:20:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Russell Leidich <rml@google.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       valdis.kletnieks@vt.edu
Subject: Re: [PATCH] Remove Barcelona Thermal Throttling
Message-ID: <20080204072013.GB571@one.firstfloor.org>
References: <3f1a065b0802032213j713fe551t9a0642ea2b83994@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f1a065b0802032213j713fe551t9a0642ea2b83994@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 10:13:53PM -0800, Russell Leidich wrote:
> All,
> 
> You can imagine my dismay when I recently learned that, after all our
> collective effort, hardware thermal throttling does not work reliably
> on Barcelona, according to AMD.  Due to NDA restrictions, I am unable
> to provide further details.

Too bad. Hopefully that code will work then on the hypothetic
future parts with fixed throttling. Perhaps it would be better
to just remove it now and readd later.

All this reminds me you need to adjust the Kconfig dependencies
for K8_NB too to be always enabled with MCE_AMD.

Ideally on top of this patch with a || MCE_AMD

-Andi

---

Fix and simplify k8.c Kconfig dependencies

- Check for K8_NUMA instead of NUMA && PCI
- No need to check for x86_64 explicitely

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -1540,7 +1540,7 @@ endif # X86_32
 
 config K8_NB
 	def_bool y
-	depends on AGP_AMD64 || (X86_64 && (GART_IOMMU || (PCI && NUMA)))
+	depends on AGP_AMD64 || GART_IOMMU || K8_NUMA
 
 source "drivers/pcmcia/Kconfig"
 
