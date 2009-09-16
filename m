Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbZIPPBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbZIPPBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758969AbZIPPBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:01:15 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:35483 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbZIPPBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:01:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=xYOsNv7GbdPcbCJO2lWurwEJgX9R8SA5h0jqxRqTx4qlT5PA8xakRJpLxeX+k4gGdm
         6qi6kG4KFun89GO9P5cEEOlMKITaQ2n/SAwnwyWia1CR4WC1lojBzrGFYGsLoRsqJYIH
         gqKSMQ3rrOgSCd/Fp+TgFqTcFjRsPjoSE37IQ=
Message-ID: <4AB0FDB7.1050204@tuffmail.co.uk>
Date: Wed, 16 Sep 2009 16:01:11 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI: set acpi_driver.owner in all acpi drivers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The owner field provides the link between drivers and modules in sysfs,
but no ACPI driver was setting it.

After setting the owner field we can see which module provides which
driver and vice versa by looking at /sys/bus/acpi/driver/*/module and
/sys/module/*/drivers/acpi:*.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 arch/ia64/hp/common/aml_nfw.c           |    1 +
 arch/ia64/hp/common/sba_iommu.c         |    1 +
 drivers/acpi/ac.c                       |    1 +
 drivers/acpi/acpi_memhotplug.c          |    1 +
 drivers/acpi/acpi_pad.c                 |    1 +
 drivers/acpi/battery.c                  |    1 +
 drivers/acpi/button.c                   |    1 +
 drivers/acpi/container.c                |    1 +
 drivers/acpi/ec.c                       |    1 +
 drivers/acpi/fan.c                      |    1 +
 drivers/acpi/pci_link.c                 |    1 +
 drivers/acpi/pci_root.c                 |    1 +
 drivers/acpi/power.c                    |    1 +
 drivers/acpi/processor_core.c           |    1 +
 drivers/acpi/sbs.c                      |    1 +
 drivers/acpi/sbshc.c                    |    1 +
 drivers/acpi/thermal.c                  |    1 +
 drivers/acpi/video.c                    |    1 +
 drivers/char/hpet.c                     |    1 +
 drivers/char/sonypi.c                   |    1 +
 drivers/hwmon/asus_atk0110.c            |    1 +
 drivers/hwmon/hp_accel.c                |    1 +
 drivers/input/misc/atlas_btns.c         |    1 +
 drivers/platform/x86/asus-laptop.c      |    1 +
 drivers/platform/x86/asus_acpi.c        |    1 +
 drivers/platform/x86/eeepc-laptop.c     |    1 +
 drivers/platform/x86/fujitsu-laptop.c   |    2 ++
 drivers/platform/x86/intel_menlow.c     |    1 +
 drivers/platform/x86/panasonic-laptop.c |    1 +
 drivers/platform/x86/sony-laptop.c      |    2 ++
 drivers/platform/x86/thinkpad_acpi.c    |    1 +
 drivers/platform/x86/wmi.c              |    1 +
 32 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/hp/common/aml_nfw.c b/arch/ia64/hp/common/aml_nfw.c
