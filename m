Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbXD3Kar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbXD3Kar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbXD3K3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:29:34 -0400
Received: from ns2.suse.de ([195.135.220.15]:43048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965512AbXD3K2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:28:15 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [39/40] i386: Export paravirt_ops for non GPL modules too
Message-Id: <20070430102814.7E56E151D2@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:28:14 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Otherwise non GPL modules cannot even do basic operations
like disabling interrupts anymore, which would be excessive.

Longer term should split the single structure up into
internal and external symbols and not export the internal
ones at all.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/paravirt.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

Index: linux/arch/i386/kernel/paravirt.c
===================================================================
--- linux.orig/arch/i386/kernel/paravirt.c
+++ linux/arch/i386/kernel/paravirt.c
@@ -346,10 +346,4 @@ struct paravirt_ops paravirt_ops = {
 	.startup_ipi_hook = paravirt_nop,
 };
 
-/*
- * NOTE: CONFIG_PARAVIRT is experimental and the paravirt_ops
- * semantics are subject to change. Hence we only do this
- * internal-only export of this, until it gets sorted out and
- * all lowlevel CPU ops used by modules are separately exported.
- */
-EXPORT_SYMBOL_GPL(paravirt_ops);
+EXPORT_SYMBOL(paravirt_ops);
