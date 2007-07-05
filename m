Return-Path: <linux-kernel-owner+w=401wt.eu-S1762189AbXGETN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762189AbXGETN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 15:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760332AbXGETNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 15:13:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54899 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760280AbXGETM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 15:12:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 1/2] ACPI: Do not prepare for hibernation in acpi_shutdown
Date: Thu, 5 Jul 2007 21:18:24 +0200
User-Agent: KMail/1.9.5
Cc: Len Brown <len.brown@intel.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
References: <200707052112.30548.rjw@sisk.pl>
In-Reply-To: <200707052112.30548.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707052118.25107.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since we are now explicitly calling hibernation_ops->prepare() before
hibernation_ops->enter() in hibernation_platform_enter() (defined in
kernel/power/disk.c), ACPI should not call acpi_sleep_prepare(ACPI_STATE_S4)
from acpi_shutdown().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/acpi/sleep/poweroff.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6.22-rc6-mm1/drivers/acpi/sleep/poweroff.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/drivers/acpi/sleep/poweroff.c
+++ linux-2.6.22-rc6-mm1/drivers/acpi/sleep/poweroff.c
@@ -54,9 +54,6 @@ static int acpi_shutdown(struct sys_devi
 	case SYSTEM_POWER_OFF:
 		/* Prepare to power off the system */
 		return acpi_sleep_prepare(ACPI_STATE_S5);
-	case SYSTEM_SUSPEND_DISK:
-		/* Prepare to suspend the system to disk */
-		return acpi_sleep_prepare(ACPI_STATE_S4);
 	default:
 		return 0;
 	}

