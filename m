Return-Path: <linux-kernel-owner+w=401wt.eu-S1759972AbZANUoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbZANUoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbZANUmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:42:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:46421 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339AbZANUmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:42:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=Usedhku/xIb81mFM80MM830Y3wK4XLoHa7L2+a9xs2/tginTEezFpMa9h1g8o3rTCI
         vXgsVpGB7F04KHOzYsh8KxWk6T0Rlrs5oifp+esYRokRslcZpKHgrlxRItPKCK/4OjSd
         Ij2sjtOihGciOCWN5XH1g0cEgOGNX1S6ayUAg=
References: <20090114203745.285473388@gmail.com>>
User-Agent: quilt/0.46-1
Date: Wed, 14 Jan 2009 23:37:50 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org
Cc: harvey.harrison@gmail.com, sam@ravnborg.org, jaswinderrajput@gmail.com,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 5/5] x86: headers cleanup - setup.h
Content-Disposition: inline; filename=x86-header-setup-h
Message-ID: <496e4e25.0c58560a.4d7a.ffffc01b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

'make headers_check' warn us about leaking of kernel private
(mostly compile time vars) data to userspace in headers. Fix it.

Guard this one by __KERNEL__.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/include/asm/setup.h |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/setup.h
+++ linux-2.6.git/arch/x86/include/asm/setup.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_SETUP_H
 #define _ASM_X86_SETUP_H
 
+#ifdef __KERNEL__
+
 #define COMMAND_LINE_SIZE 2048
 
 #ifndef __ASSEMBLY__
@@ -8,10 +10,8 @@
 /* Interrupt control for vSMPowered x86_64 systems */
 void vsmp_init(void);
 
-
 void setup_bios_corruption_check(void);
 
-
 #ifdef CONFIG_X86_VISWS
 extern void visws_early_detect(void);
 extern int is_visws_box(void);
@@ -43,7 +43,7 @@ struct x86_quirks {
 	void (*mpc_oem_bus_info)(struct mpc_bus *m, char *name);
 	void (*mpc_oem_pci_bus)(struct mpc_bus *m);
 	void (*smp_read_mpc_oem)(struct mpc_oemtable *oemtable,
-                                    unsigned short oemsize);
+				unsigned short oemsize);
 	int (*setup_ioapic_ids)(void);
 	int (*update_genapic)(void);
 };
@@ -56,8 +56,6 @@ extern unsigned long saved_video_mode;
 #endif
 #endif /* __ASSEMBLY__ */
 
-#ifdef __KERNEL__
-
 #ifdef __i386__
 
 #include <linux/pfn.h>

-- 
