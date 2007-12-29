Return-Path: <linux-kernel-owner+w=401wt.eu-S1756323AbXL2IYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbXL2IYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 03:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbXL2IYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 03:24:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:57627 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbXL2IYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 03:24:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,219,1196668800"; 
   d="scan'208";a="308923223"
Subject: [PATCH linux-acpi] Correct wakeup set error and append a new
	column PCI ID
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org,
       acpi-bugzilla@lists.sourceforge.net
In-Reply-To: <1198744900.3640.4.camel@yangyi-dev.bj.intel.com>
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com>
	 <1198744900.3640.4.camel@yangyi-dev.bj.intel.com>
Content-Type: text/plain
Organization: Intel
Date: Sat, 29 Dec 2007 16:22:33 +0800
Message-Id: <1198916553.3806.2.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: ACPI: Correct wakeup set error and append a new column PCI ID
From: Yi Yang <yi.y.yang@intel.com>

The user can't get any information when echo an invalid value to
/proc/acpi/wakeup although it is failed, but the user can set
/proc/acpi/wakeup successfully if echo an value whose prefix is a
valid value for /proc/acpi/wakeup no matter what the suffix is.

/proc/acpi/wakeup is also case-sensitive, case-insensitive is better.

This patch will fix the aforementioned issues, it will return the error
information if input is an invalid value, it also make /proc/acpi/wakeup
case-insensitive, i.e. it consider 'SLPB' and 'sLpb'are the same.

In addtion, this patch appends a new column 'PCI ID' to /proc/acpi/wakeup
, the user can use it to get the corresponding device name very
conveniently because PCI ID is a unique identifier and platform-independent.

Before applying this patch, the output is:

[root@localhost ~]# cat /proc/acpi/wakeup
Device  S-state   Status   Sysfs node
C093      S5     disabled  pci:0000:00:1e.0
C0E8      S3     disabled  pci:0000:00:1d.0
C0EF      S3     disabled  pci:0000:00:1d.1
C0F0      S3     disabled  pci:0000:00:1d.2
C0F1      S3     disabled  pci:0000:00:1d.3
C0F2      S3     disabled  pci:0000:00:1d.7
C0F9      S0     disabled  pci:0000:00:1c.0
C21D      S0     disabled  pci:0000:08:00.0
C109      S5     disabled  pci:0000:00:1c.1
C228      S5     disabled  pci:0000:10:00.0
C10F      S5     disabled  pci:0000:00:1c.3
C229      S5     disabled
[root@localhost ~]# echo "xyzw" > /proc/acpi/wakeup
[root@localhost ~]# echo "C093xxxxxxxxx" > /proc/acpi/wakeup
[root@localhost ~]# cat /proc/acpi/wakeup
Device  S-state   Status   Sysfs node
C093      S5     enabled   pci:0000:00:1e.0
C0E8      S3     disabled  pci:0000:00:1d.0
C0EF      S3     disabled  pci:0000:00:1d.1
C0F0      S3     disabled  pci:0000:00:1d.2
C0F1      S3     disabled  pci:0000:00:1d.3
C0F2      S3     disabled  pci:0000:00:1d.7
C0F9      S0     disabled  pci:0000:00:1c.0
C21D      S0     disabled  pci:0000:08:00.0
C109      S5     disabled  pci:0000:00:1c.1
C228      S5     disabled  pci:0000:10:00.0
C10F      S5     disabled  pci:0000:00:1c.3
C229      S5     disabled
[root@localhost ~]# echo "C093xxxxxxxxx" > /proc/acpi/wakeup
[root@localhost ~]# cat /proc/acpi/wakeup
Device  S-state   Status   Sysfs node
C093      S5     disabled  pci:0000:00:1e.0
C0E8      S3     disabled  pci:0000:00:1d.0
C0EF      S3     disabled  pci:0000:00:1d.1
C0F0      S3     disabled  pci:0000:00:1d.2
C0F1      S3     disabled  pci:0000:00:1d.3
C0F2      S3     disabled  pci:0000:00:1d.7
C0F9      S0     disabled  pci:0000:00:1c.0
C21D      S0     disabled  pci:0000:08:00.0
C109      S5     disabled  pci:0000:00:1c.1
C228      S5     disabled  pci:0000:10:00.0
C10F      S5     disabled  pci:0000:00:1c.3
C229      S5     disabled
[root@localhost ~]# echo "c093" > /proc/acpi/wakeup
[root@localhost ~]# cat /proc/acpi/wakeup
Device  S-state   Status   Sysfs node
C093      S5     disabled  pci:0000:00:1e.0
C0E8      S3     disabled  pci:0000:00:1d.0
C0EF      S3     disabled  pci:0000:00:1d.1
C0F0      S3     disabled  pci:0000:00:1d.2
C0F1      S3     disabled  pci:0000:00:1d.3
C0F2      S3     disabled  pci:0000:00:1d.7
C0F9      S0     disabled  pci:0000:00:1c.0
C21D      S0     disabled  pci:0000:08:00.0
C109      S5     disabled  pci:0000:00:1c.1
C228      S5     disabled  pci:0000:10:00.0
C10F      S5     disabled  pci:0000:00:1c.3
C229      S5     disabled
[root@localhost ~]#

