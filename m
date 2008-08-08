Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbYHHGjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbYHHGjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYHHGjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:39:39 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:42099 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYHHGji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:39:38 -0400
Message-ID: <489BEA31.3040101@keyaccess.nl>
Date: Fri, 08 Aug 2008 08:39:45 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] PNP: make the resource type an unsigned long
Content-Type: multipart/mixed;
 boundary="------------030702040505040400010907"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030702040505040400010907
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Bjorn.

Andrew earlier commented that pci_resourec_flags() returns an unsigned 
long. Had this hanging around a local branch. Useful?

Rene.

--------------030702040505040400010907
Content-Type: text/plain;
 name="0001-PNP-make-the-resource-type-an-unsigned-long.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-PNP-make-the-resource-type-an-unsigned-long.patch"

>From ddab0bc46eb538c957357549ae2ba657db3887a3 Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Thu, 26 Jun 2008 00:14:08 +0200
Subject: [PATCH] PNP: make the resource type an unsigned long

PnP encodes the resource type directly as its struct resource->flags
value which is an unsigned long. Make it so...

Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
 drivers/pnp/base.h     |    2 +-
 drivers/pnp/resource.c |    4 ++--
 include/linux/pnp.h    |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pnp/base.h b/drivers/pnp/base.h
index 9fd7bb9..7cc7bf5 100644
--- a/drivers/pnp/base.h
+++ b/drivers/pnp/base.h
@@ -147,7 +147,7 @@ char *pnp_resource_type_name(struct resource *res);
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc);
 
 void pnp_free_resources(struct pnp_dev *dev);
-int pnp_resource_type(struct resource *res);
+unsigned long pnp_resource_type(struct resource *res);
 
 struct pnp_resource {
 	struct list_head list;
diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index 4cfe3a1..dbae23a 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -467,14 +467,14 @@ int pnp_check_dma(struct pnp_dev *dev, struct resource *res)
 #endif
 }
 
-int pnp_resource_type(struct resource *res)
+unsigned long pnp_resource_type(struct resource *res)
 {
 	return res->flags & (IORESOURCE_IO  | IORESOURCE_MEM |
 			     IORESOURCE_IRQ | IORESOURCE_DMA);
 }
 
 struct resource *pnp_get_resource(struct pnp_dev *dev,
-				  unsigned int type, unsigned int num)
+				  unsigned long type, unsigned int num)
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
diff --git a/include/linux/pnp.h b/include/linux/pnp.h
index 1ce54b6..97c8022 100644
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -21,7 +21,7 @@ struct pnp_dev;
 /*
  * Resource Management
  */
-struct resource *pnp_get_resource(struct pnp_dev *, unsigned int, unsigned int);
+struct resource *pnp_get_resource(struct pnp_dev *, unsigned long, unsigned int);
 
 static inline int pnp_resource_valid(struct resource *res)
 {
-- 
1.5.5


--------------030702040505040400010907--
