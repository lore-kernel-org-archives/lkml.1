Return-Path: <linux-kernel-owner+w=401wt.eu-S1758996AbYJ3WNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996AbYJ3WNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYJ3WNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:13:16 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:47062 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbYJ3WNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:13:15 -0400
From: Myron Stowe <myron.stowe@hp.com>
Subject: [PATCH v2 1/3] ACPI: Disambiguate processor declaration type
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Myron Stowe <myron.stowe@hp.com>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       Zhao Yakui <yakui.zhao@intel.com>
Date: Thu, 30 Oct 2008 16:13:14 -0600
Message-ID: <20081030221314.30683.18958.stgit@bob.kio>
In-Reply-To: <20081030215410.30683.95368.stgit@bob.kio>
References: <20081030215410.30683.95368.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring processors in ACPI namespace can be done using either a
"Processor" definition or a "Device" definition (see section 8.4 -
Declaring Processors; "Advanced Configuration and Power Interface
Specification", Revision 3.0b).  Currently the two processor
declaration types are conflated.

This patch disambiguates the processor declaration's definition type
enabling subsequent code to behave uniquely based explicitly on the
declaration's type.

Signed-off-by: Myron Stowe <myron.stowe@hp.com>
Cc: Alexey Starikovskiy <aystarik@gmail.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
---

 drivers/acpi/processor_core.c |    1 +
 drivers/acpi/scan.c           |    2 +-
 include/acpi/acpi_drivers.h   |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 24a362f..0c670dd 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -89,6 +89,7 @@ static int acpi_processor_handle_eject(struct acpi_processor *pr);
 
 
 static const struct acpi_device_id processor_device_ids[] = {
+	{ACPI_PROCESSOR_OBJECT_HID, 0},
 	{ACPI_PROCESSOR_HID, 0},
 	{"", 0},
 };
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index a9dda8e..3fb6e2d 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1043,7 +1043,7 @@ static void acpi_device_set_id(struct acpi_device *device,
 		hid = ACPI_POWER_HID;
 		break;
 	case ACPI_BUS_TYPE_PROCESSOR:
-		hid = ACPI_PROCESSOR_HID;
+		hid = ACPI_PROCESSOR_OBJECT_HID;
 		break;
 	case ACPI_BUS_TYPE_SYSTEM:
 		hid = ACPI_SYSTEM_HID;
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index cf04c60..7469ff3 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -41,6 +41,7 @@
  */
 
 #define ACPI_POWER_HID			"LNXPOWER"
+#define ACPI_PROCESSOR_OBJECT_HID	"ACPI_CPU"
 #define ACPI_PROCESSOR_HID		"ACPI0007"
 #define ACPI_SYSTEM_HID			"LNXSYSTM"
 #define ACPI_THERMAL_HID		"LNXTHERM"

