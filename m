Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZF3Kw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZF3Kw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 06:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbZF3KwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 06:52:21 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:43817 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbZF3KwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 06:52:20 -0400
Message-Id: <4A4A0A8702000078000082E8@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 30 Jun 2009 11:52:23 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
Cc: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix fixmap ordering
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The merge of the 32- and 64-bit fixmap headers made a latent bug on
x86-64 a real one ix86: With the right config settings it is possible
for FIX_OHCI1394_BASE to overlap the FIX_BTMAP_* range.

Likely also a 2.6.30.x candidate.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/fixmap.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.31-rc1/arch/x86/include/asm/fixmap.h	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.31-rc1-x86-fixmap/arch/x86/include/asm/fixmap.h	2009-06-24 15:12:43.000000000 +0200
@@ -114,9 +114,6 @@ enum fixed_addresses {
 	FIX_TEXT_POKE0,	/* reserve 2 pages for text_poke() */
 	FIX_TEXT_POKE1,
 	__end_of_permanent_fixed_addresses,
-#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
-	FIX_OHCI1394_BASE,
-#endif
 	/*
 	 * 256 temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.
@@ -129,6 +126,9 @@ enum fixed_addresses {
 	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
 			(__end_of_permanent_fixed_addresses & 255),
 	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_SLOTS - 1,
+#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
+	FIX_OHCI1394_BASE,
+#endif
 #ifdef CONFIG_X86_32
 	FIX_WP_TEST,
 #endif



