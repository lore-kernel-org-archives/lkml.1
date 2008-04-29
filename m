Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbYD2Uvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbYD2Uvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbYD2Uv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:51:29 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47529 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757272AbYD2Uv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:51:28 -0400
Date: Tue, 29 Apr 2008 22:52:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Len Brown <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] acpi: fix section mismatch warning in pnpacpi
Message-ID: <20080429205201.GA15522@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following section mismatch warning:
WARNING: vmlinux.o(.text+0x153d69): Section mismatch in reference from the function is_exclusive_device() to the variable .init.data:excluded_id_list

is_exclusive_device is only used from __init context so document
this with the __init annotation and get rid of the warning.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index c283a9a..63e64ef 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -44,7 +44,7 @@ static struct acpi_device_id excluded_id_list[] __initdata = {
 	{"", 0},
 };
 
-static inline int is_exclusive_device(struct acpi_device *dev)
+static inline int __init is_exclusive_device(struct acpi_device *dev)
 {
 	return (!acpi_match_device_ids(dev, excluded_id_list));
 }
