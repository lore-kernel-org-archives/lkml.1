Return-Path: <linux-kernel-owner+w=401wt.eu-S1762212AbXHUPSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762212AbXHUPSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 11:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760181AbXHUPSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 11:18:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47825 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760295AbXHUPSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 11:18:23 -0400
Date: Tue, 21 Aug 2007 16:18:20 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Jarek Poplawski <jarkao2@o2.pl>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       len.brown@intel.com, Andrew Morton <akpm@osdl.org>
Subject: Re: [Git Patch] ACPI: Fix a warning of discarding qualifiers from pointer target type
Message-ID: <20070821151820.GB21089@ftp.linux.org.uk>
References: <20070821132038.GA22254@ff.dom.local> <20070821150714.GA7591@hacking> <46CB0169.7090207@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CB0169.7090207@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 07:14:49PM +0400, Alexey Starikovskiy wrote:
> WANG Cong wrote:
> > Fix this warning:
> >
> > drivers/acpi/ec.c: In function `acpi_ec_ecdt_probe':
> > drivers/acpi/ec.c:873: warning: passing arg 1 of `acpi_get_devices' discards qualifiers from pointer target type
> >
> > (I don't know whether this fix hits the real problem.)
> >   
> It is safe to give acpi_get_devices() const string, as it should not
> modify it in any condition.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/acpi/namespace/nsxfeval.c b/drivers/acpi/namespace/nsxfeval.c
index ab65b2c..f39fbc6 100644
--- a/drivers/acpi/namespace/nsxfeval.c
+++ b/drivers/acpi/namespace/nsxfeval.c
@@ -540,7 +540,7 @@ acpi_ns_get_device_callback(acpi_handle obj_handle,
  ******************************************************************************/
 
 acpi_status
-acpi_get_devices(char *HID,
+acpi_get_devices(const char *HID,
 		 acpi_walk_callback user_function,
 		 void *context, void **return_value)
 {
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index b5cca5d..3d7ab9e 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -130,7 +130,7 @@ acpi_walk_namespace(acpi_object_type type,
 		    void *context, void **return_value);
 
 acpi_status
-acpi_get_devices(char *HID,
+acpi_get_devices(const char *HID,
 		 acpi_walk_callback user_function,
 		 void *context, void **return_value);
 
diff --git a/include/acpi/acstruct.h b/include/acpi/acstruct.h
index aeb4498..8848265 100644
--- a/include/acpi/acstruct.h
+++ b/include/acpi/acstruct.h
@@ -146,7 +146,7 @@ struct acpi_init_walk_info {
 struct acpi_get_devices_info {
 	acpi_walk_callback user_function;
 	void *context;
-	char *hid;
+	const char *hid;
 };
 
 union acpi_aml_operands {
