Return-Path: <linux-kernel-owner+w=401wt.eu-S937034AbXGLACa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937034AbXGLACa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935333AbXGKXhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:37:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:33547 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934326AbXGKXhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:37:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 61/61] sysfs: add parameter "struct bin_attribute *" in .read/.write methods for sysfs binary attributes
Date: Wed, 11 Jul 2007 16:32:20 -0700
Message-Id: <1184197032676-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184197026634-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
 <1184196818497-git-send-email-gregkh@suse.de>
 <11841968231043-git-send-email-gregkh@suse.de>
 <11841968271925-git-send-email-gregkh@suse.de>
 <11841968303508-git-send-email-gregkh@suse.de>
 <11841968352439-git-send-email-gregkh@suse.de>
 <11841968392043-git-send-email-gregkh@suse.de>
 <11841968431153-git-send-email-gregkh@suse.de>
 <11841968471598-git-send-email-gregkh@suse.de>
 <11841968512510-git-send-email-gregkh@suse.de>
 <1184196856662-git-send-email-gregkh@suse.de>
 <1184196860992-git-send-email-gregkh@suse.de>
 <11841968643630-git-send-email-gregkh@suse.de>
 <11841968683554-git-send-email-gregkh@suse.de>
 <11841968731843-git-send-email-gregkh@suse.de>
 <11841968773426-git-send-email-gregkh@suse.de>
 <118419688284-git-send-email-gregkh@suse.de>
 <11841968872456-git-send-email-gregkh@suse.de>
 <11841968903726-git-send-email-gregkh@suse.de>
 <11841968951572-git-send-email-gregkh@suse.de>
 <11841968992181-git-send-email-gregkh@suse.de>
 <1184196905515-git-send-email-gregkh@suse.de>
 <11841969101299-git-send-email-gregkh@suse.de>
 <11841969142368-git-send-email-gregkh@suse.de>
 <11841969191116-git-send-email-gregkh@suse.de>
 <118419692665-git-send-email-gregkh@suse.de>
 <11841969323515-git-send-email-gregkh@suse.de>
 <11841969361535-git-send-email-gregkh@suse.de>
 <11841969401152-git-send-email-gregkh@suse.de>
 <11841969453004-git-send-email-gregkh@suse.de>
 <11841969502188-git-send-email-gregkh@suse.de>
 <1184196954330-git-send-email-gregkh@suse.de>
 <11841969641445-git-send-email-gregkh@suse.de>
 <1184196968712-git-send-email-gregkh@suse.de>
 <11841969731234-git-send-email-gregkh@suse.de>
 <11841969771935-git-send-email-gregkh@suse.de>
 <11841969814023-git-send-email-gregkh@suse.de>
 <11841969873230-git-send-email-gregkh@suse.de>
 <11841969912096-git-send-email-gregkh@suse.de>
 <1184196995958-git-send-email-gregkh@suse.de>
 <11841970013184-git-send-email-gregkh@suse.de>
 <11841970052991-git-send-email-gregkh@suse.de>
 <11841970112965-git-send-email-gregkh@suse.de>
 <11841970162061-git-send-email-gregkh@suse.de>
 <11841970211456-git-send-email-gregkh@suse.de>
 <1184197026634-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

Well, first of all, I don't want to change so many files either.

What I do:
Adding a new parameter "struct bin_attribute *" in the
.read/.write methods for the sysfs binary attributes.

In fact, only the four lines change in fs/sysfs/bin.c and
include/linux/sysfs.h do the real work.
But I have to update all the files that use binary attributes
to make them compatible with the new .read and .write methods.
I'm not sure if I missed any. :(

Why I do this:
For a sysfs attribute, we can get a pointer pointing to the
struct attribute in the .show/.store method,
while we can't do this for the binary attributes.
I don't know why this is different, but this does make it not
so handy to use the binary attributes as the regular ones.
So I think this patch is reasonable. :)

Who benefits from it:
The patch that exposes ACPI tables in sysfs
requires such an improvement.
All the table binary attributes share the same .read method.
Parameter "struct bin_attribute *" is used to get
the table signature and instance number which are used to
distinguish different ACPI table binary attributes.

Without this parameter, we need to offer different .read methods
for different ACPI table binary attributes.
This is impossible as there are various ACPI tables on different
platforms, and we don't know what they are until they are loaded.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 .../firmware_sample_firmware_class.c               |    2 +
 drivers/base/firmware_class.c                      |    4 +-
 drivers/firmware/dcdbas.c                          |   10 ++--
 drivers/firmware/dell_rbu.c                        |   25 ++++++----
 drivers/i2c/chips/eeprom.c                         |    3 +-
 drivers/i2c/chips/max6875.c                        |    5 +-
 drivers/pci/hotplug/acpiphp_ibm.c                  |    6 ++-
 drivers/pci/pci-sysfs.c                            |   18 +++++--
 drivers/pcmcia/socket_sysfs.c                      |    8 ++-
 drivers/rapidio/rio-sysfs.c                        |    6 ++-
 drivers/rtc/rtc-ds1553.c                           |   10 ++--
 drivers/rtc/rtc-ds1742.c                           |   10 ++--
 drivers/s390/cio/chp.c                             |   10 ++--
 drivers/scsi/arcmsr/arcmsr_attr.c                  |   15 ++++--
 drivers/scsi/ipr.c                                 |   18 +++++--
 drivers/scsi/libsas/sas_expander.c                 |   16 ++++--
 drivers/scsi/lpfc/lpfc_attr.c                      |   12 +++--
 drivers/scsi/qla2xxx/qla_attr.c                    |   50 ++++++++++++--------
 drivers/spi/at25.c                                 |    6 ++-
 drivers/video/aty/radeon_base.c                    |    8 ++-
 drivers/w1/slaves/w1_ds2433.c                      |   10 ++--
 drivers/w1/slaves/w1_therm.c                       |    7 ++-
 drivers/w1/w1.c                                    |   12 ++++-
 drivers/zorro/zorro-sysfs.c                        |    5 +-
 fs/sysfs/bin.c                                     |    4 +-
 include/linux/sysfs.h                              |    6 ++-
 net/bridge/br_sysfs_br.c                           |    5 +-
 27 files changed, 185 insertions(+), 106 deletions(-)

