Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbYCFCbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbYCFCbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932344AbYCFCZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:25:11 -0500
Received: from gv-out-0910.google.com ([216.239.58.187]:26847 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764884AbYCFCZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:25:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BFKJME7c/vQ7WBgv5VIACCukwTDi3qvoaRHImTtPV/lceyiYHcFLCMGGm+DQnzuGIp9oLVRWHqVaIvhVydzm7bSfHxCRDpQxzi5J/v0ENX639Y/+FbU9qFgqbflsRr1/fNwJjCJ9S/D7X2O1r4sCAnw6U5hGokt9+ayfnRyx7eg=
Subject: [PATCH 11/16] drivers/misc: replace remaining __FUNCTION__
	occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 18:24:56 -0800
Message-Id: <1204770297.14154.47.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/misc/ibmasm/command.c   |    6 +++---
 drivers/misc/ibmasm/heartbeat.c |    6 +++---
 drivers/misc/ioc4.c             |   20 ++++++++++----------
 drivers/misc/sony-laptop.c      |    4 ++--
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/misc/ibmasm/command.c b/drivers/misc/ibmasm/command.c
index 1a0e797..276d3fb 100644
--- a/drivers/misc/ibmasm/command.c
+++ b/drivers/misc/ibmasm/command.c
@@ -96,7 +96,7 @@ static inline void do_exec_command(struct service_processor *sp)
 {
 	char tsbuf[32];
 
-	dbg("%s:%d at %s\n", __FUNCTION__, __LINE__, get_timestamp(tsbuf));
+	dbg("%s:%d at %s\n", __func__, __LINE__, get_timestamp(tsbuf));
 
 	if (ibmasm_send_i2o_message(sp)) {
 		sp->current_command->status = IBMASM_CMD_FAILED;
@@ -119,7 +119,7 @@ void ibmasm_exec_command(struct service_processor *sp, struct command *cmd)
 	unsigned long flags;
 	char tsbuf[32];
 
-	dbg("%s:%d at %s\n", __FUNCTION__, __LINE__, get_timestamp(tsbuf));
+	dbg("%s:%d at %s\n", __func__, __LINE__, get_timestamp(tsbuf));
 
 	spin_lock_irqsave(&sp->lock, flags);
 
@@ -139,7 +139,7 @@ static void exec_next_command(struct service_processor *sp)
 	unsigned long flags;
 	char tsbuf[32];
 
-	dbg("%s:%d at %s\n", __FUNCTION__, __LINE__, get_timestamp(tsbuf));
+	dbg("%s:%d at %s\n", __func__, __LINE__, get_timestamp(tsbuf));
 
 	spin_lock_irqsave(&sp->lock, flags);
 	sp->current_command = dequeue_command(sp);
diff --git a/drivers/misc/ibmasm/heartbeat.c b/drivers/misc/ibmasm/heartbeat.c
index 3036e78..1bc4306 100644
--- a/drivers/misc/ibmasm/heartbeat.c
+++ b/drivers/misc/ibmasm/heartbeat.c
@@ -75,9 +75,9 @@ void ibmasm_heartbeat_exit(struct service_processor *sp)
 {
 	char tsbuf[32];
 
-	dbg("%s:%d at %s\n", __FUNCTION__, __LINE__, get_timestamp(tsbuf));
+	dbg("%s:%d at %s\n", __func__, __LINE__, get_timestamp(tsbuf));
 	ibmasm_wait_for_response(sp->heartbeat, IBMASM_CMD_TIMEOUT_NORMAL);
-	dbg("%s:%d at %s\n", __FUNCTION__, __LINE__, get_timestamp(tsbuf));
+	dbg("%s:%d at %s\n", __func__, __LINE__, get_timestamp(tsbuf));
 	suspend_heartbeats = 1;
 	command_put(sp->heartbeat);
 }
@@ -88,7 +88,7 @@ void ibmasm_receive_heartbeat(struct service_processor *sp,  void *message, size
 	struct dot_command_header *header = (struct dot_command_header *)cmd->buffer;
 	char tsbuf[32];
 
-	dbg("%s:%d at %s\n", __FUNCTION__, __LINE__, get_timestamp(tsbuf));
+	dbg("%s:%d at %s\n", __func__, __LINE__, get_timestamp(tsbuf));
 	if (suspend_heartbeats)
 		return;
 
diff --git a/drivers/misc/ioc4.c b/drivers/misc/ioc4.c
index 05172d2..6f76573 100644
--- a/drivers/misc/ioc4.c
+++ b/drivers/misc/ioc4.c
@@ -75,7 +75,7 @@ ioc4_register_submodule(struct ioc4_submodule *is)
 			printk(KERN_WARNING
 			       "%s: IOC4 submodule %s probe failed "
 			       "for pci_dev %s",
-			       __FUNCTION__, module_name(is->is_owner),
+			       __func__, module_name(is->is_owner),
 			       pci_name(idd->idd_pdev));
 		}
 	}
@@ -102,7 +102,7 @@ ioc4_unregister_submodule(struct ioc4_submodule *is)
 			printk(KERN_WARNING
 			       "%s: IOC4 submodule %s remove failed "
 			       "for pci_dev %s.\n",
-			       __FUNCTION__, module_name(is->is_owner),
+			       __func__, module_name(is->is_owner),
 			       pci_name(idd->idd_pdev));
 		}
 	}
