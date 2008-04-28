Return-Path: <linux-kernel-owner+w=401wt.eu-S967262AbYD1Woa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967262AbYD1Woa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965150AbYD1Wgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:36:45 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:2978 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966526AbYD1Wgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:36:39 -0400
Message-Id: <20080428223619.710535966@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:03 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 16/55] PNPACPI: pass pnp_dev instead of acpi_handle
Content-Disposition: inline; filename=pnpacpi-use-pnp_dev
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass the pnp_dev pointer when possible instead of the acpi_handle.
This allows better error messages and reduces the chance of error
in the caller.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

Index: work10/drivers/pnp/pnpacpi/core.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/core.c	2008-04-28 16:09:12.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/core.c	2008-04-28 16:09:18.000000000 -0600
@@ -88,10 +88,10 @@
 {
 	acpi_handle handle = dev->data;
 	struct acpi_buffer buffer;
-	int ret = 0;
+	int ret;
 	acpi_status status;
 
-	ret = pnpacpi_build_resource_template(handle, &buffer);
+	ret = pnpacpi_build_resource_template(dev, &buffer);
 	if (ret)
 		return ret;
 	ret = pnpacpi_encode_resources(res, &buffer);
Index: work10/drivers/pnp/pnpacpi/pnpacpi.h
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/pnpacpi.h	2008-04-28 15:57:04.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/pnpacpi.h	2008-04-28 16:09:18.000000000 -0600
@@ -8,5 +8,5 @@
 acpi_status pnpacpi_parse_allocated_resource(acpi_handle, struct pnp_resource_table*);
 acpi_status pnpacpi_parse_resource_option_data(acpi_handle, struct pnp_dev*);
 int pnpacpi_encode_resources(struct pnp_resource_table *, struct acpi_buffer *);
-int pnpacpi_build_resource_template(acpi_handle, struct acpi_buffer*);
+int pnpacpi_build_resource_template(struct pnp_dev *, struct acpi_buffer *);
 #endif
Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-28 16:09:17.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-04-28 16:09:18.000000000 -0600
@@ -777,9 +777,10 @@
 	return AE_OK;
 }
 
-int pnpacpi_build_resource_template(acpi_handle handle,
+int pnpacpi_build_resource_template(struct pnp_dev *dev,
 				    struct acpi_buffer *buffer)
 {
+	acpi_handle handle = dev->data;
 	struct acpi_resource *resource;
 	int res_cnt = 0;
 	acpi_status status;

-- 
