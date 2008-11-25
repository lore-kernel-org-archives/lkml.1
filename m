Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbYKYJhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbYKYJhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 04:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYKYJh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 04:37:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44839 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbYKYJhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 04:37:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI: Revert commit faee816b150238 due to regression
Date: Tue, 25 Nov 2008 10:36:52 +0100
User-Agent: KMail/1.9.9
Cc: Zhang Rui <rui.zhang@intel.com>, "Zhao, Yakui" <yakui.zhao@intel.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, walken <walken@zoy.org>
References: <200811230053.14211.rjw@sisk.pl> <200811241430.02434.rjw@sisk.pl> <1227576051.15014.305.camel@rzhang-dt>
In-Reply-To: <1227576051.15014.305.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811251036.53084.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: ACPI: Revert commit faee816b150238 due to regression

Commit faee816b1502385dc9bc5abf2960d1cc645844d1
"ACPI: don't enable control method power button as wakeup device
when Fixed Power button is used" caused the regression tracked
as http://bugzilla.kernel.org/show_bug.cgi?id=12091 (there are no
AC adapter events on Toshiba Portege R500) and the problem this
commit was intended to fix can be fixed differently.

For this reason, the author of the commit, Zhang Rui, has requested
that it be reverted.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/scan.c |   10 ----------
 1 file changed, 10 deletions(-)

Index: linux-2.6/drivers/acpi/scan.c
===================================================================
--- linux-2.6.orig/drivers/acpi/scan.c
+++ linux-2.6/drivers/acpi/scan.c
@@ -751,16 +751,6 @@ static int acpi_bus_get_wakeup_device_fl
 	if (!acpi_match_device_ids(device, button_device_ids))
 		device->wakeup.flags.run_wake = 1;
 
-	/*
-	 * Don't set Power button GPE as run_wake
-	 * if Fixed Power button is used
-	 */
-	if (!strcmp(device->pnp.hardware_id, "PNP0C0C") &&
-		!(acpi_gbl_FADT.flags & ACPI_FADT_POWER_BUTTON)) {
-		device->wakeup.flags.run_wake = 0;
-		device->wakeup.flags.valid = 0;
-	}
-
       end:
 	if (ACPI_FAILURE(status))
 		device->flags.wake_capable = 0;