After applying this patch, the output is:

[root@localhost ~]# cat /proc/acpi/wakeup
Device  S-state   Status   Sysfs node           PCI ID
C093      S5     disabled  pci:0000:00:1e.0     0x2448
C0E8      S3     disabled  pci:0000:00:1d.0     0x27c8
C0EF      S3     disabled  pci:0000:00:1d.1     0x27c9
C0F0      S3     disabled  pci:0000:00:1d.2     0x27ca
C0F1      S3     disabled  pci:0000:00:1d.3     0x27cb
C0F2      S3     disabled  pci:0000:00:1d.7     0x27cc
C0F9      S0     disabled  pci:0000:00:1c.0     0x27d0
C21D      S0     disabled  pci:0000:08:00.0     0x16fd
C109      S5     disabled  pci:0000:00:1c.1     0x27d2
C228      S5     disabled  pci:0000:10:00.0     0x4222
C10F      S5     disabled  pci:0000:00:1c.3     0x27d6
C229      S5     disabled
[root@localhost ~]# echo "xyzw" > /proc/acpi/wakeup
-bash: echo: write error: Invalid argument
[root@localhost ~]# echo "C093xxxxxxxxx" > /proc/acpi/wakeup
-bash: echo: write error: Invalid argument
[root@localhost ~]# cat /proc/acpi/wakeup
Device  S-state   Status   Sysfs node           PCI ID
C093      S5     disabled  pci:0000:00:1e.0     0x2448
C0E8      S3     disabled  pci:0000:00:1d.0     0x27c8
C0EF      S3     disabled  pci:0000:00:1d.1     0x27c9
C0F0      S3     disabled  pci:0000:00:1d.2     0x27ca
C0F1      S3     disabled  pci:0000:00:1d.3     0x27cb
C0F2      S3     disabled  pci:0000:00:1d.7     0x27cc
C0F9      S0     disabled  pci:0000:00:1c.0     0x27d0
C21D      S0     disabled  pci:0000:08:00.0     0x16fd
C109      S5     disabled  pci:0000:00:1c.1     0x27d2
C228      S5     disabled  pci:0000:10:00.0     0x4222
C10F      S5     disabled  pci:0000:00:1c.3     0x27d6
C229      S5     disabled
[root@localhost ~]# echo "c093" > /proc/acpi/wakeup
[root@localhost ~]# cat /proc/acpi/wakeup
Device  S-state   Status   Sysfs node           PCI ID
C093      S5     enabled   pci:0000:00:1e.0     0x2448
C0E8      S3     disabled  pci:0000:00:1d.0     0x27c8
C0EF      S3     disabled  pci:0000:00:1d.1     0x27c9
C0F0      S3     disabled  pci:0000:00:1d.2     0x27ca
C0F1      S3     disabled  pci:0000:00:1d.3     0x27cb
C0F2      S3     disabled  pci:0000:00:1d.7     0x27cc
C0F9      S0     disabled  pci:0000:00:1c.0     0x27d0
C21D      S0     disabled  pci:0000:08:00.0     0x16fd
C109      S5     disabled  pci:0000:00:1c.1     0x27d2
C228      S5     disabled  pci:0000:10:00.0     0x4222
C10F      S5     disabled  pci:0000:00:1c.3     0x27d6
C229      S5     disabled
[root@localhost ~]# echo "C093" > /proc/acpi/wakeup
[root@localhost ~]# cat /proc/acpi/wakeup
Device  S-state   Status   Sysfs node           PCI ID
C093      S5     disabled  pci:0000:00:1e.0     0x2448
C0E8      S3     disabled  pci:0000:00:1d.0     0x27c8
C0EF      S3     disabled  pci:0000:00:1d.1     0x27c9
C0F0      S3     disabled  pci:0000:00:1d.2     0x27ca
C0F1      S3     disabled  pci:0000:00:1d.3     0x27cb
C0F2      S3     disabled  pci:0000:00:1d.7     0x27cc
C0F9      S0     disabled  pci:0000:00:1c.0     0x27d0
C21D      S0     disabled  pci:0000:08:00.0     0x16fd
C109      S5     disabled  pci:0000:00:1c.1     0x27d2
C228      S5     disabled  pci:0000:10:00.0     0x4222
C10F      S5     disabled  pci:0000:00:1c.3     0x27d6
C229      S5     disabled
[root@localhost ~]#

Signed-off-by: Yi Yang <yi.y.yang@intel.com>
---
 proc.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/sleep/proc.c b/drivers/acpi/sleep/proc.c
index f8df521..a19b6bd 100644
--- a/drivers/acpi/sleep/proc.c
+++ b/drivers/acpi/sleep/proc.c
@@ -3,6 +3,7 @@
 #include <linux/suspend.h>
 #include <linux/bcd.h>
 #include <asm/uaccess.h>
+#include <linux/pci.h>
 
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
@@ -343,7 +344,7 @@ acpi_system_wakeup_device_seq_show(struct seq_file *seq, void *offset)
 {
 	struct list_head *node, *next;
 
-	seq_printf(seq, "Device\tS-state\t  Status   Sysfs node\n");
+	seq_printf(seq, "Device\tS-state\t  Status   Sysfs node\t\tPCI ID\n");
 
 	spin_lock(&acpi_device_lock);
 	list_for_each_safe(node, next, &acpi_wakeup_device_list) {
@@ -362,9 +363,9 @@ acpi_system_wakeup_device_seq_show(struct seq_file *seq, void *offset)
 			   dev->wakeup.flags.run_wake ? '*' : ' ',
 			   dev->wakeup.state.enabled ? "enabled" : "disabled");
 		if (ldev)
-			seq_printf(seq, "%s:%s",
+			seq_printf(seq, "%s:%-12s\t0x%04x",
 				   ldev->bus ? ldev->bus->name : "no-bus",
-				   ldev->bus_id);
+				   ldev->bus_id, to_pci_dev(ldev)->device);
 		seq_printf(seq, "\n");
 		put_device(ldev);
 
@@ -380,18 +381,18 @@ acpi_system_write_wakeup_device(struct file *file,
 				size_t count, loff_t * ppos)
 {
 	struct list_head *node, *next;
-	char strbuf[5];
-	char str[5] = "";
+	char str[6] = "";
 	int len = count;
 	struct acpi_device *found_dev = NULL;
 
-	if (len > 4)
-		len = 4;
+	if (len > 5)
+		return -EINVAL;
 
-	if (copy_from_user(strbuf, buffer, len))
+	if (copy_from_user(str, buffer, len))
 		return -EFAULT;
-	strbuf[len] = '\0';
-	sscanf(strbuf, "%s", str);
+	str[len] = '\0';
+	if (str[len-1] == '\n')
+		str[len-1] = '\0';
 
 	spin_lock(&acpi_device_lock);
 	list_for_each_safe(node, next, &acpi_wakeup_device_list) {
@@ -400,7 +401,7 @@ acpi_system_write_wakeup_device(struct file *file,
 		if (!dev->wakeup.flags.valid)
 			continue;
 
-		if (!strncmp(dev->pnp.bus_id, str, 4)) {
+		if (!strnicmp(dev->pnp.bus_id, str, 4)) {
 			dev->wakeup.state.enabled =
 			    dev->wakeup.state.enabled ? 0 : 1;
 			found_dev = dev;
@@ -429,7 +430,10 @@ acpi_system_write_wakeup_device(struct file *file,
 		}
 	}
 	spin_unlock(&acpi_device_lock);
-	return count;
+	if (found_dev == NULL)
+		return -EINVAL;
+	else
+		return count;
 }
 
 static int


