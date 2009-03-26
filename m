Return-Path: <linux-kernel-owner+w=401wt.eu-S1761137AbZCZTJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761137AbZCZTJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 15:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760978AbZCZTJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 15:09:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:54503 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760968AbZCZTJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 15:09:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=jiydr1YE9y1KwdRZ3d+BwEMGv5eY2+LDzF+2ExOvPXoDxhX7sfoC8uz+JqY8V94V9h
         aPd2X/rW/QejXJrLWus+7A7yPDZyNAeBDm71RHcd9hRu3aytx/Z+n1b0Xvp63PXG6M+E
         TeY8EBDOIKGj9HyfOwNI6G8d9D/9osnoGe+IE=
Date: Thu, 26 Mar 2009 22:16:36 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: reduce ifdeffery near errata #93 code
Message-ID: <20090326191636.GA17275@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/x86/mm/fault.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -303,14 +303,6 @@ static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 }
 #endif
 
-#ifdef CONFIG_X86_64
-static const char errata93_warning[] =
-KERN_ERR "******* Your BIOS seems to not contain a fix for K8 errata #93\n"
-KERN_ERR "******* Working around it, but it may cause SEGVs or burn power.\n"
-KERN_ERR "******* Please consider a BIOS update.\n"
-KERN_ERR "******* Disabling USB legacy in the BIOS may also help.\n";
-#endif
-
 /* Workaround for K8 erratum #93 & buggy BIOS.
    BIOS SMM functions are required to use a specific workaround
    to avoid corruption of the 64bit RIP register on C stepping K8.
@@ -323,6 +315,11 @@ KERN_ERR "******* Disabling USB legacy in the BIOS may also help.\n";
 static int is_errata93(struct pt_regs *regs, unsigned long address)
 {
 #ifdef CONFIG_X86_64
+static const char errata93_warning[] =
+KERN_ERR "******* Your BIOS seems to not contain a fix for K8 errata #93\n"
+KERN_ERR "******* Working around it, but it may cause SEGVs or burn power.\n"
+KERN_ERR "******* Please consider a BIOS update.\n"
+KERN_ERR "******* Disabling USB legacy in the BIOS may also help.\n";
 	static int warned;
 	if (address != regs->ip)
 		return 0;
