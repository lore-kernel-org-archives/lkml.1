Return-Path: <linux-kernel-owner+w=401wt.eu-S1752380AbXCAM5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbXCAM5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 07:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbXCAM5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 07:57:17 -0500
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:2799 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752374AbXCAM5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 07:57:16 -0500
Date: Thu, 1 Mar 2007 13:55:16 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] scatterlist.h needs types.h
Message-Id: <20070301135516.5e6b6b29.khali@linux-fr.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Most architectures' scatterlist.h use the type dma_addr_t, but omit
to include <asm/types.h> which defines it. This could lead to build
failures, so let's add the missing includes.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 include/asm-alpha/scatterlist.h     |    1 +
 include/asm-avr32/scatterlist.h     |    2 ++
 include/asm-frv/scatterlist.h       |    2 ++
 include/asm-h8300/scatterlist.h     |    2 ++
 include/asm-i386/scatterlist.h      |    2 ++
 include/asm-ia64/scatterlist.h      |    2 ++
 include/asm-m32r/scatterlist.h      |    2 ++
 include/asm-m68knommu/scatterlist.h |    1 +
 include/asm-mips/scatterlist.h      |    2 ++
 include/asm-parisc/scatterlist.h    |    1 +
 include/asm-sh/scatterlist.h        |    2 ++
 include/asm-sh64/scatterlist.h      |    2 ++
 include/asm-sparc64/scatterlist.h   |    1 +
 include/asm-v850/scatterlist.h      |    2 ++
 include/asm-x86_64/scatterlist.h    |    2 ++
 include/asm-xtensa/scatterlist.h    |    2 ++
 16 files changed, 28 insertions(+)

--- linux-2.6.21-rc2.orig/include/asm-x86_64/scatterlist.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc2/include/asm-x86_64/scatterlist.h	2007-03-01 11:34:51.000000000 +0100
@@ -1,6 +1,8 @@
 #ifndef _X8664_SCATTERLIST_H
 #define _X8664_SCATTERLIST_H
 
