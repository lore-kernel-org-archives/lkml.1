Return-Path: <linux-kernel-owner+w=401wt.eu-S1030528AbXDNGNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030528AbXDNGNA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 02:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965397AbXDNGNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 02:13:00 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:34457
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965388AbXDNGM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 02:12:59 -0400
Date: Sat, 14 Apr 2007 07:50:05 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] include KERN_* constant in printk() calls in arch/i386/mach-default/setup.c
Message-ID: <20070411065005.GI24898@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

include KERN_* constant in printk() calls in arch/i386/mach-default/setup.c

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
 
---
diff --git a/arch/i386/mach-default/setup.c b/arch/i386/mach-default/setup.c
index c788162..f1891b6 100644
--- a/arch/i386/mach-default/setup.c
+++ b/arch/i386/mach-default/setup.c
@@ -115,15 +115,15 @@ void mca_nmi_hook(void)
 	 * at the moment.
 	 */
 
-	printk("NMI generated from unknown source!\n");
+	printk(KERN_WARNING "NMI generated from unknown source!\n");
 }
 #endif
 
 static __init int no_ipi_broadcast(char *str)
 {
 	get_option(&str, &no_broadcast);
-	printk ("Using %s mode\n", no_broadcast ? "No IPI Broadcast" :
-											"IPI Broadcast");
+	printk(KERN_INFO "Using %s mode\n",
+	       no_broadcast ? "No IPI Broadcast" : "IPI Broadcast");
 	return 1;
 }
 
@@ -131,8 +131,8 @@ __setup("no_ipi_broadcast", no_ipi_broadcast);
 
 static int __init print_ipi_mode(void)
 {
-	printk ("Using IPI %s mode\n", no_broadcast ? "No-Shortcut" :
-											"Shortcut");
+	printk(KERN_INFO "Using IPI %s mode\n",
+	       no_broadcast ? "No-Shortcut" : "Shortcut");
 	return 0;
 }
 

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

              Comunicar bichos a <bug-coreutils@gnu.org>
                     (LANG=es_ES uname --help)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
