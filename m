Return-Path: <linux-kernel-owner+w=401wt.eu-S1422989AbXCGRuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422989AbXCGRuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422791AbXCGROv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:14:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422779AbXCGROS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:14:18 -0500
Message-Id: <20070307171229.446952598@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:10:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, imr@rtschenk.de, linuxppc-embedded@ozlabs.org,
       Kumar Gala <galak@kernel.crashing.org>
Subject: [patch 022/101] Fix compile error for e500 core based processors
Content-Disposition: inline; filename=fix-compile-error-for-e500-core-based-processors.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rojhalat Ibrahim <imr@rtschenk.de>

We get the following compiler error:

   CC      arch/ppc/kernel/ppc_ksyms.o
arch/ppc/kernel/ppc_ksyms.c:275: error: '__mtdcr' undeclared here (not in a function)
arch/ppc/kernel/ppc_ksyms.c:275: warning: type defaults to 'int' in declaration of '__mtdcr'
arch/ppc/kernel/ppc_ksyms.c:276: error: '__mfdcr' undeclared here (not in a function)
arch/ppc/kernel/ppc_ksyms.c:276: warning: type defaults to 'int' in declaration of '__mfdcr'
make[1]: *** [arch/ppc/kernel/ppc_ksyms.o] Error 1

This is due to the EXPORT_SYMBOL for __mtdcr/__mfdcr not having the proper CONFIG protection

Signed-off-by: Rojhalat Ibrahim <imr@rtschenk.de>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ppc/kernel/ppc_ksyms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.1.orig/arch/ppc/kernel/ppc_ksyms.c
+++ linux-2.6.20.1/arch/ppc/kernel/ppc_ksyms.c
@@ -270,7 +270,7 @@ EXPORT_SYMBOL(mmu_hash_lock); /* For MOL
 extern long *intercept_table;
 EXPORT_SYMBOL(intercept_table);
 #endif /* CONFIG_PPC_STD_MMU */
-#if defined(CONFIG_40x) || defined(CONFIG_BOOKE)
+#ifdef CONFIG_PPC_DCR_NATIVE
 EXPORT_SYMBOL(__mtdcr);
 EXPORT_SYMBOL(__mfdcr);
 #endif

--
