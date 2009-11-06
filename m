Return-Path: <linux-kernel-owner+w=401wt.eu-S1759941AbZKFWFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbZKFWFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759922AbZKFWFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:05:52 -0500
Received: from kroah.org ([198.145.64.141]:39757 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195AbZKFWFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:05:50 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:51 2009
Message-Id: <20091106215951.713217304@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <len.brown@intel.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: [13/30] Revert "ACPI: Attach the ACPI device to the ACPI handle as early as possible"
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=revert-acpi-attach-the-acpi-device-to-the-acpi-handle-as-early-as-possible.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Len Brown <len.brown@intel.com>

commit f61f925859c57f6175082aeeee17743c68558a6e upstream.

This reverts commit eab4b645769fa2f8703f5a3cb0cc4ac090d347af.

http://bugzilla.kernel.org/show_bug.cgi?id=13002

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/scan.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1262,16 +1262,6 @@ acpi_add_single_object(struct acpi_devic
 	acpi_device_set_id(device, parent, handle, type);
 
 	/*
-	 * The ACPI device is attached to acpi handle before getting
-	 * the power/wakeup/peformance flags. Otherwise OS can't get
-	 * the corresponding ACPI device by the acpi handle in the course
-	 * of getting the power/wakeup/performance flags.
-	 */
-	result = acpi_device_set_context(device, type);
-	if (result)
-		goto end;
-
-	/*
 	 * Power Management
 	 * ----------------
 	 */
@@ -1301,6 +1291,8 @@ acpi_add_single_object(struct acpi_devic
 			goto end;
 	}
 
+	if ((result = acpi_device_set_context(device, type)))
+		goto end;
 
 	result = acpi_device_register(device, parent);
 


