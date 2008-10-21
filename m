Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbYJUBnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbYJUBnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 21:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYJUBnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 21:43:40 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:40097 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934AbYJUBnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 21:43:39 -0400
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Oct 2008 21:43:39 EDT
Subject: [PATCH 1/3] Add serial key as a field to check for in
	dmi_name_in_vendors.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Dan Hecht <dhecht@vmware.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 20 Oct 2008 18:35:33 -0700
Message-Id: <1224552933.2640.90.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alok N Kataria <akataria@vmware.com>

In some user configurable cases, VMware may choose not to put a VMware specific
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


