Return-Path: <linux-kernel-owner+w=401wt.eu-S1760743AbXGaWQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743AbXGaWQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbXGaWQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:16:43 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4802 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbXGaWQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:16:42 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 79] arch/i386/mach-voyager/voyager_cat.c: kmalloc + memset conversion to kzalloc
Date: Wed, 1 Aug 2007 00:16:42 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       J.E.J.Bottomley@hansenpartnership.com
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708010016.42984.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 arch/i386/mach-voyager/voyager_cat.c | 35688 -> 35576 (-112 bytes)
 arch/i386/mach-voyager/voyager_cat.o | 151452 -> 150992 (-460 bytes)

 arch/i386/mach-voyager/voyager_cat.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- linux-2.6.23-rc1-mm1-a/arch/i386/mach-voyager/voyager_cat.c	2007-07-26 13:07:46.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/arch/i386/mach-voyager/voyager_cat.c	2007-07-31 12:51:54.000000000 +0200
@@ -648,20 +648,18 @@ voyager_cat_init(void)
 		}
 		CDEBUG(("VOYAGER DEBUG: found module id 0x%x, %s\n", i,
 			cat_module_name(i)));
-		*modpp = kmalloc(sizeof(voyager_module_t), GFP_KERNEL); /*&voyager_module_storage[cat_count++];*/
-		if(*modpp == NULL) {
+		*modpp = kzalloc(sizeof(voyager_module_t), GFP_KERNEL); /*&voyager_module_storage[cat_count++];*/
+		if (!*modpp) {
 			printk("**WARNING** kmalloc failure in cat_init\n");
 			continue;
 		}
-		memset(*modpp, 0, sizeof(voyager_module_t));
 		/* need temporary asic for cat_subread.  It will be
 		 * filled in correctly later */
-		(*modpp)->asic = kmalloc(sizeof(voyager_asic_t), GFP_KERNEL); /*&voyager_asic_storage[asic_count];*/
-		if((*modpp)->asic == NULL) {
+		(*modpp)->asic = kzalloc(sizeof(voyager_asic_t), GFP_KERNEL); /*&voyager_asic_storage[asic_count];*/
+		if (!(*modpp)->asic) {
 			printk("**WARNING** kmalloc failure in cat_init\n");
 			continue;
 		}
-		memset((*modpp)->asic, 0, sizeof(voyager_asic_t));
 		(*modpp)->asic->asic_id = VOYAGER_CAT_ID;
 		(*modpp)->asic->subaddr = VOYAGER_SUBADDR_HI;
 		(*modpp)->module_addr = i;
