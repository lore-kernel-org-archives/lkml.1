Return-Path: <linux-kernel-owner+w=401wt.eu-S932070AbZG1XEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbZG1XEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbZG1XEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:04:09 -0400
Received: from kroah.org ([198.145.64.141]:43021 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925AbZG1XEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:04:04 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 15:59:44 2009
Message-Id: <20090728225944.484600811@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 15:58:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, Thomas Renninger <trenn@suse.de>
Subject: [patch 24/37] ACPI: EC: Limit workaround for ASUS notebooks even more
References: <20090728225828.431071451@mini.kroah.org>
Content-Disposition: inline; filename=acpi-ec-limit-workaround-for-asus-notebooks-even-more.patch
In-Reply-To: <20090728230145.GA10486@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Starikovskiy <astarikovskiy@suse.de>

commit 235c4a59278eb07e61d909f1f0c233733034a8b3 upstream.

References: http://bugzilla.kernel.org/show_bug.cgi?id=11884

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/ec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1013,7 +1013,8 @@ int __init acpi_ec_ecdt_probe(void)
 	 * which needs it, has fake EC._INI method, so use it as flag.
 	 * Keep boot_ec struct as it will be needed soon.
 	 */
-	if (ACPI_FAILURE(acpi_get_handle(boot_ec->handle, "_INI", &dummy)))
+	if (!dmi_name_in_vendors("ASUS") ||
+	    ACPI_FAILURE(acpi_get_handle(boot_ec->handle, "_INI", &dummy)))
 		return -ENODEV;
 install:
 	if (!ec_install_handlers(boot_ec)) {


