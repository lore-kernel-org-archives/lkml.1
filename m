Return-Path: <linux-kernel-owner+w=401wt.eu-S1761124AbZA2AHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761124AbZA2AHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758403AbZA1Xpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:53073 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758334AbZA1Xpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:38 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 057/114] x86, apic: get rid of *_APIC_ID_MASK definitions
Date: Wed, 28 Jan 2009 23:42:03 +0000
Message-Id: <1233186180-29883-58-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Remove the *_APIC_ID_MASK subarch definitions and move them straight
to the genapic driver initialization code.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apicdef.h            |    2 --
 arch/x86/include/asm/es7000/apicdef.h            |    2 --
 arch/x86/include/asm/mach-default/mach_apicdef.h |    1 -
 arch/x86/include/asm/numaq/apicdef.h             |    2 --
 arch/x86/include/asm/summit/apicdef.h            |    2 --
 arch/x86/mach-generic/bigsmp.c                   |    2 +-
 arch/x86/mach-generic/default.c                  |    2 +-
 arch/x86/mach-generic/es7000.c                   |    2 +-
 arch/x86/mach-generic/numaq.c                    |    2 +-
 arch/x86/mach-generic/summit.c                   |    2 +-
 10 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apicdef.h b/arch/x86/include/asm/bigsmp/apicdef.h
index 6e58781..e58dee8 100644
--- a/arch/x86/include/asm/bigsmp/apicdef.h
+++ b/arch/x86/include/asm/bigsmp/apicdef.h
@@ -1,8 +1,6 @@
 #ifndef __ASM_MACH_APICDEF_H
 #define __ASM_MACH_APICDEF_H
 
-#define		BIGSMP_APIC_ID_MASK		(0xFF<<24)
-
 static inline unsigned bigsmp_get_apic_id(unsigned long x)
 {
 	return (x >> 24) & 0xFF;
diff --git a/arch/x86/include/asm/es7000/apicdef.h b/arch/x86/include/asm/es7000/apicdef.h
index 476da0c..c74881a 100644
--- a/arch/x86/include/asm/es7000/apicdef.h
+++ b/arch/x86/include/asm/es7000/apicdef.h
@@ -1,8 +1,6 @@
 #ifndef __ASM_ES7000_APICDEF_H
 #define __ASM_ES7000_APICDEF_H
 
-#define		ES7000_APIC_ID_MASK		(0xFF<<24)
-
 static inline unsigned int es7000_get_apic_id(unsigned long x)
 {
 	return (x >> 24) & 0xFF;
diff --git a/arch/x86/include/asm/mach-default/mach_apicdef.h b/arch/x86/include/asm/mach-default/mach_apicdef.h
index 8318d12..5141085 100644
--- a/arch/x86/include/asm/mach-default/mach_apicdef.h
+++ b/arch/x86/include/asm/mach-default/mach_apicdef.h
@@ -6,7 +6,6 @@
 #ifdef CONFIG_X86_64
 #define	SET_APIC_ID(x)		(apic->set_apic_id(x))
 #else
-#define		DEFAULT_APIC_ID_MASK	(0x0F<<24)
 
 static inline unsigned default_get_apic_id(unsigned long x) 
 {
diff --git a/arch/x86/include/asm/numaq/apicdef.h b/arch/x86/include/asm/numaq/apicdef.h
index 6f2cc5d..cd927d5 100644
--- a/arch/x86/include/asm/numaq/apicdef.h
+++ b/arch/x86/include/asm/numaq/apicdef.h
@@ -1,8 +1,6 @@
 #ifndef __ASM_NUMAQ_APICDEF_H
 #define __ASM_NUMAQ_APICDEF_H
 
-#define NUMAQ_APIC_ID_MASK (0xF<<24)
-
 static inline unsigned int numaq_get_apic_id(unsigned long x)
 {
 	return (x >> 24) & 0x0F;
diff --git a/arch/x86/include/asm/summit/apicdef.h b/arch/x86/include/asm/summit/apicdef.h
index 0373f0c..c24b0df 100644
--- a/arch/x86/include/asm/summit/apicdef.h
+++ b/arch/x86/include/asm/summit/apicdef.h
@@ -1,8 +1,6 @@
 #ifndef __ASM_SUMMIT_APICDEF_H
 #define __ASM_SUMMIT_APICDEF_H
 
-#define		SUMMIT_APIC_ID_MASK		(0xFF<<24)
-
 static inline unsigned summit_get_apic_id(unsigned long x)
 {
 	return (x >> 24) & 0xFF;
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 1f4ad4f..ee52c59 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -92,7 +92,7 @@ struct genapic apic_bigsmp = {
 
 	.get_apic_id			= bigsmp_get_apic_id,
 	.set_apic_id			= NULL,
-	.apic_id_mask			= BIGSMP_APIC_ID_MASK,
+	.apic_id_mask			= 0xFF << 24,
 
 	.cpu_mask_to_apicid		= cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= cpu_mask_to_apicid_and,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index 239af25..e4ed7e6 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -73,7 +73,7 @@ struct genapic apic_default = {
 
 	.get_apic_id			= default_get_apic_id,
 	.set_apic_id			= NULL,
-	.apic_id_mask			= DEFAULT_APIC_ID_MASK,
+	.apic_id_mask			= 0x0F << 24,
 
 	.cpu_mask_to_apicid		= cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= cpu_mask_to_apicid_and,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 21fb33e..3d046de 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -128,7 +128,7 @@ struct genapic apic_es7000 = {
 
 	.get_apic_id			= es7000_get_apic_id,
 	.set_apic_id			= NULL,
-	.apic_id_mask			= ES7000_APIC_ID_MASK,
+	.apic_id_mask			= 0xFF << 24,
 
 	.cpu_mask_to_apicid		= cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= cpu_mask_to_apicid_and,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 27d2d1f..a7bf1aa 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -92,7 +92,7 @@ struct genapic apic_numaq = {
 
 	.get_apic_id			= numaq_get_apic_id,
 	.set_apic_id			= NULL,
-	.apic_id_mask			= NUMAQ_APIC_ID_MASK,
+	.apic_id_mask			= 0x0F << 24,
 
 	.cpu_mask_to_apicid		= cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= cpu_mask_to_apicid_and,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index f24cba1..a0ae6b9 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -72,7 +72,7 @@ struct genapic apic_summit = {
 
 	.get_apic_id			= summit_get_apic_id,
 	.set_apic_id			= NULL,
-	.apic_id_mask			= SUMMIT_APIC_ID_MASK,
+	.apic_id_mask			= 0xFF << 24,
 
 	.cpu_mask_to_apicid		= cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= cpu_mask_to_apicid_and,
-- 
1.6.0.2

