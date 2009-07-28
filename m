Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbZG1XuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbZG1XuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZG1XuC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:50:02 -0400
Received: from kroah.org ([198.145.64.141]:35767 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbZG1Xt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:59 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:55 2009
Message-Id: <20090728234155.770466893@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 30/71] x86: Fix fixmap ordering
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=x86-fix-fixmap-ordering.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Beulich <JBeulich@novell.com>

commit 789d03f584484af85dbdc64935270c8e45f36ef7 upstream.

The merge of the 32- and 64-bit fixmap headers made a latent
bug on x86-64 a real one: with the right config settings
it is possible for FIX_OHCI1394_BASE to overlap the FIX_BTMAP_*
range.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4A4A0A8702000078000082E8@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/fixmap.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
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


