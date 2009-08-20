Return-Path: <linux-kernel-owner+w=401wt.eu-S932136AbZHTUnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbZHTUnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 16:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbZHTUna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 16:43:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:38348 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932117AbZHTUmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 16:42:35 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18bWAEjlp4bbFYpHnepASotEuInakmQof816ywNG1
	zb4muDgT96IXsv
From: Peter Huewe <PeterHuewe@gmx.de>
To: Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] char/vme_scc: adding __init macro to vme_scc.c
Date: Thu, 20 Aug 2009 22:42:31 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908202242.31778.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init macro to the module_init 
function and all of its helper functions of char/vme_scc.c

Alan or Geert, please have a look at the small patch and either pull it through 
your tree, or please ack' it so Jiri can pull it through the trivial tree.

linux version 2.6.31-rc6 - linus git tree, Do 20. Aug 22:26:06 CEST 2009

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
diff --git a/drivers/char/vme_scc.c b/drivers/char/vme_scc.c
index 994e1a5..8b24729 100644
--- a/drivers/char/vme_scc.c
+++ b/drivers/char/vme_scc.c
@@ -136,7 +136,7 @@ static const struct tty_port_operations scc_port_ops = {
  * vme_scc_init() and support functions
  *---------------------------------------------------------------------------*/
 
-static int scc_init_drivers(void)
+static int __init scc_init_drivers(void)
 {
 	int error;
 
@@ -172,7 +172,7 @@ static int scc_init_drivers(void)
 /* ports[] array is indexed by line no (i.e. [0] for ttyS0, [1] for ttyS1).
  */
 
-static void scc_init_portstructs(void)
+static void __init scc_init_portstructs(void)
 {
 	struct scc_port *port;
 	int i;
@@ -195,7 +195,7 @@ static void scc_init_portstructs(void)
 
 
 #ifdef CONFIG_MVME147_SCC
-static int mvme147_scc_init(void)
+static int __init mvme147_scc_init(void)
 {
 	struct scc_port *port;
 	int error;
@@ -298,7 +298,7 @@ fail:
 
 
 #ifdef CONFIG_MVME162_SCC
-static int mvme162_scc_init(void)
+static int __init mvme162_scc_init(void)
 {
 	struct scc_port *port;
 	int error;
@@ -404,7 +404,7 @@ fail:
 
 
 #ifdef CONFIG_BVME6000_SCC
-static int bvme6000_scc_init(void)
+static int __init bvme6000_scc_init(void)
 {
 	struct scc_port *port;
 	int error;
@@ -503,7 +503,7 @@ fail_free_b_rx:
 #endif
 
 
-static int vme_scc_init(void)
+static int __init vme_scc_init(void)
 {
 	int res = -ENODEV;
