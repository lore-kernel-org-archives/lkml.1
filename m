Return-Path: <linux-kernel-owner+w=401wt.eu-S1758537AbYGRM2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537AbYGRM2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755840AbYGRM2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:28:38 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:30156 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbYGRM2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:28:37 -0400
Message-Id: <4880A8AC.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 18 Jul 2008 13:29:00 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: reduce boot fixmap space
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As 256 entries are needed, aligning to a 256-entry boundary is
sufficient and still guarantees the single pte table requirement.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 include/asm-x86/fixmap_32.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.26/include/asm-x86/fixmap_32.h	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-i386-btmap-fixmaps/include/asm-x86/fixmap_32.h	2008-07-18 13:51:16.000000000 +0200
@@ -94,13 +94,13 @@ enum fixed_addresses {
 	 * 256 temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.
 	 *
-	 * We round it up to the next 512 pages boundary so that we
+	 * We round it up to the next 256 pages boundary so that we
 	 * can have a single pgd entry and a single pte table:
 	 */
 #define NR_FIX_BTMAPS		64
 #define FIX_BTMAPS_NESTING	4
-	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 512 -
-			(__end_of_permanent_fixed_addresses & 511),
+	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
+			(__end_of_permanent_fixed_addresses & 255),
 	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_NESTING - 1,
 	FIX_WP_TEST,
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT



