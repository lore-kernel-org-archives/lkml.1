Return-Path: <linux-kernel-owner+w=401wt.eu-S1030300AbXBTRFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030300AbXBTRFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030299AbXBTREl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:04:41 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:54977 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030297AbXBTREi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:04:38 -0500
Date: Tue, 20 Feb 2007 11:56:38 -0500
From: Jeff Dike <jdike@addtoit.com>
To: akpm@osdl.org
Cc: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>,
       linux-kernel@vger.kernel.org, user-mode-linux@lists.sourceforge.net
Subject: [PATCH 3/3] UML - pte_mkread fix
Message-ID: <20070220165638.GA6254@ccure.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the fact that pte_mkread set _PAGE_RW instead of _PAGE_USER (the logic is
copied from i386 in most place, so it is really as bad as you're thinking).

Thus currently page tables are more permissive than they should.

Such a change may trigger other latent bugs, so be careful with this.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 include/asm-um/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.18-mm/include/asm-um/pgtable.h
===================================================================
--- linux-2.6.18-mm.orig/include/asm-um/pgtable.h	2006-10-03 12:53:16.000000000 -0400
+++ linux-2.6.18-mm/include/asm-um/pgtable.h	2006-10-09 12:25:44.000000000 -0400
@@ -270,7 +270,7 @@ static inline pte_t pte_wrprotect(pte_t 
 
 static inline pte_t pte_mkread(pte_t pte)
 { 
-	pte_set_bits(pte, _PAGE_RW);
+	pte_set_bits(pte, _PAGE_USER);
 	return(pte_mknewprot(pte)); 
 }
 

-- 
Work email - jdike at linux dot intel dot com