diff --git a/Documentation/firmware_class/firmware_sample_firmware_class.c b/Documentation/firmware_class/firmware_sample_firmware_class.c
index 4994f1f..fba943a 100644
--- a/Documentation/firmware_class/firmware_sample_firmware_class.c
+++ b/Documentation/firmware_class/firmware_sample_firmware_class.c
@@ -78,6 +78,7 @@ static CLASS_DEVICE_ATTR(loading, 0644,
 			 firmware_loading_show, firmware_loading_store);
 
 static ssize_t firmware_data_read(struct kobject *kobj,
+				  struct bin_attribute *bin_attr,
 				  char *buffer, loff_t offset, size_t count)
 {
 	struct class_device *class_dev = to_class_dev(kobj);
@@ -88,6 +89,7 @@ static ssize_t firmware_data_read(struct kobject *kobj,
 	return count;
 }
 static ssize_t firmware_data_write(struct kobject *kobj,
+				   struct bin_attribute *bin_attr,
 				   char *buffer, loff_t offset, size_t count)
 {
 	struct class_device *class_dev = to_class_dev(kobj);
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 0e51148..53f0ee6 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -175,7 +175,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 static DEVICE_ATTR(loading, 0644, firmware_loading_show, firmware_loading_store);
 
 static ssize_t
-firmware_data_read(struct kobject *kobj,
+firmware_data_read(struct kobject *kobj, struct bin_attribute *bin_attr,
 		   char *buffer, loff_t offset, size_t count)
 {
 	struct device *dev = to_dev(kobj);
@@ -240,7 +240,7 @@ fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
  *	the driver as a firmware image.
  **/
 static ssize_t
-firmware_data_write(struct kobject *kobj,
+firmware_data_write(struct kobject *kobj, struct bin_attribute *bin_attr,
 		    char *buffer, loff_t offset, size_t count)
 {
 	struct device *dev = to_dev(kobj);
diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index 1865b56..18cdcb3 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -149,8 +149,9 @@ static ssize_t smi_data_buf_size_store(struct device *dev,
 	return count;
 }
 
-static ssize_t smi_data_read(struct kobject *kobj, char *buf, loff_t pos,
-			     size_t count)
+static ssize_t smi_data_read(struct kobject *kobj,
+			     struct bin_attribute *bin_attr,
+			     char *buf, loff_t pos, size_t count)
 {
 	size_t max_read;
 	ssize_t ret;
@@ -170,8 +171,9 @@ out:
 	return ret;
 }
 
-static ssize_t smi_data_write(struct kobject *kobj, char *buf, loff_t pos,
-			      size_t count)
+static ssize_t smi_data_write(struct kobject *kobj,
+			      struct bin_attribute *bin_attr,
+			      char *buf, loff_t pos, size_t count)
 {
 	ssize_t ret;
 
diff --git a/drivers/firmware/dell_rbu.c b/drivers/firmware/dell_rbu.c
index f8afecb..477a3d0 100644
--- a/drivers/firmware/dell_rbu.c
+++ b/drivers/firmware/dell_rbu.c
@@ -543,8 +543,9 @@ static ssize_t read_rbu_mono_data(char *buffer, loff_t pos, size_t count)
 	return ret_count;
 }
 
-static ssize_t read_rbu_data(struct kobject *kobj, char *buffer,
-	loff_t pos, size_t count)
+static ssize_t read_rbu_data(struct kobject *kobj,
+			     struct bin_attribute *bin_attr,
+			     char *buffer, loff_t pos, size_t count)
 {
 	ssize_t ret_count = 0;
 
@@ -591,8 +592,9 @@ static void callbackfn_rbu(const struct firmware *fw, void *context)
 	spin_unlock(&rbu_data.lock);
 }
 
-static ssize_t read_rbu_image_type(struct kobject *kobj, char *buffer,
-	loff_t pos, size_t count)
+static ssize_t read_rbu_image_type(struct kobject *kobj,
+				   struct bin_attribute *bin_attr,
+				   char *buffer, loff_t pos, size_t count)
 {
 	int size = 0;
 	if (!pos)
@@ -600,8 +602,9 @@ static ssize_t read_rbu_image_type(struct kobject *kobj, char *buffer,
 	return size;
 }
 
-static ssize_t write_rbu_image_type(struct kobject *kobj, char *buffer,
-	loff_t pos, size_t count)
+static ssize_t write_rbu_image_type(struct kobject *kobj,
+				    struct bin_attribute *bin_attr,
+				    char *buffer, loff_t pos, size_t count)
 {
 	int rc = count;
 	int req_firm_rc = 0;
@@ -660,8 +663,9 @@ static ssize_t write_rbu_image_type(struct kobject *kobj, char *buffer,
 	return rc;
 }
 
-static ssize_t read_rbu_packet_size(struct kobject *kobj, char *buffer,
-	loff_t pos, size_t count)
+static ssize_t read_rbu_packet_size(struct kobject *kobj,
+				    struct bin_attribute *bin_attr,
+				    char *buffer, loff_t pos, size_t count)
 {
 	int size = 0;
 	if (!pos) {
@@ -672,8 +676,9 @@ static ssize_t read_rbu_packet_size(struct kobject *kobj, char *buffer,
 	return size;
 }
 
-static ssize_t write_rbu_packet_size(struct kobject *kobj, char *buffer,
-	loff_t pos, size_t count)
+static ssize_t write_rbu_packet_size(struct kobject *kobj,
+				     struct bin_attribute *bin_attr,
+				     char *buffer, loff_t pos, size_t count)
 {
 	unsigned long temp;
 	spin_lock(&rbu_data.lock);
diff --git a/drivers/i2c/chips/eeprom.c b/drivers/i2c/chips/eeprom.c
index 5990dd5..3328164 100644
--- a/drivers/i2c/chips/eeprom.c
+++ b/drivers/i2c/chips/eeprom.c
@@ -110,7 +110,8 @@ exit:
 	mutex_unlock(&data->update_lock);
 }
 
-static ssize_t eeprom_read(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t eeprom_read(struct kobject *kobj, struct bin_attribute *bin_attr,
+			   char *buf, loff_t off, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(container_of(kobj, struct device, kobj));
 	struct eeprom_data *data = i2c_get_clientdata(client);
diff --git a/drivers/i2c/chips/max6875.c b/drivers/i2c/chips/max6875.c
index 1405ce5..4e238c0 100644
--- a/drivers/i2c/chips/max6875.c
+++ b/drivers/i2c/chips/max6875.c
@@ -125,8 +125,9 @@ exit_up:
 	mutex_unlock(&data->update_lock);
 }
 
-static ssize_t max6875_read(struct kobject *kobj, char *buf, loff_t off,
-			    size_t count)
+static ssize_t max6875_read(struct kobject *kobj,
+			    struct bin_attribute *bin_attr,
+			    char *buf, loff_t off, size_t count)
 {
 	struct i2c_client *client = kobj_to_i2c_client(kobj);
 	struct max6875_data *data = i2c_get_clientdata(client);
diff --git a/drivers/pci/hotplug/acpiphp_ibm.c b/drivers/pci/hotplug/acpiphp_ibm.c
index 74556ec..70db38c 100644
--- a/drivers/pci/hotplug/acpiphp_ibm.c
+++ b/drivers/pci/hotplug/acpiphp_ibm.c
@@ -106,7 +106,8 @@ static int ibm_get_attention_status(struct hotplug_slot *slot, u8 *status);
 static void ibm_handle_events(acpi_handle handle, u32 event, void *context);
 static int ibm_get_table_from_acpi(char **bufp);
 static ssize_t ibm_read_apci_table(struct kobject *kobj,
-		char *buffer, loff_t pos, size_t size);
+				   struct bin_attribute *bin_attr,
+				   char *buffer, loff_t pos, size_t size);
 static acpi_status __init ibm_find_acpi_device(acpi_handle handle,
 		u32 lvl, void *context, void **rv);
 static int __init ibm_acpiphp_init(void);
@@ -357,7 +358,8 @@ read_table_done:
  * our solution is to only allow reading the table in all at once
  **/
 static ssize_t ibm_read_apci_table(struct kobject *kobj,
-		char *buffer, loff_t pos, size_t size)
+				   struct bin_attribute *bin_attr,
+				   char *buffer, loff_t pos, size_t size)
 {
 	int bytes_read = -EINVAL;
 	char *table = NULL;
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index d448f8d..6543cbe 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -213,7 +213,8 @@ struct device_attribute pci_dev_attrs[] = {
 };
 
 static ssize_t
-pci_read_config(struct kobject *kobj, char *buf, loff_t off, size_t count)
+pci_read_config(struct kobject *kobj, struct bin_attribute *bin_attr,
+		char *buf, loff_t off, size_t count)
 {
 	struct pci_dev *dev = to_pci_dev(container_of(kobj,struct device,kobj));
 	unsigned int size = 64;
@@ -285,7 +286,8 @@ pci_read_config(struct kobject *kobj, char *buf, loff_t off, size_t count)
 }
 
 static ssize_t
-pci_write_config(struct kobject *kobj, char *buf, loff_t off, size_t count)
+pci_write_config(struct kobject *kobj, struct bin_attribute *bin_attr,
+		 char *buf, loff_t off, size_t count)
 {
 	struct pci_dev *dev = to_pci_dev(container_of(kobj,struct device,kobj));
 	unsigned int size = count;
@@ -352,7 +354,8 @@ pci_write_config(struct kobject *kobj, char *buf, loff_t off, size_t count)
  * callback routine (pci_legacy_read).
  */
 ssize_t
-pci_read_legacy_io(struct kobject *kobj, char *buf, loff_t off, size_t count)
+pci_read_legacy_io(struct kobject *kobj, struct bin_attribute *bin_attr,
+		   char *buf, loff_t off, size_t count)
 {
         struct pci_bus *bus = to_pci_bus(container_of(kobj,
                                                       struct class_device,
@@ -376,7 +379,8 @@ pci_read_legacy_io(struct kobject *kobj, char *buf, loff_t off, size_t count)
  * callback routine (pci_legacy_write).
  */
 ssize_t
-pci_write_legacy_io(struct kobject *kobj, char *buf, loff_t off, size_t count)
+pci_write_legacy_io(struct kobject *kobj, struct bin_attribute *bin_attr,
+		    char *buf, loff_t off, size_t count)
 {
         struct pci_bus *bus = to_pci_bus(container_of(kobj,
 						      struct class_device,
@@ -528,7 +532,8 @@ static inline void pci_remove_resource_files(struct pci_dev *dev) { return; }
  * writing anything except 0 enables it
  */
 static ssize_t
-pci_write_rom(struct kobject *kobj, char *buf, loff_t off, size_t count)
+pci_write_rom(struct kobject *kobj, struct bin_attribute *bin_attr,
+	      char *buf, loff_t off, size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(container_of(kobj, struct device, kobj));
 
@@ -551,7 +556,8 @@ pci_write_rom(struct kobject *kobj, char *buf, loff_t off, size_t count)
  * device corresponding to @kobj.
  */
 static ssize_t
-pci_read_rom(struct kobject *kobj, char *buf, loff_t off, size_t count)
+pci_read_rom(struct kobject *kobj, struct bin_attribute *bin_attr,
+	     char *buf, loff_t off, size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(container_of(kobj, struct device, kobj));
 	void __iomem *rom;
diff --git a/drivers/pcmcia/socket_sysfs.c b/drivers/pcmcia/socket_sysfs.c
index dbfbe65..b440900 100644
--- a/drivers/pcmcia/socket_sysfs.c
+++ b/drivers/pcmcia/socket_sysfs.c
@@ -283,7 +283,9 @@ static ssize_t pccard_extract_cis(struct pcmcia_socket *s, char *buf, loff_t off
 	return (ret);
 }
 
-static ssize_t pccard_show_cis(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t pccard_show_cis(struct kobject *kobj,
+			       struct bin_attribute *bin_attr,
+			       char *buf, loff_t off, size_t count)
 {
 	unsigned int size = 0x200;
 
@@ -311,7 +313,9 @@ static ssize_t pccard_show_cis(struct kobject *kobj, char *buf, loff_t off, size
 	return (count);
 }
 
-static ssize_t pccard_store_cis(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t pccard_store_cis(struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
 {
 	struct pcmcia_socket *s = to_socket(container_of(kobj, struct device, kobj));
 	cisdump_t *cis;
diff --git a/drivers/rapidio/rio-sysfs.c b/drivers/rapidio/rio-sysfs.c
index a3972b9..659e311 100644
--- a/drivers/rapidio/rio-sysfs.c
+++ b/drivers/rapidio/rio-sysfs.c
@@ -67,7 +67,8 @@ struct device_attribute rio_dev_attrs[] = {
 };
 
 static ssize_t
-rio_read_config(struct kobject *kobj, char *buf, loff_t off, size_t count)
+rio_read_config(struct kobject *kobj, struct bin_attribute *bin_attr,
+		char *buf, loff_t off, size_t count)
 {
 	struct rio_dev *dev =
 	    to_rio_dev(container_of(kobj, struct device, kobj));
@@ -137,7 +138,8 @@ rio_read_config(struct kobject *kobj, char *buf, loff_t off, size_t count)
 }
 
 static ssize_t
-rio_write_config(struct kobject *kobj, char *buf, loff_t off, size_t count)
+rio_write_config(struct kobject *kobj, struct bin_attribute *bin_attr,
+		 char *buf, loff_t off, size_t count)
 {
 	struct rio_dev *dev =
 	    to_rio_dev(container_of(kobj, struct device, kobj));
diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index b024cfb..f98a83a 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -258,8 +258,9 @@ static const struct rtc_class_ops ds1553_rtc_ops = {
 	.ioctl		= ds1553_rtc_ioctl,
 };
 
-static ssize_t ds1553_nvram_read(struct kobject *kobj, char *buf,
-				 loff_t pos, size_t size)
+static ssize_t ds1553_nvram_read(struct kobject *kobj,
+				 struct bin_attribute *bin_attr,
+				 char *buf, loff_t pos, size_t size)
 {
 	struct platform_device *pdev =
 		to_platform_device(container_of(kobj, struct device, kobj));
@@ -272,8 +273,9 @@ static ssize_t ds1553_nvram_read(struct kobject *kobj, char *buf,
 	return count;
 }
 
-static ssize_t ds1553_nvram_write(struct kobject *kobj, char *buf,
-				  loff_t pos, size_t size)
+static ssize_t ds1553_nvram_write(struct kobject *kobj,
+				  struct bin_attribute *bin_attr,
+				  char *buf, loff_t pos, size_t size)
 {
 	struct platform_device *pdev =
 		to_platform_device(container_of(kobj, struct device, kobj));
diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index 1638acd..d1778ae 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -127,8 +127,9 @@ static const struct rtc_class_ops ds1742_rtc_ops = {
 	.set_time	= ds1742_rtc_set_time,
 };
 
-static ssize_t ds1742_nvram_read(struct kobject *kobj, char *buf,
-				 loff_t pos, size_t size)
+static ssize_t ds1742_nvram_read(struct kobject *kobj,
+				 struct bin_attribute *bin_attr,
+				 char *buf, loff_t pos, size_t size)
 {
 	struct platform_device *pdev =
 		to_platform_device(container_of(kobj, struct device, kobj));
@@ -141,8 +142,9 @@ static ssize_t ds1742_nvram_read(struct kobject *kobj, char *buf,
 	return count;
 }
 
-static ssize_t ds1742_nvram_write(struct kobject *kobj, char *buf,
-				  loff_t pos, size_t size)
+static ssize_t ds1742_nvram_write(struct kobject *kobj,
+				  struct bin_attribute *bin_attr,
+				  char *buf, loff_t pos, size_t size)
 {
 	struct platform_device *pdev =
 		to_platform_device(container_of(kobj, struct device, kobj));
diff --git a/drivers/s390/cio/chp.c b/drivers/s390/cio/chp.c
index 96a8a72..b57d93d 100644
--- a/drivers/s390/cio/chp.c
+++ b/drivers/s390/cio/chp.c
@@ -141,8 +141,9 @@ static int s390_vary_chpid(struct chp_id chpid, int on)
 /*
  * Channel measurement related functions
  */
-static ssize_t chp_measurement_chars_read(struct kobject *kobj, char *buf,
-					  loff_t off, size_t count)
+static ssize_t chp_measurement_chars_read(struct kobject *kobj,
+					  struct bin_attribute *bin_attr,
+					  char *buf, loff_t off, size_t count)
 {
 	struct channel_path *chp;
 	unsigned int size;
@@ -192,8 +193,9 @@ static void chp_measurement_copy_block(struct cmg_entry *buf,
 	} while (reference_buf.values[0] != buf->values[0]);
 }
 
-static ssize_t chp_measurement_read(struct kobject *kobj, char *buf,
-				    loff_t off, size_t count)
+static ssize_t chp_measurement_read(struct kobject *kobj,
+				    struct bin_attribute *bin_attr,
+				    char *buf, loff_t off, size_t count)
 {
 	struct channel_path *chp;
 	struct channel_subsystem *css;
diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
index 8908228..06c0dce 100644
--- a/drivers/scsi/arcmsr/arcmsr_attr.c
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -59,8 +59,9 @@
 struct class_device_attribute *arcmsr_host_attrs[];
 
 static ssize_t
-arcmsr_sysfs_iop_message_read(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+arcmsr_sysfs_iop_message_read(struct kobject *kobj,
+			      struct bin_attribute *bin_attr,
+			      char *buf, loff_t off, size_t count)
 {
 	struct class_device *cdev = container_of(kobj,struct class_device,kobj);
 	struct Scsi_Host *host = class_to_shost(cdev);
@@ -105,8 +106,9 @@ arcmsr_sysfs_iop_message_read(struct kobject *kobj, char *buf, loff_t off,
 }
 
 static ssize_t
-arcmsr_sysfs_iop_message_write(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+arcmsr_sysfs_iop_message_write(struct kobject *kobj,
+			       struct bin_attribute *bin_attr,
+			       char *buf, loff_t off, size_t count)
 {
 	struct class_device *cdev = container_of(kobj,struct class_device,kobj);
 	struct Scsi_Host *host = class_to_shost(cdev);
@@ -152,8 +154,9 @@ arcmsr_sysfs_iop_message_write(struct kobject *kobj, char *buf, loff_t off,
 }
 
 static ssize_t
-arcmsr_sysfs_iop_message_clear(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+arcmsr_sysfs_iop_message_clear(struct kobject *kobj,
+			       struct bin_attribute *bin_attr,
+			       char *buf, loff_t off, size_t count)
 {
 	struct class_device *cdev = container_of(kobj,struct class_device,kobj);
 	struct Scsi_Host *host = class_to_shost(cdev);
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index fa6ff29..4a3083e 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -2465,6 +2465,7 @@ restart:
 /**
  * ipr_read_trace - Dump the adapter trace
  * @kobj:		kobject struct
+ * @bin_attr:		bin_attribute struct
  * @buf:		buffer
  * @off:		offset
  * @count:		buffer size
@@ -2472,8 +2473,9 @@ restart:
  * Return value:
  *	number of bytes printed to buffer
  **/
-static ssize_t ipr_read_trace(struct kobject *kobj, char *buf,
-			      loff_t off, size_t count)
+static ssize_t ipr_read_trace(struct kobject *kobj,
+			      struct bin_attribute *bin_attr,
+			      char *buf, loff_t off, size_t count)
 {
 	struct class_device *cdev = container_of(kobj,struct class_device,kobj);
 	struct Scsi_Host *shost = class_to_shost(cdev);
@@ -3166,6 +3168,7 @@ static struct class_device_attribute *ipr_ioa_attrs[] = {
 /**
  * ipr_read_dump - Dump the adapter
  * @kobj:		kobject struct
+ * @bin_attr:		bin_attribute struct
  * @buf:		buffer
  * @off:		offset
  * @count:		buffer size
@@ -3173,8 +3176,9 @@ static struct class_device_attribute *ipr_ioa_attrs[] = {
  * Return value:
  *	number of bytes printed to buffer
  **/
-static ssize_t ipr_read_dump(struct kobject *kobj, char *buf,
-			      loff_t off, size_t count)
+static ssize_t ipr_read_dump(struct kobject *kobj,
+			     struct bin_attribute *bin_attr,
+			     char *buf, loff_t off, size_t count)
 {
 	struct class_device *cdev = container_of(kobj,struct class_device,kobj);
 	struct Scsi_Host *shost = class_to_shost(cdev);
@@ -3327,6 +3331,7 @@ static int ipr_free_dump(struct ipr_ioa_cfg *ioa_cfg)
 /**
  * ipr_write_dump - Setup dump state of adapter
  * @kobj:		kobject struct
+ * @bin_attr:		bin_attribute struct
  * @buf:		buffer
  * @off:		offset
  * @count:		buffer size
@@ -3334,8 +3339,9 @@ static int ipr_free_dump(struct ipr_ioa_cfg *ioa_cfg)
  * Return value:
  *	number of bytes printed to buffer
  **/
-static ssize_t ipr_write_dump(struct kobject *kobj, char *buf,
-			      loff_t off, size_t count)
+static ssize_t ipr_write_dump(struct kobject *kobj,
+			      struct bin_attribute *bin_attr,
+			      char *buf, loff_t off, size_t count)
 {
 	struct class_device *cdev = container_of(kobj,struct class_device,kobj);
 	struct Scsi_Host *shost = class_to_shost(cdev);
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 578ed79..23e90c5 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -38,8 +38,10 @@ static int sas_disable_routing(struct domain_device *dev,  u8 *sas_addr);
 
 #if 0
 /* FIXME: smp needs to migrate into the sas class */
-static ssize_t smp_portal_read(struct kobject *, char *, loff_t, size_t);
-static ssize_t smp_portal_write(struct kobject *, char *, loff_t, size_t);
+static ssize_t smp_portal_read(struct kobject *, struct bin_attribute *,
+			       char *, loff_t, size_t);
+static ssize_t smp_portal_write(struct kobject *, struct bin_attribute *,
+				char *, loff_t, size_t);
 #endif
 
 /* ---------- SMP task management ---------- */
@@ -1845,8 +1847,9 @@ out:
 #if 0
 /* ---------- SMP portal ---------- */
 
-static ssize_t smp_portal_write(struct kobject *kobj, char *buf, loff_t offs,
-				size_t size)
+static ssize_t smp_portal_write(struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t offs, size_t size)
 {
 	struct domain_device *dev = to_dom_device(kobj);
 	struct expander_device *ex = &dev->ex_dev;
@@ -1872,8 +1875,9 @@ static ssize_t smp_portal_write(struct kobject *kobj, char *buf, loff_t offs,
 	return size;
 }
 
-static ssize_t smp_portal_read(struct kobject *kobj, char *buf, loff_t offs,
-			       size_t size)
+static ssize_t smp_portal_read(struct kobject *kobj,
+			       struct bin_attribute *bin_attr,
+			       char *buf, loff_t offs, size_t size)
 {
 	struct domain_device *dev = to_dom_device(kobj);
 	struct expander_device *ex = &dev->ex_dev;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index f81fe50..5dfda97 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1133,7 +1133,8 @@ struct class_device_attribute *lpfc_host_attrs[] = {
 };
 
 static ssize_t
-sysfs_ctlreg_write(struct kobject *kobj, char *buf, loff_t off, size_t count)
+sysfs_ctlreg_write(struct kobject *kobj, struct bin_attribute *bin_attr,
+		   char *buf, loff_t off, size_t count)
 {
 	size_t buf_off;
 	struct Scsi_Host *host = class_to_shost(container_of(kobj,
@@ -1165,7 +1166,8 @@ sysfs_ctlreg_write(struct kobject *kobj, char *buf, loff_t off, size_t count)
 }
 
 static ssize_t
-sysfs_ctlreg_read(struct kobject *kobj, char *buf, loff_t off, size_t count)
+sysfs_ctlreg_read(struct kobject *kobj, struct bin_attribute *bin_attr,
+		  char *buf, loff_t off, size_t count)
 {
 	size_t buf_off;
 	uint32_t * tmp_ptr;
@@ -1221,7 +1223,8 @@ sysfs_mbox_idle (struct lpfc_hba * phba)
 }
 
 static ssize_t
-sysfs_mbox_write(struct kobject *kobj, char *buf, loff_t off, size_t count)
+sysfs_mbox_write(struct kobject *kobj, struct bin_attribute *bin_attr,
+		 char *buf, loff_t off, size_t count)
 {
 	struct Scsi_Host * host =
 		class_to_shost(container_of(kobj, struct class_device, kobj));
@@ -1273,7 +1276,8 @@ sysfs_mbox_write(struct kobject *kobj, char *buf, loff_t off, size_t count)
 }
 
 static ssize_t
-sysfs_mbox_read(struct kobject *kobj, char *buf, loff_t off, size_t count)
+sysfs_mbox_read(struct kobject *kobj, struct bin_attribute *bin_attr,
+		char *buf, loff_t off, size_t count)
 {
 	struct Scsi_Host *host =
 		class_to_shost(container_of(kobj, struct class_device,
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 9658725..942db9d 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -11,8 +11,9 @@
 /* SYSFS attributes --------------------------------------------------------- */
 
 static ssize_t
-qla2x00_sysfs_read_fw_dump(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_read_fw_dump(struct kobject *kobj,
+			   struct bin_attribute *bin_attr,
+			   char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
@@ -31,8 +32,9 @@ qla2x00_sysfs_read_fw_dump(struct kobject *kobj, char *buf, loff_t off,
 }
 
 static ssize_t
-qla2x00_sysfs_write_fw_dump(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_write_fw_dump(struct kobject *kobj,
+			    struct bin_attribute *bin_attr,
+			    char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
@@ -80,8 +82,9 @@ static struct bin_attribute sysfs_fw_dump_attr = {
 };
 
 static ssize_t
-qla2x00_sysfs_read_nvram(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_read_nvram(struct kobject *kobj,
+			 struct bin_attribute *bin_attr,
+			 char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
@@ -100,8 +103,9 @@ qla2x00_sysfs_read_nvram(struct kobject *kobj, char *buf, loff_t off,
 }
 
 static ssize_t
-qla2x00_sysfs_write_nvram(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_write_nvram(struct kobject *kobj,
+			  struct bin_attribute *bin_attr,
+			  char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
@@ -155,8 +159,9 @@ static struct bin_attribute sysfs_nvram_attr = {
 };
 
 static ssize_t
-qla2x00_sysfs_read_optrom(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_read_optrom(struct kobject *kobj,
+			  struct bin_attribute *bin_attr,
+			  char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
@@ -174,8 +179,9 @@ qla2x00_sysfs_read_optrom(struct kobject *kobj, char *buf, loff_t off,
 }
 
 static ssize_t
-qla2x00_sysfs_write_optrom(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_write_optrom(struct kobject *kobj,
+			   struct bin_attribute *bin_attr,
+			   char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
@@ -203,8 +209,9 @@ static struct bin_attribute sysfs_optrom_attr = {
 };
 
 static ssize_t
-qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
+			       struct bin_attribute *bin_attr,
+			       char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
@@ -282,8 +289,9 @@ static struct bin_attribute sysfs_optrom_ctl_attr = {
 };
 
 static ssize_t
-qla2x00_sysfs_read_vpd(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_read_vpd(struct kobject *kobj,
+		       struct bin_attribute *bin_attr,
+		       char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
@@ -301,8 +309,9 @@ qla2x00_sysfs_read_vpd(struct kobject *kobj, char *buf, loff_t off,
 }
 
 static ssize_t
-qla2x00_sysfs_write_vpd(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_write_vpd(struct kobject *kobj,
+			struct bin_attribute *bin_attr,
+			char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
@@ -330,8 +339,9 @@ static struct bin_attribute sysfs_vpd_attr = {
 };
 
 static ssize_t
-qla2x00_sysfs_read_sfp(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_read_sfp(struct kobject *kobj,
+		       struct bin_attribute *bin_attr,
+		       char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
diff --git a/drivers/spi/at25.c b/drivers/spi/at25.c
index fde1ded..e007833 100644
--- a/drivers/spi/at25.c
+++ b/drivers/spi/at25.c
@@ -111,7 +111,8 @@ at25_ee_read(
 }
 
 static ssize_t
-at25_bin_read(struct kobject *kobj, char *buf, loff_t off, size_t count)
+at25_bin_read(struct kobject *kobj, struct bin_attribute *bin_attr,
+	      char *buf, loff_t off, size_t count)
 {
 	struct device		*dev;
 	struct at25_data	*at25;
@@ -236,7 +237,8 @@ at25_ee_write(struct at25_data *at25, char *buf, loff_t off, size_t count)
 }
 
 static ssize_t
-at25_bin_write(struct kobject *kobj, char *buf, loff_t off, size_t count)
+at25_bin_write(struct kobject *kobj, struct bin_attribute *bin_attr,
+	       char *buf, loff_t off, size_t count)
 {
 	struct device		*dev;
 	struct at25_data	*at25;
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 3b3c657..2349e71 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -2102,7 +2102,9 @@ static ssize_t radeon_show_one_edid(char *buf, loff_t off, size_t count, const u
 }
 
 
-static ssize_t radeon_show_edid1(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t radeon_show_edid1(struct kobject *kobj,
+				 struct bin_attribute *bin_attr,
+				 char *buf, loff_t off, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -2113,7 +2115,9 @@ static ssize_t radeon_show_edid1(struct kobject *kobj, char *buf, loff_t off, si
 }
 
 
-static ssize_t radeon_show_edid2(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t radeon_show_edid2(struct kobject *kobj,
+				 struct bin_attribute *bin_attr,
+				 char *buf, loff_t off, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct pci_dev *pdev = to_pci_dev(dev);
diff --git a/drivers/w1/slaves/w1_ds2433.c b/drivers/w1/slaves/w1_ds2433.c
index 4e13aa7..cab5600 100644
--- a/drivers/w1/slaves/w1_ds2433.c
+++ b/drivers/w1/slaves/w1_ds2433.c
@@ -91,8 +91,9 @@ static int w1_f23_refresh_block(struct w1_slave *sl, struct w1_f23_data *data,
 }
 #endif	/* CONFIG_W1_SLAVE_DS2433_CRC */
 
-static ssize_t w1_f23_read_bin(struct kobject *kobj, char *buf, loff_t off,
-			       size_t count)
+static ssize_t w1_f23_read_bin(struct kobject *kobj,
+			       struct bin_attribute *bin_attr,
+			       char *buf, loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 #ifdef CONFIG_W1_SLAVE_DS2433_CRC
@@ -199,8 +200,9 @@ static int w1_f23_write(struct w1_slave *sl, int addr, int len, const u8 *data)
 	return 0;
 }
 
-static ssize_t w1_f23_write_bin(struct kobject *kobj, char *buf, loff_t off,
-				size_t count)
+static ssize_t w1_f23_write_bin(struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 	int addr, len, idx;
diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index 8ba4e57..4318935 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -42,7 +42,8 @@ static u8 bad_roms[][9] = {
 				{}
 			};
 
-static ssize_t w1_therm_read_bin(struct kobject *, char *, loff_t, size_t);
+static ssize_t w1_therm_read_bin(struct kobject *, struct bin_attribute *,
+				 char *, loff_t, size_t);
 
 static struct bin_attribute w1_therm_bin_attr = {
 	.attr = {
@@ -158,7 +159,9 @@ static int w1_therm_check_rom(u8 rom[9])
 	return 0;
 }
 
-static ssize_t w1_therm_read_bin(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t w1_therm_read_bin(struct kobject *kobj,
+				 struct bin_attribute *bin_attr,
+				 char *buf, loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 	struct w1_master *dev = sl->master;
diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 1838cb2..f5c5b76 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -105,7 +105,9 @@ static ssize_t w1_slave_read_name(struct device *dev, struct device_attribute *a
 	return sprintf(buf, "%s\n", sl->name);
 }
 
-static ssize_t w1_slave_read_id(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t w1_slave_read_id(struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 
@@ -135,7 +137,9 @@ static struct bin_attribute w1_slave_attr_bin_id = {
 
 /* Default family */
 
-static ssize_t w1_default_write(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t w1_default_write(struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 
@@ -152,7 +156,9 @@ out_up:
 	return count;
 }
 
-static ssize_t w1_default_read(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t w1_default_read(struct kobject *kobj,
+			       struct bin_attribute *bin_attr,
+			       char *buf, loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 
diff --git a/drivers/zorro/zorro-sysfs.c b/drivers/zorro/zorro-sysfs.c
index 7e03cc6..9130f1c 100644
--- a/drivers/zorro/zorro-sysfs.c
+++ b/drivers/zorro/zorro-sysfs.c
@@ -49,8 +49,9 @@ static ssize_t zorro_show_resource(struct device *dev, struct device_attribute *
 
 static DEVICE_ATTR(resource, S_IRUGO, zorro_show_resource, NULL);
 
-static ssize_t zorro_read_config(struct kobject *kobj, char *buf, loff_t off,
-				 size_t count)
+static ssize_t zorro_read_config(struct kobject *kobj,
+				 struct bin_attribute *bin_attr,
+				 char *buf, loff_t off, size_t count)
 {
 	struct zorro_dev *z = to_zorro_dev(container_of(kobj, struct device,
 					   kobj));
diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 55796bd..135353f 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -40,7 +40,7 @@ fill_read(struct dentry *dentry, char *buffer, loff_t off, size_t count)
 
 	rc = -EIO;
 	if (attr->read)
-		rc = attr->read(kobj, buffer, off, count);
+		rc = attr->read(kobj, attr, buffer, off, count);
 
 	sysfs_put_active_two(attr_sd);
 
@@ -97,7 +97,7 @@ flush_write(struct dentry *dentry, char *buffer, loff_t offset, size_t count)
 
 	rc = -EIO;
 	if (attr->write)
-		rc = attr->write(kobj, buffer, offset, count);
+		rc = attr->write(kobj, attr, buffer, offset, count);
 
 	sysfs_put_active_two(attr_sd);
 
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 2f58ca1..be8228e 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -64,8 +64,10 @@ struct bin_attribute {
 	struct attribute	attr;
 	size_t			size;
 	void			*private;
-	ssize_t (*read)(struct kobject *, char *, loff_t, size_t);
-	ssize_t (*write)(struct kobject *, char *, loff_t, size_t);
+	ssize_t (*read)(struct kobject *, struct bin_attribute *,
+			char *, loff_t, size_t);
+	ssize_t (*write)(struct kobject *, struct bin_attribute *,
+			 char *, loff_t, size_t);
 	int (*mmap)(struct kobject *, struct bin_attribute *attr,
 		    struct vm_area_struct *vma);
 };
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 31ace23..4f42263 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -360,8 +360,9 @@ static struct attribute_group bridge_group = {
  *
  * Returns the number of bytes read.
  */
-static ssize_t brforward_read(struct kobject *kobj, char *buf,
-			   loff_t off, size_t count)
+static ssize_t brforward_read(struct kobject *kobj,
+			      struct bin_attribute *bin_attr,
+			      char *buf, loff_t off, size_t count)
 {
 	struct device *dev = to_dev(kobj);
 	struct net_bridge *br = to_bridge(dev);
-- 
1.5.2.2

