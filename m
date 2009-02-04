Return-Path: <linux-kernel-owner+w=401wt.eu-S1760138AbZBDSsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138AbZBDSsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758297AbZBDShl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:37:41 -0500
Received: from kroah.org ([198.145.64.141]:51212 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758571AbZBDSh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:37:27 -0500
Date: Wed, 4 Feb 2009 10:35:12 -0800
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
       alan@lxorguk.ukuu.org.uk, Alexey Starikovskiy <astarikovskiy@suse.de>,
       Andy Neitzke <neitzke@ias.edu>, Len Brown <len.brown@intel.com>,
       Thomas Renninger <trenn@suse.de>
Subject: [patch 29/33] Newly inserted battery might differ from one just
	removed, so
Message-ID: <20090204183512.GD13936@kroah.com>
References: <20090204182823.831027530@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="newly-inserted-battery-might-differ-from-one-just-removed-so.patch"
In-Reply-To: <20090204183403.GA13936@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Starikovskiy <astarikovskiy@suse.de>

commit 50b178512b7d6e7724f87459f6bd06504c9c2da1 upstream.

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Acked-by: Andy Neitzke <neitzke@ias.edu>

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/battery.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -471,7 +471,7 @@ static void sysfs_remove_battery(struct 
 
 static int acpi_battery_update(struct acpi_battery *battery)
 {
-	int result;
+	int result, old_present = acpi_battery_present(battery);
 	result = acpi_battery_get_status(battery);
 	if (result)
 		return result;
@@ -482,7 +482,8 @@ static int acpi_battery_update(struct ac
 		return 0;
 	}
 #endif
-	if (!battery->update_time) {
+	if (!battery->update_time ||
+	    old_present != acpi_battery_present(battery)) {
 		result = acpi_battery_get_info(battery);
 		if (result)
 			return result;

