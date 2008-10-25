Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbYJYAVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbYJYAVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 20:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756777AbYJYAVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 20:21:39 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:57233 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756480AbYJYAVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 20:21:38 -0400
Subject: [PATCH 1/4] Check for serial key in dmi_name_in_vendors
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 24 Oct 2008 17:21:37 -0700
Message-Id: <1224894097.28224.71.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add serial key as a field to check for in dmi_name_in_vendors.

From: Alok N Kataria <akataria@vmware.com>

In some user configured cases, VMware may choose not to put a VMware specific
DMI string, but the serial key is always there and is VMware specific.
Add that too to check for in the dmi_name_in_vendors function.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
---

 drivers/firmware/dmi_scan.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 3e526b6..14fcb52 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -476,7 +476,8 @@ int dmi_name_in_vendors(const char *str)
 {
 	static int fields[] = { DMI_BIOS_VENDOR, DMI_BIOS_VERSION, DMI_SYS_VENDOR,
 				DMI_PRODUCT_NAME, DMI_PRODUCT_VERSION, DMI_BOARD_VENDOR,
-				DMI_BOARD_NAME, DMI_BOARD_VERSION, DMI_NONE };
+				DMI_BOARD_NAME, DMI_BOARD_VERSION, DMI_PRODUCT_SERIAL,
+				DMI_NONE };
 	int i;
 	for (i = 0; fields[i] != DMI_NONE; i++) {
 		int f = fields[i];


