Return-Path: <linux-kernel-owner+w=401wt.eu-S1767817AbXCJEcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767817AbXCJEcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767815AbXCJEcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:32:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33117 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767813AbXCJEbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:31:48 -0500
Subject: [RFC PATCH 2/3] Update mtd use of symbol_(get|put)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: rusty@rustcorp.com.au
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 10 Mar 2007 02:31:43 -0200
Message-Id: <1173501103.26213.406.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trent Piepho <xyzzy@speakeasy.org>

Make the mtd sub-system work with changes to __symbol_get().  mtd calls
__symbol_get() directly, rather than through the symbol_get() macro
because it uses a string it created with sprintf to specify the symbol
to
attach to.  It needs to be updated to supply THIS_MODULE as the user
parameter added to __symbol_get().

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>

diff --git a/drivers/mtd/chips/gen_probe.c
b/drivers/mtd/chips/gen_probe.c
--- a/drivers/mtd/chips/gen_probe.c
+++ b/drivers/mtd/chips/gen_probe.c
@@ -211,10 +211,10 @@ static inline struct mtd_info *cfi_cmdse
 
 	sprintf(probename, MODULE_SYMBOL_PREFIX "cfi_cmdset_%4.4X", type);
 
-	probe_function = __symbol_get(probename);
+	probe_function = __symbol_get(probename, THIS_MODULE);
 	if (!probe_function) {
 		request_module(probename + sizeof(MODULE_SYMBOL_PREFIX) - 1);
-		probe_function = __symbol_get(probename);
+		probe_function = __symbol_get(probename, THIS_MODULE);
 	}
 
 	if (probe_function) {


