Return-Path: <linux-kernel-owner+w=401wt.eu-S1946578AbXBIPnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946578AbXBIPnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946575AbXBIPnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:43:10 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:40547 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946551AbXBIPmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:42:36 -0500
Date: Fri, 9 Feb 2007 09:39:57 -0600 (CST)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@localhost.localdomain
To: stable@kernel.org
cc: linux-kernel@vger.kernel.org, linuxppc-embedded@ozlabs.org,
       imr@rtschenk.de
Subject: [PPC] Fix compile error for e500 core based processors
Message-ID: <Pine.LNX.4.64.0702090938360.26617@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

---

This should go in for 2.6.20,1, got in a sub-arch tree for 2.6.21.

- k

commit 862a7284980d809a583e9a34c774fab84e0a46f8
tree 021a5c277818f63a85d1cbecad69815bedce7174
parent 27630bec9478a2dd387c68b5e435ed3fdd3a513e
author Rojhalat Ibrahim <imr@rtschenk.de> Fri, 09 Feb 2007 15:10:38 +0100
committer Kumar Gala <galak@kernel.crashing.org> Fri, 09 Feb 2007 09:36:37 -0600

  arch/ppc/kernel/ppc_ksyms.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ppc/kernel/ppc_ksyms.c b/arch/ppc/kernel/ppc_ksyms.c
index 1f49503..1318b6f 100644
--- a/arch/ppc/kernel/ppc_ksyms.c
+++ b/arch/ppc/kernel/ppc_ksyms.c
@@ -271,7 +271,7 @@ EXPORT_SYMBOL(mmu_hash_lock); /* For MOL */
  extern long *intercept_table;
  EXPORT_SYMBOL(intercept_table);
  #endif /* CONFIG_PPC_STD_MMU */
-#if defined(CONFIG_40x) || defined(CONFIG_BOOKE)
+#ifdef CONFIG_PPC_DCR_NATIVE
  EXPORT_SYMBOL(__mtdcr);
  EXPORT_SYMBOL(__mfdcr);
  #endif
