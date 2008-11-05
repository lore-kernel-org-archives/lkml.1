Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbYKETlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbYKETlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbYKETl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:41:27 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:43531 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbYKETl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:41:26 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch] clocksource, acpi_pm.c: put acpi_pm_read_slow() under CONFIG_PCI
Date: Wed, 5 Nov 2008 13:40:57 -0600
User-Agent: KMail/1.9.10
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811051240.58137.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_pm_read_slow() is only used when CONFIG_PCI=y, so move the
definition inside the ifdef.

Otherwise this causes a "defined but not used" warning when
building with CONFIG_ACPI=y and CONFIG_PCI=n (that's not
supported yet, but it could be).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index c201710..e1129fa 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -57,11 +57,6 @@ u32 acpi_pm_read_verified(void)
 	return v2;
 }
 
-static cycle_t acpi_pm_read_slow(void)
-{
-	return (cycle_t)acpi_pm_read_verified();
-}
-
 static cycle_t acpi_pm_read(void)
 {
 	return (cycle_t)read_pmtmr();
@@ -88,6 +83,11 @@ static int __init acpi_pm_good_setup(char *__str)
 }
 __setup("acpi_pm_good", acpi_pm_good_setup);
 
+static cycle_t acpi_pm_read_slow(void)
+{
+	return (cycle_t)acpi_pm_read_verified();
+}
+
 static inline void acpi_pm_need_workaround(void)
 {
 	clocksource_acpi_pm.read = acpi_pm_read_slow;
