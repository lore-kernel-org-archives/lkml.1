Return-Path: <linux-kernel-owner+w=401wt.eu-S932616AbYDYSpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbYDYSpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763432AbYDYSju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:39:50 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:18994 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762628AbYDYSjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:39:46 -0400
Message-Id: <20080425183927.368757064@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:23 -0600
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
Subject: [patch 16/54] PNPACPI: pass pnp_dev instead of acpi_handle
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
--- work10.orig/drivers/pnp/pnpacpi/core.c	2008-04-25 11:14:49.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/core.c	2008-04-25 11:14:54.000000000 -0600
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
--- work10.orig/drivers/pnp/pnpacpi/pnpacpi.h	2008-04-25 11:12:17.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/pnpacpi.h	2008-04-25 11:14:54.000000000 -0600
@@ -8,5 +8,5 @@
 acpi_status pnpacpi_parse_allocated_resource(acpi_handle, struct pnp_resource_table*);
 acpi_status pnpacpi_parse_resource_option_data(acpi_handle, struct pnp_dev*);
 int pnpacpi_encode_resources(struct pnp_resource_table *, struct acpi_buffer *);
-int pnpacpi_build_resource_template(acpi_handle, struct acpi_buffer*);
+int pnpacpi_build_resource_template(struct pnp_dev *, struct acpi_buffer *);
 #endif
Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-25 11:14:54.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-04-25 11:14:54.000000000 -0600
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
