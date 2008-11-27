Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbYK0SM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbYK0SM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 13:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbYK0SMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 13:12:48 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:27274 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbYK0SMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 13:12:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=w/TM6o8gklATINN3AAlQHbdZbDqtrSroAybg7nOo9HtSxeFSI3hl2VSe+vuzopk2f6
         phsUTl9sP6of53aNMT+263SZyLVYgkT3Y4GsTrBSkeTd0g/2nVNS1XB0PbCRrf8xs7DR
         1l0ZdWEM6GvbjFqCWjHT1NdUE6Pp5bIHiNcxk=
Date: Thu, 27 Nov 2008 18:12:28 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [Patch] uml: fix the highmem build error
Message-ID: <20081127181228.GA4417@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes this error:

arch/um/kernel/mem.c: In function ‘init_highmem’:        
arch/um/kernel/mem.c:177: error: ‘pkmap_page_table’ undeclared (first
use in this function)                                 
arch/um/kernel/mem.c:177: error: (Each undeclared identifier is
reported only once      
arch/um/kernel/mem.c:177: error: for each function it appears in.)  

Compile and run tested.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>

---
diff --git a/arch/um/include/asm/fixmap.h b/arch/um/include/asm/fixmap.h
index 69c0252..4e656c9 100644
--- a/arch/um/include/asm/fixmap.h
+++ b/arch/um/include/asm/fixmap.h
@@ -40,6 +40,9 @@ enum fixed_addresses {
 #endif
 	__end_of_fixed_addresses
 };
+extern pte_t *pkmap_page_table;
+extern pte_t *kmap_pte;
+extern pgprot_t kmap_prot;
 
 extern void __set_fixmap (enum fixed_addresses idx,
 			  unsigned long phys, pgprot_t flags);
diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index bcc079c..884f9e2 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -1,3 +1,4 @@
+#include <asm/fixmap.h>
 #include <linux/highmem.h>
 #include <linux/module.h>
 
