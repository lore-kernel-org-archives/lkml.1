Return-Path: <linux-kernel-owner+w=401wt.eu-S1761472AbXFQU0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761472AbXFQU0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 16:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760454AbXFQU0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 16:26:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:53733 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbXFQU0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 16:26:06 -0400
Subject: [PATCH 1/3] ACPI autoloading - ACPICA adjustance
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-t9BybZ1tzay5RopewCmP"
Date: Sun, 17 Jun 2007 22:24:14 +0200
Message-Id: <1182111854.4204.4.camel@noname>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-t9BybZ1tzay5RopewCmP
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Define standardized HIDs - Rename current acpi_device_id to __acpi_device_id

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 drivers/acpi/events/evrgnini.c    |    2 +-
 drivers/acpi/namespace/nsxfeval.c |    2 +-
 drivers/acpi/utilities/uteval.c   |    4 ++--
 include/acpi/acpi_bus.h           |    5 +++--
 include/acpi/acpi_drivers.h       |   33 +++++++++++++++++++++++++--------
 include/acpi/actypes.h            |    6 +++---
 include/acpi/acutils.h            |    4 ++--
 7 files changed, 37 insertions(+), 19 deletions(-)

Index: linux-2.6.22-rc4/drivers/acpi/events/evrgnini.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/acpi/events/evrgnini.c
+++ linux-2.6.22-rc4/drivers/acpi/events/evrgnini.c
@@ -377,7 +377,7 @@ static u8 acpi_ev_match_pci_root_bridge(
 static u8 acpi_ev_is_pci_root_bridge(struct acpi_namespace_node *node)
 {
 	acpi_status status;
-	struct acpi_device_id hid;
+	struct __acpi_device_id hid;
 	struct acpi_compatible_id_list *cid;
 	acpi_native_uint i;
 
Index: linux-2.6.22-rc4/drivers/acpi/utilities/uteval.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/acpi/utilities/uteval.c
+++ linux-2.6.22-rc4/drivers/acpi/utilities/uteval.c
@@ -410,7 +410,7 @@ acpi_ut_copy_id_string(char *destination
 
 acpi_status
 acpi_ut_execute_HID(struct acpi_namespace_node *device_node,
-		    struct acpi_device_id *hid)
+		    struct __acpi_device_id *hid)
 {
 	union acpi_operand_object *obj_desc;
 	acpi_status status;
@@ -612,7 +612,7 @@ acpi_ut_execute_CID(struct acpi_namespac
 
 acpi_status
 acpi_ut_execute_UID(struct acpi_namespace_node *device_node,
-		    struct acpi_device_id *uid)
+		    struct __acpi_device_id *uid)
 {
 	union acpi_operand_object *obj_desc;
 	acpi_status status;
Index: linux-2.6.22-rc4/include/acpi/actypes.h
===================================================================
--- linux-2.6.22-rc4.orig/include/acpi/actypes.h
+++ linux-2.6.22-rc4/include/acpi/actypes.h
@@ -809,7 +809,7 @@ acpi_status(*acpi_walk_callback) (acpi_h
 
 /* Common string version of device HIDs and UIDs */
 
-struct acpi_device_id {
+struct __acpi_device_id {
 	char value[ACPI_DEVICE_ID_LENGTH];
 };
 
@@ -859,8 +859,8 @@ struct acpi_device_info {
 	u32 valid;		/* Indicates which fields below are valid */
 	u32 current_status;	/* _STA value */
 	acpi_integer address;	/* _ADR value if any */
-	struct acpi_device_id hardware_id;	/* _HID value if any */
-	struct acpi_device_id unique_id;	/* _UID value if any */
+	struct __acpi_device_id hardware_id;	/* _HID value if any */
+	struct __acpi_device_id unique_id;	/* _UID value if any */
 	u8 highest_dstates[4];	/* _sx_d values: 0xFF indicates not valid */
 	struct acpi_compatible_id_list compatibility_id;	/* List of _CIDs if any */
 };
Index: linux-2.6.22-rc4/include/acpi/acutils.h
===================================================================
--- linux-2.6.22-rc4.orig/include/acpi/acutils.h
+++ linux-2.6.22-rc4/include/acpi/acutils.h
@@ -354,7 +354,7 @@ acpi_ut_evaluate_numeric_object(char *ob
 
 acpi_status
 acpi_ut_execute_HID(struct acpi_namespace_node *device_node,
-		    struct acpi_device_id *hid);
+		    struct __acpi_device_id *hid);
 
 acpi_status
 acpi_ut_execute_CID(struct acpi_namespace_node *device_node,
@@ -366,7 +366,7 @@ acpi_ut_execute_STA(struct acpi_namespac
 
 acpi_status
 acpi_ut_execute_UID(struct acpi_namespace_node *device_node,
-		    struct acpi_device_id *uid);
+		    struct __acpi_device_id *uid);
 
 acpi_status
 acpi_ut_execute_sxds(struct acpi_namespace_node *device_node, u8 * highest);
Index: linux-2.6.22-rc4/include/acpi/acpi_bus.h
===================================================================
--- linux-2.6.22-rc4.orig/include/acpi/acpi_bus.h
+++ linux-2.6.22-rc4/include/acpi/acpi_bus.h
@@ -131,7 +131,7 @@ struct acpi_device_ops {
 struct acpi_driver {
 	char name[80];
 	char class[80];
-	char *ids;		/* Supported Hardware IDs */
+	const struct acpi_device_id *ids; /* Supported Hardware IDs */
 	struct acpi_device_ops ops;
 	struct device_driver drv;
 	struct module *owner;
@@ -340,7 +340,8 @@ int acpi_bus_add(struct acpi_device **ch
 int acpi_bus_trim(struct acpi_device *start, int rmdevice);
 int acpi_bus_start(struct acpi_device *device);
 acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
-int acpi_match_ids(struct acpi_device *device, char *ids);
+int acpi_match_device_ids(struct acpi_device *device,
+			  const struct acpi_device_id *ids);
 int acpi_create_dir(struct acpi_device *);
 void acpi_remove_dir(struct acpi_device *);
 
Index: linux-2.6.22-rc4/include/acpi/acpi_drivers.h
===================================================================
--- linux-2.6.22-rc4.orig/include/acpi/acpi_drivers.h
+++ linux-2.6.22-rc4/include/acpi/acpi_drivers.h
@@ -34,16 +34,33 @@
 #define ACPI_BUS_COMPONENT		0x00010000
 #define ACPI_SYSTEM_COMPONENT		0x02000000
 
-/* _HID definitions */
+/*
+  _HID definitions
+  HIDs starting with 'X' are self defined here and are used for devices where
+  a HID does not exist in spec.
+  HIDs must conform to (ACPI spec - 6.1.4):
 
-#define ACPI_POWER_HID			"power_resource"
+  Numeric 32-bit compressed EISA type ID are not supported (never seen one as
+  an ACPI HID?)
+
+  A valid PNP ID must be of the form AAA#### where A is an uppercase letter
+  and # is a hex digit.
+  A valid ACPI ID must be of the form ACPI#### where # is a hex digit.
+
+  and our self-defined: XAAA#### where A is an uppercase letter and # is a hex
+  digit.
+
+*/
+
+#define ACPI_POWER_HID			"XPWR0001"
 #define ACPI_PROCESSOR_HID		"ACPI0007"
-#define ACPI_SYSTEM_HID			"acpi_system"
-#define ACPI_THERMAL_HID		"thermal"
-#define ACPI_BUTTON_HID_POWERF		"button_power"
-#define ACPI_BUTTON_HID_SLEEPF		"button_sleep"
-#define ACPI_VIDEO_HID			"video"
-#define ACPI_BAY_HID			"bay"
+#define ACPI_SYSTEM_HID			"XSYS0001"
+#define ACPI_THERMAL_HID		"XTHM0001"
+#define ACPI_BUTTON_HID_POWERF		"XPBT0001"
+#define ACPI_BUTTON_HID_SLEEPF		"XSBT0001"
+#define ACPI_VIDEO_HID			"XVID0001"
+#define ACPI_BAY_HID			"XBAY0001"
+
 /* --------------------------------------------------------------------------
                                        PCI
    -------------------------------------------------------------------------- */
Index: linux-2.6.22-rc4/drivers/acpi/namespace/nsxfeval.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/acpi/namespace/nsxfeval.c
+++ linux-2.6.22-rc4/drivers/acpi/namespace/nsxfeval.c
@@ -440,7 +440,7 @@ acpi_ns_get_device_callback(acpi_handle 
 	acpi_status status;
 	struct acpi_namespace_node *node;
 	u32 flags;
-	struct acpi_device_id hid;
+	struct __acpi_device_id hid;
 	struct acpi_compatible_id_list *cid;
 	acpi_native_uint i;
 


--=-t9BybZ1tzay5RopewCmP
Content-Disposition: attachment; filename=acpica_rename_device_id.patch
Content-Type: text/x-patch; name=acpica_rename_device_id.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Define standardized HIDs - Rename current acpi_device_id to __acpi_device_id

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 drivers/acpi/events/evrgnini.c    |    2 +-
 drivers/acpi/namespace/nsxfeval.c |    2 +-
 drivers/acpi/utilities/uteval.c   |    4 ++--
 include/acpi/acpi_bus.h           |    5 +++--
 include/acpi/acpi_drivers.h       |   33 +++++++++++++++++++++++++--------
 include/acpi/actypes.h            |    6 +++---
 include/acpi/acutils.h            |    4 ++--
 7 files changed, 37 insertions(+), 19 deletions(-)

Index: linux-2.6.22-rc4/drivers/acpi/events/evrgnini.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/acpi/events/evrgnini.c
+++ linux-2.6.22-rc4/drivers/acpi/events/evrgnini.c
@@ -377,7 +377,7 @@ static u8 acpi_ev_match_pci_root_bridge(
 static u8 acpi_ev_is_pci_root_bridge(struct acpi_namespace_node *node)
 {
 	acpi_status status;
-	struct acpi_device_id hid;
+	struct __acpi_device_id hid;
 	struct acpi_compatible_id_list *cid;
 	acpi_native_uint i;
 
Index: linux-2.6.22-rc4/drivers/acpi/utilities/uteval.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/acpi/utilities/uteval.c
+++ linux-2.6.22-rc4/drivers/acpi/utilities/uteval.c
@@ -410,7 +410,7 @@ acpi_ut_copy_id_string(char *destination
 
 acpi_status
 acpi_ut_execute_HID(struct acpi_namespace_node *device_node,
-		    struct acpi_device_id *hid)
+		    struct __acpi_device_id *hid)
 {
 	union acpi_operand_object *obj_desc;
 	acpi_status status;
@@ -612,7 +612,7 @@ acpi_ut_execute_CID(struct acpi_namespac
 
 acpi_status
 acpi_ut_execute_UID(struct acpi_namespace_node *device_node,
-		    struct acpi_device_id *uid)
+		    struct __acpi_device_id *uid)
 {
 	union acpi_operand_object *obj_desc;
 	acpi_status status;
Index: linux-2.6.22-rc4/include/acpi/actypes.h
===================================================================
--- linux-2.6.22-rc4.orig/include/acpi/actypes.h
+++ linux-2.6.22-rc4/include/acpi/actypes.h
@@ -809,7 +809,7 @@ acpi_status(*acpi_walk_callback) (acpi_h
 
 /* Common string version of device HIDs and UIDs */
 
-struct acpi_device_id {
+struct __acpi_device_id {
 	char value[ACPI_DEVICE_ID_LENGTH];
 };
 
@@ -859,8 +859,8 @@ struct acpi_device_info {
 	u32 valid;		/* Indicates which fields below are valid */
 	u32 current_status;	/* _STA value */
 	acpi_integer address;	/* _ADR value if any */
-	struct acpi_device_id hardware_id;	/* _HID value if any */
-	struct acpi_device_id unique_id;	/* _UID value if any */
+	struct __acpi_device_id hardware_id;	/* _HID value if any */
+	struct __acpi_device_id unique_id;	/* _UID value if any */
 	u8 highest_dstates[4];	/* _sx_d values: 0xFF indicates not valid */
 	struct acpi_compatible_id_list compatibility_id;	/* List of _CIDs if any */
 };
Index: linux-2.6.22-rc4/include/acpi/acutils.h
===================================================================
--- linux-2.6.22-rc4.orig/include/acpi/acutils.h
+++ linux-2.6.22-rc4/include/acpi/acutils.h
@@ -354,7 +354,7 @@ acpi_ut_evaluate_numeric_object(char *ob
 
 acpi_status
 acpi_ut_execute_HID(struct acpi_namespace_node *device_node,
-		    struct acpi_device_id *hid);
+		    struct __acpi_device_id *hid);
 
 acpi_status
 acpi_ut_execute_CID(struct acpi_namespace_node *device_node,
@@ -366,7 +366,7 @@ acpi_ut_execute_STA(struct acpi_namespac
 
 acpi_status
 acpi_ut_execute_UID(struct acpi_namespace_node *device_node,
-		    struct acpi_device_id *uid);
+		    struct __acpi_device_id *uid);
 
 acpi_status
 acpi_ut_execute_sxds(struct acpi_namespace_node *device_node, u8 * highest);
Index: linux-2.6.22-rc4/include/acpi/acpi_bus.h
===================================================================
--- linux-2.6.22-rc4.orig/include/acpi/acpi_bus.h
+++ linux-2.6.22-rc4/include/acpi/acpi_bus.h
@@ -131,7 +131,7 @@ struct acpi_device_ops {
 struct acpi_driver {
 	char name[80];
 	char class[80];
-	char *ids;		/* Supported Hardware IDs */
+	const struct acpi_device_id *ids; /* Supported Hardware IDs */
 	struct acpi_device_ops ops;
 	struct device_driver drv;
 	struct module *owner;
@@ -340,7 +340,8 @@ int acpi_bus_add(struct acpi_device **ch
 int acpi_bus_trim(struct acpi_device *start, int rmdevice);
 int acpi_bus_start(struct acpi_device *device);
 acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
-int acpi_match_ids(struct acpi_device *device, char *ids);
+int acpi_match_device_ids(struct acpi_device *device,
+			  const struct acpi_device_id *ids);
 int acpi_create_dir(struct acpi_device *);
 void acpi_remove_dir(struct acpi_device *);
 
Index: linux-2.6.22-rc4/include/acpi/acpi_drivers.h
===================================================================
--- linux-2.6.22-rc4.orig/include/acpi/acpi_drivers.h
+++ linux-2.6.22-rc4/include/acpi/acpi_drivers.h
@@ -34,16 +34,33 @@
 #define ACPI_BUS_COMPONENT		0x00010000
 #define ACPI_SYSTEM_COMPONENT		0x02000000
 
-/* _HID definitions */
+/*
+  _HID definitions
+  HIDs starting with 'X' are self defined here and are used for devices where
+  a HID does not exist in spec.
+  HIDs must conform to (ACPI spec - 6.1.4):
 
-#define ACPI_POWER_HID			"power_resource"
+  Numeric 32-bit compressed EISA type ID are not supported (never seen one as
+  an ACPI HID?)
+
+  A valid PNP ID must be of the form AAA#### where A is an uppercase letter
+  and # is a hex digit.
+  A valid ACPI ID must be of the form ACPI#### where # is a hex digit.
+
+  and our self-defined: XAAA#### where A is an uppercase letter and # is a hex
+  digit.
+
+*/
+
+#define ACPI_POWER_HID			"XPWR0001"
 #define ACPI_PROCESSOR_HID		"ACPI0007"
-#define ACPI_SYSTEM_HID			"acpi_system"
-#define ACPI_THERMAL_HID		"thermal"
-#define ACPI_BUTTON_HID_POWERF		"button_power"
-#define ACPI_BUTTON_HID_SLEEPF		"button_sleep"
-#define ACPI_VIDEO_HID			"video"
-#define ACPI_BAY_HID			"bay"
+#define ACPI_SYSTEM_HID			"XSYS0001"
+#define ACPI_THERMAL_HID		"XTHM0001"
+#define ACPI_BUTTON_HID_POWERF		"XPBT0001"
+#define ACPI_BUTTON_HID_SLEEPF		"XSBT0001"
+#define ACPI_VIDEO_HID			"XVID0001"
+#define ACPI_BAY_HID			"XBAY0001"
+
 /* --------------------------------------------------------------------------
                                        PCI
    -------------------------------------------------------------------------- */
Index: linux-2.6.22-rc4/drivers/acpi/namespace/nsxfeval.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/acpi/namespace/nsxfeval.c
+++ linux-2.6.22-rc4/drivers/acpi/namespace/nsxfeval.c
@@ -440,7 +440,7 @@ acpi_ns_get_device_callback(acpi_handle 
 	acpi_status status;
 	struct acpi_namespace_node *node;
 	u32 flags;
-	struct acpi_device_id hid;
+	struct __acpi_device_id hid;
 	struct acpi_compatible_id_list *cid;
 	acpi_native_uint i;
 

--=-t9BybZ1tzay5RopewCmP--