+#include <asm/types.h>
+
 struct scatterlist {
     struct page		*page;
     unsigned int	offset;
--- linux-2.6.21-rc2.orig/include/asm-alpha/scatterlist.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc2/include/asm-alpha/scatterlist.h	2007-03-01 11:31:49.000000000 +0100
@@ -2,6 +2,7 @@
 #define _ALPHA_SCATTERLIST_H
 
 #include <asm/page.h>
+#include <asm/types.h>
   
 struct scatterlist {
 	struct page *page;
--- linux-2.6.21-rc2.orig/include/asm-avr32/scatterlist.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc2/include/asm-avr32/scatterlist.h	2007-03-01 11:31:59.000000000 +0100
@@ -1,6 +1,8 @@
 #ifndef __ASM_AVR32_SCATTERLIST_H
 #define __ASM_AVR32_SCATTERLIST_H
 
+#include <asm/types.h>
+
 struct scatterlist {
     struct page		*page;
     unsigned int	offset;
--- linux-2.6.21-rc2.orig/include/asm-frv/scatterlist.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc2/include/asm-frv/scatterlist.h	2007-03-01 11:32:29.000000000 +0100
@@ -1,6 +1,8 @@
 #ifndef _ASM_SCATTERLIST_H
 #define _ASM_SCATTERLIST_H
 
+#include <asm/types.h>
+
 /*
  * Drivers must set either ->address or (preferred) ->page and ->offset
  * to indicate where data must be transferred to/from.
--- linux-2.6.21-rc2.orig/include/asm-h8300/scatterlist.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc2/include/asm-h8300/scatterlist.h	2007-03-01 11:32:34.000000000 +0100
@@ -1,6 +1,8 @@
 #ifndef _H8300_SCATTERLIST_H
 #define _H8300_SCATTERLIST_H
 
+#include <asm/types.h>
+
 struct scatterlist {
 	struct page	*page;
 	unsigned int	offset;
--- linux-2.6.21-rc2.orig/include/asm-i386/scatterlist.h	2007-03-01 11:27:39.000000000 +0100
+++ linux-2.6.21-rc2/include/asm-i386/scatterlist.h	2007-03-01 11:32:38.000000000 +0100
@@ -1,6 +1,8 @@
 #ifndef _I386_SCATTERLIST_H
 #define _I386_SCATTERLIST_H
 
+#include <asm/types.h>
+
 struct scatterlist {
     struct page		*page;
     unsigned int	offset;
--- linux-2.6.21-rc2.orig/include/asm-ia64/scatterlist.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc2/include/asm-ia64/scatterlist.h	2007-03-01 11:33:08.000000000 +0100
@@ -6,6 +6,8 @@
  *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co
  */
 
+#include <asm/types.h>
+
 struct scatterlist {
 	struct page *page;
 	unsigned int offset;
--- linux-2.6.21-rc2.orig/include/asm-m32r/scatterlist.h	2007-02-21 08:36:27.000000000 +0100
+++ linux-2.6.21-rc2/include/asm-m32r/scatterlist.h	2007-03-01 11:33:15.000000000 +0100
@@ -1,6 +1,8 @@
 #ifndef _ASM_M32R_SCATTERLIST_H
 #define _ASM_M32R_SCATTERLIST_H
 
+#include <asm/types.h>
+
 struct scatterlist {
     char *  address;    /* Location data is to be transferred to, NULL for
                          * highmem page */
--- linux-2.6.21-rc2.orig/include/asm-m68knommu/scatterlist.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc2/include/asm-m68knommu/scatterlist.h	2007-03-01 11:33:31.000000000 +0100
@@ -2,6 +2,7 @@
 #define _M68KNOMMU_SCATTERLIST_H
 
 #include <linux/mm.h>
+#include <asm/types.h>
 
 struct scatterlist {
 	struct page	*page;
--- linux-2.6.21-rc2.orig/include/asm-mips/scatterlist.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc2/include/asm-mips/scatterlist.h	2007-03-01 11:33:39.000000000 +0100
@@ -1,6 +1,8 @@
 #ifndef __ASM_SCATTERLIST_H
 #define __ASM_SCATTERLIST_H
 
+#include <asm/types.h>
+
 struct scatterlist {
 	struct page *	page;
 	unsigned int	offset;
--- linux-2.6.21-rc2.orig/include/asm-parisc/scatterlist.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc2/include/asm-parisc/scatterlist.h	2007-03-01 11:33:47.000000000 +0100
@@ -2,6 +2,7 @@
 #define _ASM_PARISC_SCATTERLIST_H
 
 #include <asm/page.h>
+#include <asm/types.h>
 
 struct scatterlist {
 	struct page *page;
--- linux-2.6.21-rc2.orig/include/asm-sh/scatterlist.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc2/include/asm-sh/scatterlist.h	2007-03-01 11:34:09.000000000 +0100
@@ -1,6 +1,8 @@
 #ifndef __ASM_SH_SCATTERLIST_H
 #define __ASM_SH_SCATTERLIST_H
 
+#include <asm/types.h>
+
 struct scatterlist {
     struct page * page; /* Location for highmem page, if any */
     unsigned int offset;/* for highmem, page offset */
--- linux-2.6.21-rc2.orig/include/asm-sh64/scatterlist.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc2/include/asm-sh64/scatterlist.h	2007-03-01 11:34:15.000000000 +0100
@@ -11,6 +11,8 @@
 #ifndef __ASM_SH64_SCATTERLIST_H
 #define __ASM_SH64_SCATTERLIST_H
 
+#include <asm/types.h>
+
 struct scatterlist {
     struct page * page; /* Location for highmem page, if any */
     unsigned int offset;/* for highmem, page offset */
--- linux-2.6.21-rc2.orig/include/asm-sparc64/scatterlist.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc2/include/asm-sparc64/scatterlist.h	2007-03-01 11:34:35.000000000 +0100
@@ -3,6 +3,7 @@
 #define _SPARC64_SCATTERLIST_H
 
 #include <asm/page.h>
+#include <asm/types.h>
 
 struct scatterlist {
 	struct page	*page;
--- linux-2.6.21-rc2.orig/include/asm-v850/scatterlist.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc2/include/asm-v850/scatterlist.h	2007-03-01 11:34:44.000000000 +0100
@@ -14,6 +14,8 @@
 #ifndef __V850_SCATTERLIST_H__
 #define __V850_SCATTERLIST_H__
 
+#include <asm/types.h>
+
 struct scatterlist {
 	struct page	*page;
 	unsigned	offset;
--- linux-2.6.21-rc2.orig/include/asm-xtensa/scatterlist.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc2/include/asm-xtensa/scatterlist.h	2007-03-01 11:34:56.000000000 +0100
@@ -11,6 +11,8 @@
 #ifndef _XTENSA_SCATTERLIST_H
 #define _XTENSA_SCATTERLIST_H
 
+#include <asm/types.h>
+
 struct scatterlist {
 	struct page 	*page;
 	unsigned int	offset;


-- 
Jean Delvare
