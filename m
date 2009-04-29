Return-Path: <linux-kernel-owner+w=401wt.eu-S1763242AbZD2Wnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763242AbZD2Wnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760759AbZD2WWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:22:06 -0400
Received: from kroah.org ([198.145.64.141]:40825 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760593AbZD2WV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:58 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:31 2009
Message-Id: <20090429220931.429528114@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Hannes Eder <hannes@hanneseder.net>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>
Subject: [patch 57/58] ACPI: EC: fix compilation warning
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=acpi-ec-fix-compilation-warning.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hannes Eder <hannes@hanneseder.net>

commit 3e54048691bce3f323fd5460695273be379803b9 upstream.

Fix the warning introduced in commit c5279dee26c0e8d7c4200993bfc4b540d2469598,
and give the dummy variable a more verbose name.

  drivers/acpi/ec.c: In function 'acpi_ec_ecdt_probe':
  drivers/acpi/ec.c:1015: warning: ISO C90 forbids mixed declarations and code

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/ec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -970,6 +970,7 @@ int __init acpi_ec_ecdt_probe(void)
 {
 	acpi_status status;
 	struct acpi_table_ecdt *ecdt_ptr;
+	acpi_handle dummy;
 
 	boot_ec = make_acpi_ec();
 	if (!boot_ec)
@@ -1002,7 +1003,6 @@ int __init acpi_ec_ecdt_probe(void)
 	}
 	/* This workaround is needed only on some broken machines,
 	 * which require early EC, but fail to provide ECDT */
-	acpi_handle x;
 	printk(KERN_DEBUG PREFIX "Look up EC in DSDT\n");
 	status = acpi_get_devices(ec_device_ids[0].id, ec_parse_device,
 					boot_ec, NULL);
@@ -1013,7 +1013,7 @@ int __init acpi_ec_ecdt_probe(void)
 	 * which needs it, has fake EC._INI method, so use it as flag.
 	 * Keep boot_ec struct as it will be needed soon.
 	 */
-	if (ACPI_FAILURE(acpi_get_handle(boot_ec->handle, "_INI", &x)))
+	if (ACPI_FAILURE(acpi_get_handle(boot_ec->handle, "_INI", &dummy)))
 		return -ENODEV;
 install:
 	if (!ec_install_handlers(boot_ec)) {