@@ -282,7 +282,7 @@ ioc4_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 	if ((ret = pci_enable_device(pdev))) {
 		printk(KERN_WARNING
 		       "%s: Failed to enable IOC4 device for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(pdev));
+		       __func__, pci_name(pdev));
 		goto out;
 	}
 	pci_set_master(pdev);
@@ -292,7 +292,7 @@ ioc4_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 	if (!idd) {
 		printk(KERN_WARNING
 		       "%s: Failed to allocate IOC4 data for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(pdev));
+		       __func__, pci_name(pdev));
 		ret = -ENODEV;
 		goto out_idd;
 	}
@@ -307,7 +307,7 @@ ioc4_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 		printk(KERN_WARNING
 		       "%s: Unable to find IOC4 misc resource "
 		       "for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(idd->idd_pdev));
+		       __func__, pci_name(idd->idd_pdev));
 		ret = -ENODEV;
 		goto out_pci;
 	}
@@ -316,7 +316,7 @@ ioc4_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 		printk(KERN_WARNING
 		       "%s: Unable to request IOC4 misc region "
 		       "for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(idd->idd_pdev));
+		       __func__, pci_name(idd->idd_pdev));
 		ret = -ENODEV;
 		goto out_pci;
 	}
@@ -326,7 +326,7 @@ ioc4_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 		printk(KERN_WARNING
 		       "%s: Unable to remap IOC4 misc region "
 		       "for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(idd->idd_pdev));
+		       __func__, pci_name(idd->idd_pdev));
 		ret = -ENODEV;
 		goto out_misc_region;
 	}
@@ -372,7 +372,7 @@ ioc4_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 			printk(KERN_WARNING
 			       "%s: IOC4 submodule 0x%s probe failed "
 			       "for pci_dev %s.\n",
-			       __FUNCTION__, module_name(is->is_owner),
+			       __func__, module_name(is->is_owner),
 			       pci_name(idd->idd_pdev));
 		}
 	}
@@ -406,7 +406,7 @@ ioc4_remove(struct pci_dev *pdev)
 			printk(KERN_WARNING
 			       "%s: IOC4 submodule 0x%s remove failed "
 			       "for pci_dev %s.\n",
-			       __FUNCTION__, module_name(is->is_owner),
+			       __func__, module_name(is->is_owner),
 			       pci_name(idd->idd_pdev));
 		}
 	}
@@ -418,7 +418,7 @@ ioc4_remove(struct pci_dev *pdev)
 		printk(KERN_WARNING
 		       "%s: Unable to get IOC4 misc mapping for pci_dev %s. "
 		       "Device removal may be incomplete.\n",
-		       __FUNCTION__, pci_name(idd->idd_pdev));
+		       __func__, pci_name(idd->idd_pdev));
 	}
 	release_mem_region(idd->idd_bar0, sizeof(struct ioc4_misc_regs));
 
diff --git a/drivers/misc/sony-laptop.c b/drivers/misc/sony-laptop.c
index 899e3f7..bee6c34 100644
--- a/drivers/misc/sony-laptop.c
+++ b/drivers/misc/sony-laptop.c
@@ -961,7 +961,7 @@ static int sony_nc_resume(struct acpi_device *device)
 		ret = acpi_callsetfunc(sony_nc_acpi_handle, *item->acpiset,
 				       item->value, NULL);
 		if (ret < 0) {
-			printk("%s: %d\n", __FUNCTION__, ret);
+			printk("%s: %d\n", __func__, ret);
 			break;
 		}
 	}
@@ -1453,7 +1453,7 @@ static struct sonypi_eventtypes type4_events[] = {
 		udelay(1);						\
 	if (!n)								\
 		dprintk("command failed at %s : %s (line %d)\n",	\
-				__FILE__, __FUNCTION__, __LINE__);	\
+				__FILE__, __func__, __LINE__);	\
 }
 
 static u8 sony_pic_call1(u8 dev)
-- 
1.5.4.GIT


