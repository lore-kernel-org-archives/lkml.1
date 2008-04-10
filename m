Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbYDJWKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbYDJWKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756364AbYDJWKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:10:46 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:40763 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862AbYDJWKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:10:45 -0400
Date: Thu, 10 Apr 2008 15:09:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, mingo <mingo@redhat.com>,
       tglx <tglx@linutronix.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 10 (arch/x86)
Message-Id: <20080410150950.5913b16a.randy.dunlap@oracle.com>
In-Reply-To: <20080410181404.b76939a6.sfr@canb.auug.org.au>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Has the printk format warning in arch/x86/mm/ioremap.c already been fixed
somewhere else (and not in linux-next merges)?

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk formats in x86/mm/ioremap.c:

next-20080410/arch/x86/mm/ioremap.c:137: warning: format '%llx' expects type 'long long unsigned int', but argument 2 has type 'resource_size_t'
next-20080410/arch/x86/mm/ioremap.c:188: warning: format '%llx' expects type 'long long unsigned int', but argument 2 has type 'resource_size_t'
next-20080410/arch/x86/mm/ioremap.c:188: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/mm/ioremap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- next-20080410.orig/arch/x86/mm/ioremap.c
+++ next-20080410/arch/x86/mm/ioremap.c
@@ -134,7 +134,7 @@ static void __iomem *__ioremap(resource_
 
 	if (!phys_addr_valid(phys_addr)) {
 		printk(KERN_WARNING "ioremap: invalid physical address %llx\n",
-		       phys_addr);
+		       (unsigned long long)phys_addr);
 		WARN_ON_ONCE(1);
 		return NULL;
 	}
@@ -187,7 +187,8 @@ static void __iomem *__ioremap(resource_
 		     new_prot_val == _PAGE_CACHE_WB)) {
 			pr_debug(
 		"ioremap error for 0x%llx-0x%llx, requested 0x%lx, got 0x%lx\n",
-				phys_addr, phys_addr + size,
+				(unsigned long long)phys_addr,
+				(unsigned long long)(phys_addr + size),
 				prot_val, new_prot_val);
 			free_memtype(phys_addr, phys_addr + size);
 			return NULL;