index 4abd2c7..b75ec96 100644
--- a/arch/ia64/hp/common/aml_nfw.c
+++ b/arch/ia64/hp/common/aml_nfw.c
@@ -203,6 +203,7 @@ static const struct acpi_device_id aml_nfw_ids[] = {
 
 static struct acpi_driver acpi_aml_nfw_driver = {
 	.name = "native firmware",
+	.owner = THIS_MODULE,
 	.ids = aml_nfw_ids,
 	.ops = {
 		.add = aml_nfw_add,
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 674a837..06a1d12 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -2071,6 +2071,7 @@ static const struct acpi_device_id hp_ioc_iommu_device_ids[] = {
 };
 static struct acpi_driver acpi_sba_ioc_driver = {
 	.name		= "IOC IOMMU Driver",
+	.owner		= THIS_MODULE,
 	.ids		= hp_ioc_iommu_device_ids,
 	.ops		= {
 		.add	= acpi_sba_ioc_add,
diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 142744a..b24df35 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -74,6 +74,7 @@ MODULE_DEVICE_TABLE(acpi, ac_device_ids);
 static struct acpi_driver acpi_ac_driver = {
 	.name = "ac",
 	.class = ACPI_AC_CLASS,
+	.owner = THIS_MODULE,
 	.ids = ac_device_ids,
 	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
 	.ops = {
diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 30a4600..c52e14e 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -63,6 +63,7 @@ MODULE_DEVICE_TABLE(acpi, memory_device_ids);
 static struct acpi_driver acpi_memory_device_driver = {
 	.name = "acpi_memhotplug",
 	.class = ACPI_MEMORY_DEVICE_CLASS,
+	.owner = THIS_MODULE,
 	.ids = memory_device_ids,
 	.ops = {
 		.add = acpi_memory_device_add,
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index 0d2cdb8..a58d349 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -486,6 +486,7 @@ MODULE_DEVICE_TABLE(acpi, pad_device_ids);
 static struct acpi_driver acpi_pad_driver = {
 	.name = "processor_aggregator",
 	.class = ACPI_PROCESSOR_AGGREGATOR_CLASS,
+	.owner = THIS_MODULE,
 	.ids = pad_device_ids,
 	.ops = {
 		.add = acpi_pad_add,
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index f451dc0..477df0f 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -895,6 +895,7 @@ static int acpi_battery_resume(struct acpi_device *device)
 static struct acpi_driver acpi_battery_driver = {
 	.name = "battery",
 	.class = ACPI_BATTERY_CLASS,
+	.owner = THIS_MODULE,
 	.ids = battery_device_ids,
 	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
 	.ops = {
diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index d295bdc..b544c58 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -83,6 +83,7 @@ static int acpi_button_state_open_fs(struct inode *inode, struct file *file);
 static struct acpi_driver acpi_button_driver = {
 	.name = "button",
 	.class = ACPI_BUTTON_CLASS,
+	.owner = THIS_MODULE,
 	.ids = button_device_ids,
 	.ops = {
 		.add = acpi_button_add,
diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
index c54b69b..5cddeec 100644
--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -64,6 +64,7 @@ MODULE_DEVICE_TABLE(acpi, container_device_ids);
 static struct acpi_driver acpi_container_driver = {
 	.name = "container",
 	.class = ACPI_CONTAINER_CLASS,
+	.owner = THIS_MODULE,
 	.ids = container_device_ids,
 	.ops = {
 		.add = acpi_container_add,
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 26c58a3..e676060 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -989,6 +989,7 @@ static int acpi_ec_resume(struct acpi_device *device)
 static struct acpi_driver acpi_ec_driver = {
 	.name = "ec",
 	.class = ACPI_EC_CLASS,
+	.owner = THIS_MODULE,
 	.ids = ec_device_ids,
 	.ops = {
 		.add = acpi_ec_add,
diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 947556e..a479956 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -60,6 +60,7 @@ MODULE_DEVICE_TABLE(acpi, fan_device_ids);
 static struct acpi_driver acpi_fan_driver = {
 	.name = "fan",
 	.class = ACPI_FAN_CLASS,
+	.owner = THIS_MODULE,
 	.ids = fan_device_ids,
 	.ops = {
 		.add = acpi_fan_add,
diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
index 4a1e22a..f6dc56d 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -65,6 +65,7 @@ MODULE_DEVICE_TABLE(acpi, link_device_ids);
 static struct acpi_driver acpi_pci_link_driver = {
 	.name = "pci_link",
 	.class = ACPI_PCI_LINK_CLASS,
+	.owner = THIS_MODULE,
 	.ids = link_device_ids,
 	.ops = {
 		.add = acpi_pci_link_add,
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index dee9167..71f3e7d 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -55,6 +55,7 @@ MODULE_DEVICE_TABLE(acpi, root_device_ids);
 static struct acpi_driver acpi_pci_root_driver = {
 	.name = "pci_root",
 	.class = ACPI_PCI_ROOT_CLASS,
+	.owner = THIS_MODULE,
 	.ids = root_device_ids,
 	.ops = {
 		.add = acpi_pci_root_add,
diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 3cd8d45..1c81f85 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -73,6 +73,7 @@ MODULE_DEVICE_TABLE(acpi, power_device_ids);
 static struct acpi_driver acpi_power_driver = {
 	.name = "power",
 	.class = ACPI_POWER_CLASS,
+	.owner = THIS_MODULE,
 	.ids = power_device_ids,
 	.ops = {
 		.add = acpi_power_add,
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 0eb4a94..6a18d13 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -100,6 +100,7 @@ MODULE_DEVICE_TABLE(acpi, processor_device_ids);
 static struct acpi_driver acpi_processor_driver = {
 	.name = "processor",
 	.class = ACPI_PROCESSOR_CLASS,
+	.owner = THIS_MODULE,
 	.ids = processor_device_ids,
 	.ops = {
 		.add = acpi_processor_add,
diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index 4f83688..f5eed1b 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -1001,6 +1001,7 @@ static int acpi_sbs_resume(struct acpi_device *device)
 static struct acpi_driver acpi_sbs_driver = {
 	.name = "sbs",
 	.class = ACPI_SBS_CLASS,
+	.owner = THIS_MODULE,
 	.ids = sbs_device_ids,
 	.ops = {
 		.add = acpi_sbs_add,
diff --git a/drivers/acpi/sbshc.c b/drivers/acpi/sbshc.c
index c07cabd..b8e44aa 100644
--- a/drivers/acpi/sbshc.c
+++ b/drivers/acpi/sbshc.c
@@ -44,6 +44,7 @@ MODULE_DEVICE_TABLE(acpi, sbs_device_ids);
 static struct acpi_driver acpi_smb_hc_driver = {
 	.name = "smbus_hc",
 	.class = ACPI_SMB_HC_CLASS,
+	.owner = THIS_MODULE,
 	.ids = sbs_device_ids,
 	.ops = {
 		.add = acpi_smbus_hc_add,
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 767e57d..a85ba29 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -121,6 +121,7 @@ MODULE_DEVICE_TABLE(acpi, thermal_device_ids);
 static struct acpi_driver acpi_thermal_driver = {
 	.name = "thermal",
 	.class = ACPI_THERMAL_CLASS,
+	.owner = THIS_MODULE,
 	.ids = thermal_device_ids,
 	.ops = {
 		.add = acpi_thermal_add,
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 0433df3..aeeaecf 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -93,6 +93,7 @@ MODULE_DEVICE_TABLE(acpi, video_device_ids);
 static struct acpi_driver acpi_video_bus = {
 	.name = "video",
 	.class = ACPI_VIDEO_CLASS,
+	.owner = THIS_MODULE,
 	.ids = video_device_ids,
 	.ops = {
 		.add = acpi_video_bus_add,
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 4a9f349..db50345 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -988,6 +988,7 @@ MODULE_DEVICE_TABLE(acpi, hpet_device_ids);
 
 static struct acpi_driver hpet_acpi_driver = {
 	.name = "hpet",
+	.owner = THIS_MODULE,
 	.ids = hpet_device_ids,
 	.ops = {
 		.add = hpet_acpi_add,
diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index fd3dced..7fc7c17 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -1152,6 +1152,7 @@ static const struct acpi_device_id sonypi_device_ids[] = {
 static struct acpi_driver sonypi_acpi_driver = {
 	.name           = "sonypi",
 	.class          = "hkey",
+	.owner = THIS_MODULE,
 	.ids            = sonypi_device_ids,
 	.ops            = {
 		           .add = sonypi_acpi_add,
diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
index 95c744d..1a4d5e3 100644
--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -143,6 +143,7 @@ static void atk_free_sensors(struct atk_data *data);
 static struct acpi_driver atk_driver = {
 	.name	= ATK_HID,
 	.class	= "hwmon",
+	.owner = THIS_MODULE,
 	.ids	= atk_ids,
 	.ops	= {
 		.add	= atk_add,
diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index 38f8959..77dee72 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -344,6 +344,7 @@ static int lis3lv02d_resume(struct acpi_device *device)
 static struct acpi_driver lis3lv02d_driver = {
 	.name  = DRIVER_NAME,
 	.class = ACPI_MDPS_CLASS,
+	.owner = THIS_MODULE,
 	.ids   = lis3lv02d_device_ids,
 	.ops = {
 		.add     = lis3lv02d_add,
diff --git a/drivers/input/misc/atlas_btns.c b/drivers/input/misc/atlas_btns.c
index 0b7641a..55725f3 100644
--- a/drivers/input/misc/atlas_btns.c
+++ b/drivers/input/misc/atlas_btns.c
@@ -145,6 +145,7 @@ MODULE_DEVICE_TABLE(acpi, atlas_device_ids);
 static struct acpi_driver atlas_acpi_driver = {
 	.name	= ACPI_ATLAS_NAME,
 	.class	= ACPI_ATLAS_CLASS,
+	.owner = THIS_MODULE,
 	.ids	= atlas_device_ids,
 	.ops	= {
 		.add	= atlas_acpi_button_add,
diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 4234edb..6c05172 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -232,6 +232,7 @@ static void asus_hotk_notify(struct acpi_device *device, u32 event);
 static struct acpi_driver asus_hotk_driver = {
 	.name = ASUS_HOTK_NAME,
 	.class = ASUS_HOTK_CLASS,
+	.owner = THIS_MODULE,
 	.ids = asus_device_ids,
 	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
 	.ops = {
diff --git a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
index 502692b..55b84df 100644
--- a/drivers/platform/x86/asus_acpi.c
+++ b/drivers/platform/x86/asus_acpi.c
@@ -466,6 +466,7 @@ MODULE_DEVICE_TABLE(acpi, asus_device_ids);
 static struct acpi_driver asus_hotk_driver = {
 	.name = "asus_acpi",
 	.class = ACPI_HOTK_CLASS,
+	.owner = THIS_MODULE,
 	.ids = asus_device_ids,
 	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
 	.ops = {
diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index eba3772..bb11e47 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -213,6 +213,7 @@ MODULE_DEVICE_TABLE(acpi, eeepc_device_ids);
 static struct acpi_driver eeepc_hotk_driver = {
 	.name = EEEPC_HOTK_NAME,
 	.class = EEEPC_HOTK_CLASS,
+	.owner = THIS_MODULE,
 	.ids = eeepc_device_ids,
 	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
 	.ops = {
diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index 2ab0318..90ecf8e 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -1052,6 +1052,7 @@ static const struct acpi_device_id fujitsu_device_ids[] = {
 static struct acpi_driver acpi_fujitsu_driver = {
 	.name = ACPI_FUJITSU_DRIVER_NAME,
 	.class = ACPI_FUJITSU_CLASS,
+	.owner = THIS_MODULE,
 	.ids = fujitsu_device_ids,
 	.ops = {
 		.add = acpi_fujitsu_add,
@@ -1068,6 +1069,7 @@ static const struct acpi_device_id fujitsu_hotkey_device_ids[] = {
 static struct acpi_driver acpi_fujitsu_hotkey_driver = {
 	.name = ACPI_FUJITSU_HOTKEY_DRIVER_NAME,
 	.class = ACPI_FUJITSU_CLASS,
+	.owner = THIS_MODULE,
 	.ids = fujitsu_hotkey_device_ids,
 	.ops = {
 		.add = acpi_fujitsu_hotkey_add,
diff --git a/drivers/platform/x86/intel_menlow.c b/drivers/platform/x86/intel_menlow.c
index 58de8fd..937350c 100644
--- a/drivers/platform/x86/intel_menlow.c
+++ b/drivers/platform/x86/intel_menlow.c
@@ -211,6 +211,7 @@ static const struct acpi_device_id intel_menlow_memory_ids[] = {
 
 static struct acpi_driver intel_menlow_memory_driver = {
 	.name = "intel_menlow_thermal_control",
+	.owner = THIS_MODULE,
 	.ids = intel_menlow_memory_ids,
 	.ops = {
 		.add = intel_menlow_memory_add,
diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index cd6fbdb..b9c0402 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -190,6 +190,7 @@ MODULE_DEVICE_TABLE(acpi, pcc_device_ids);
 static struct acpi_driver acpi_pcc_driver = {
 	.name =		ACPI_PCC_DRIVER_NAME,
 	.class =	ACPI_PCC_CLASS,
+	.owner = THIS_MODULE,
 	.ids =		pcc_device_ids,
 	.ops =		{
 				.add =		acpi_pcc_hotkey_add,
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index f9f68e0..44f4f73 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1352,6 +1352,7 @@ static const struct acpi_device_id sony_nc_device_ids[] = {
 static struct acpi_driver sony_nc_driver = {
 	.name = SONY_NC_DRIVER_NAME,
 	.class = SONY_NC_CLASS,
+	.owner = THIS_MODULE,
 	.ids = sony_nc_device_ids,
 	.owner = THIS_MODULE,
 	.ops = {
@@ -2901,6 +2902,7 @@ static const struct acpi_device_id sony_pic_device_ids[] = {
 static struct acpi_driver sony_pic_driver = {
 	.name = SONY_PIC_DRIVER_NAME,
 	.class = SONY_PIC_CLASS,
+	.owner = THIS_MODULE,
 	.ids = sony_pic_device_ids,
 	.owner = THIS_MODULE,
 	.ops = {
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index e856008..51d247c 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -706,6 +706,7 @@ static int __init register_tpacpi_subdriver(struct ibm_struct *ibm)
 	}
 
 	sprintf(ibm->acpi->driver->name, "%s_%s", TPACPI_NAME, ibm->name);
+	ibm->acpi->driver->owner = THIS_MODULE;
 	ibm->acpi->driver->ids = ibm->acpi->hid;
 
 	ibm->acpi->driver->ops.add = &tpacpi_device_add;
diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index d889f51..f1e7481 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -92,6 +92,7 @@ MODULE_DEVICE_TABLE(acpi, wmi_device_ids);
 static struct acpi_driver acpi_wmi_driver = {
 	.name = "wmi",
 	.class = ACPI_WMI_CLASS,
+	.owner = THIS_MODULE,
 	.ids = wmi_device_ids,
 	.ops = {
 		.add = acpi_wmi_add,
-- 
1.6.3.2



