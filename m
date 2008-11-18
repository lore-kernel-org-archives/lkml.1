Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbYKRRna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbYKRRna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbYKRRnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:43:22 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:15881 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYKRRnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:43:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Ve4SBw9TGtu/MO6g1CO5RoVJLZRaAjxD1JdQ9aNJcDeR8GbiInqxvTcIrFCz2JRUVE
         N5tR1jBNrZFsJVjyX1uYFDT6pBZGA21OGqkr9nUNhL9K+aoWC0rXBEhdN+N76LPQpc4W
         LulhkolXd2AGC7Iiz15yXqzeVaHd5Ui/RczEM=
Date: Tue, 18 Nov 2008 17:42:51 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@osdl.org>,
       Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch] uml: fix undeclared variables
Message-ID: <20081118174250.GE3185@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix three compile errors about undeclared variables in
arch/um/kernel/mem.c.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>


---
diff --git a/arch/um/include/asm/fixmap.h b/arch/um/include/asm/fixmap.h
index 69c0252..0af143d 100644
--- a/arch/um/include/asm/fixmap.h
+++ b/arch/um/include/asm/fixmap.h
@@ -41,6 +41,9 @@ enum fixed_addresses {
 	__end_of_fixed_addresses
 };
 
+extern pte_t *pkmap_page_table;
+extern pte_t *kmap_pte;
+extern pgprot_t kmap_prot;
 extern void __set_fixmap (enum fixed_addresses idx,
 			  unsigned long phys, pgprot_t flags);
 
