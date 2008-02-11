Return-Path: <linux-kernel-owner+w=401wt.eu-S1759757AbYBKSGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757AbYBKSGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759166AbYBKSFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:05:52 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:57527 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759070AbYBKSFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:05:51 -0500
Date: Mon, 11 Feb 2008 10:05:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: pazke@donpac.ru, akpm <akpm@linux-foundation.org>
Subject: [PATCH] x86/visws: fix printk format warnings
Message-Id: <20080211100509.325eb561.randy.dunlap@oracle.com>
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

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix visws printk format warnings:

/local/linsrc/linux-2.6.24-git15/arch/x86/mach-visws/traps.c:50: warning: format '%#lx' expects type 'long unsigned int', but argument 2 has type 'u32'
/local/linsrc/linux-2.6.24-git15/arch/x86/mach-visws/traps.c:50: warning: format '%#lx' expects type 'long unsigned int', but argument 3 has type 'u32'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/mach-visws/traps.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.24-git15.orig/arch/x86/mach-visws/traps.c
+++ linux-2.6.24-git15/arch/x86/mach-visws/traps.c
@@ -46,8 +46,9 @@ static __init void cobalt_init(void)
 	 */
 	set_fixmap(FIX_APIC_BASE, APIC_DEFAULT_PHYS_BASE);
 	setup_local_APIC();
-	printk(KERN_INFO "Local APIC Version %#lx, ID %#lx\n",
-		apic_read(APIC_LVR), apic_read(APIC_ID));
+	printk(KERN_INFO "Local APIC Version %#x, ID %#x\n",
+		(unsigned int)apic_read(APIC_LVR),
+		(unsigned int)apic_read(APIC_ID));
 
 	set_fixmap(FIX_CO_CPU, CO_CPU_PHYS);
 	set_fixmap(FIX_CO_APIC, CO_APIC_PHYS);
