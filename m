Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbZA1VVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbZA1VVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZA1VVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:21:12 -0500
Received: from relay1.sgi.com ([192.48.179.29]:53006 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751302AbZA1VVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:21:10 -0500
Date: Wed, 28 Jan 2009 15:21:04 -0600
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] - UV fix compile error on IA64 & eliminate compiler warning
Message-ID: <20090128212104.GA1156@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The GRU driver is used on both IA64 & x86.
The 2 architectures have different ways of detecting the
platform type, ie. whether the platform is a UV system.
Although it is possible to reconcile the 2 methods,
only one place currently makes the test.

Also eliminate a warning message in uv.h.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 arch/x86/include/asm/uv/uv.h   |    1 +
 drivers/misc/sgi-gru/gru.h     |    2 --
 drivers/misc/sgi-gru/grufile.c |    1 +
 3 files changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv.h	2009-01-28 12:43:27.000000000 -0600
+++ linux/arch/x86/include/asm/uv/uv.h	2009-01-28 15:13:58.000000000 -0600
@@ -2,6 +2,7 @@
 #define _ASM_X86_UV_UV_H
 
 enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
+struct mm_struct;
 
 #ifdef CONFIG_X86_UV
 
Index: linux/drivers/misc/sgi-gru/gru.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gru.h	2009-01-28 12:43:28.000000000 -0600
+++ linux/drivers/misc/sgi-gru/gru.h	2009-01-28 14:53:52.000000000 -0600
@@ -19,8 +19,6 @@
 #ifndef __GRU_H__
 #define __GRU_H__
 
-#include <asm/uv/uv.h>
-
 /*
  * GRU architectural definitions
  */
Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c	2009-01-28 13:04:08.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufile.c	2009-01-28 15:12:04.000000000 -0600
@@ -46,6 +46,7 @@
 #if defined CONFIG_X86_64
 #include <asm/genapic.h>
 #include <asm/irq.h>
+#include <asm/uv/uv.h>
 #define IS_UV()		is_uv_system()
 #elif defined CONFIG_IA64
 #include <asm/system.h>
