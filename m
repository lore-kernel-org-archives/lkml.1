Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbYJPRRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbYJPRRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756095AbYJPROI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:08 -0400
Received: from kroah.org ([198.145.64.141]:46923 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756046AbYJPROG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:06 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/46] device create: char: convert device_create_drvdata to device_create
Date: Thu, 16 Oct 2008 10:10:05 -0700
Message-Id: <1224177047-11859-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that device_create() has been audited, rename things back to the
original call to be sane.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/bsr.c                         |    5 ++---
 drivers/char/dsp56k.c                      |    4 ++--
 drivers/char/ip2/ip2main.c                 |   12 ++++++------
 drivers/char/ipmi/ipmi_devintf.c           |    2 +-
 drivers/char/istallion.c                   |    5 ++---
 drivers/char/lp.c                          |    4 ++--
 drivers/char/mem.c                         |    6 +++---
 drivers/char/misc.c                        |    4 ++--
 drivers/char/pcmcia/cm4000_cs.c            |    2 +-
 drivers/char/pcmcia/cm4040_cs.c            |    3 +--
 drivers/char/ppdev.c                       |    5 ++---
 drivers/char/raw.c                         |    7 +++----
 drivers/char/snsc.c                        |    4 ++--
 drivers/char/stallion.c                    |    4 ++--
 drivers/char/tty_io.c                      |    2 +-
 drivers/char/vc_screen.c                   |   12 ++++++------
 drivers/char/viotape.c                     |    8 ++++----
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |    3 +--
 18 files changed, 43 insertions(+), 49 deletions(-)

diff --git a/drivers/char/bsr.c b/drivers/char/bsr.c
index b650b4e..456f54d 100644
--- a/drivers/char/bsr.c
+++ b/drivers/char/bsr.c
@@ -229,9 +229,8 @@ static int bsr_create_devs(struct device_node *bn)
 		if (result)
 			goto out_err;
 
-		cur->bsr_device = device_create_drvdata(bsr_class, NULL,
-							cur->bsr_dev,
-							cur, cur->bsr_name);
+		cur->bsr_device = device_create(bsr_class, NULL, cur->bsr_dev,
+						cur, cur->bsr_name);
 		if (!cur->bsr_device) {
 			printk(KERN_ERR "device_create failed for %s\n",
 			       cur->bsr_name);
diff --git a/drivers/char/dsp56k.c b/drivers/char/dsp56k.c
index ca7c72a..85832ab 100644
--- a/drivers/char/dsp56k.c
+++ b/drivers/char/dsp56k.c
@@ -508,8 +508,8 @@ static int __init dsp56k_init_driver(void)
 		err = PTR_ERR(dsp56k_class);
 		goto out_chrdev;
 	}
-	device_create_drvdata(dsp56k_class, NULL, MKDEV(DSP56K_MAJOR, 0),
-			      NULL, "dsp56k");
+	device_create(dsp56k_class, NULL, MKDEV(DSP56K_MAJOR, 0), NULL,
+		      "dsp56k");
 
 	printk(banner);
 	goto out;
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 6774572..70e0ebc 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -745,12 +745,12 @@ static int __init ip2_loadmain(void)
 
 		pB = i2BoardPtrTable[i];
 		if (pB != NULL) {
-			device_create_drvdata(ip2_class, NULL,
-					      MKDEV(IP2_IPL_MAJOR, 4 * i),
-					      NULL, "ipl%d", i);
-			device_create_drvdata(ip2_class, NULL,
-					      MKDEV(IP2_IPL_MAJOR, 4 * i + 1),
-					      NULL, "stat%d", i);
+			device_create(ip2_class, NULL,
+				      MKDEV(IP2_IPL_MAJOR, 4 * i),
+				      NULL, "ipl%d", i);
+			device_create(ip2_class, NULL,
+				      MKDEV(IP2_IPL_MAJOR, 4 * i + 1),
+				      NULL, "stat%d", i);
 
 			for (box = 0; box < ABS_MAX_BOXES; box++)
 				for (j = 0; j < ABS_BIGGEST_BOX; j++)
diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index 64e1c16..835a33c 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -871,7 +871,7 @@ static void ipmi_new_smi(int if_num, struct device *device)
 	entry->dev = dev;
 
 	mutex_lock(&reg_list_mutex);
-	device_create_drvdata(ipmi_class, device, dev, NULL, "ipmi%d", if_num);
+	device_create(ipmi_class, device, dev, NULL, "ipmi%d", if_num);
 	list_add(&entry->link, &reg_list);
 	mutex_unlock(&reg_list_mutex);
 }
diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 505d7a1..44e5d60 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -4600,9 +4600,8 @@ static int __init istallion_module_init(void)
 
 	istallion_class = class_create(THIS_MODULE, "staliomem");
 	for (i = 0; i < 4; i++)
-		device_create_drvdata(istallion_class, NULL,
-				      MKDEV(STL_SIOMEMMAJOR, i),
-				      NULL, "staliomem%d", i);
+		device_create(istallion_class, NULL, MKDEV(STL_SIOMEMMAJOR, i),
+			      NULL, "staliomem%d", i);
 
 	return 0;
 err_deinit:
diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index 3f2719b..e444c2d 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -813,8 +813,8 @@ static int lp_register(int nr, struct parport *port)
 	if (reset)
 		lp_reset(nr);
 
-	device_create_drvdata(lp_class, port->dev, MKDEV(LP_MAJOR, nr), NULL,
-			      "lp%d", nr);
+	device_create(lp_class, port->dev, MKDEV(LP_MAJOR, nr), NULL,
+		      "lp%d", nr);
 
 	printk(KERN_INFO "lp%d: using %s (%s).\n", nr, port->name, 
 	       (port->irq == PARPORT_IRQ_NONE)?"polling":"interrupt-driven");
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 672b08e..6431f69 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -992,9 +992,9 @@ static int __init chr_dev_init(void)
 
 	mem_class = class_create(THIS_MODULE, "mem");
 	for (i = 0; i < ARRAY_SIZE(devlist); i++)
-		device_create_drvdata(mem_class, NULL,
-				      MKDEV(MEM_MAJOR, devlist[i].minor),
-				      NULL, devlist[i].name);
+		device_create(mem_class, NULL,
+			      MKDEV(MEM_MAJOR, devlist[i].minor), NULL,
+			      devlist[i].name);
 
 	return 0;
 }
diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 999aa77..a5e0db9 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -217,8 +217,8 @@ int misc_register(struct miscdevice * misc)
 		misc_minors[misc->minor >> 3] |= 1 << (misc->minor & 7);
 	dev = MKDEV(MISC_MAJOR, misc->minor);
 
-	misc->this_device = device_create_drvdata(misc_class, misc->parent,
-						  dev, NULL, "%s", misc->name);
+	misc->this_device = device_create(misc_class, misc->parent, dev, NULL,
+					  "%s", misc->name);
 	if (IS_ERR(misc->this_device)) {
 		err = PTR_ERR(misc->this_device);
 		goto out;
diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index 1c5bf99..dbb9125 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -1871,7 +1871,7 @@ static int cm4000_probe(struct pcmcia_device *link)
 		return ret;
 	}
 
-	device_create_drvdata(cmm_class, NULL, MKDEV(major, i), NULL, "cmm%d", i);
+	device_create(cmm_class, NULL, MKDEV(major, i), NULL, "cmm%d", i);
 
 	return 0;
 }
diff --git a/drivers/char/pcmcia/cm4040_cs.c b/drivers/char/pcmcia/cm4040_cs.c
index 2d7c906..4f0723b 100644
--- a/drivers/char/pcmcia/cm4040_cs.c
+++ b/drivers/char/pcmcia/cm4040_cs.c
@@ -637,8 +637,7 @@ static int reader_probe(struct pcmcia_device *link)
 		return ret;
 	}
 
-	device_create_drvdata(cmx_class, NULL, MKDEV(major, i), NULL,
-			      "cmx%d", i);
+	device_create(cmx_class, NULL, MKDEV(major, i), NULL, "cmx%d", i);
 
 	return 0;
 }
diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
index bee39fd..c84c34f 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -760,9 +760,8 @@ static const struct file_operations pp_fops = {
 
 static void pp_attach(struct parport *port)
 {
-	device_create_drvdata(ppdev_class, port->dev,
-			      MKDEV(PP_MAJOR, port->number),
-			      NULL, "parport%d", port->number);
+	device_create(ppdev_class, port->dev, MKDEV(PP_MAJOR, port->number),
+		      NULL, "parport%d", port->number);
 }
 
 static void pp_detach(struct parport *port)
diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index 47b8cf2..e139372 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -131,8 +131,8 @@ raw_ioctl(struct inode *inode, struct file *filp,
 static void bind_device(struct raw_config_request *rq)
 {
 	device_destroy(raw_class, MKDEV(RAW_MAJOR, rq->raw_minor));
-	device_create_drvdata(raw_class, NULL, MKDEV(RAW_MAJOR, rq->raw_minor),
-			      NULL, "raw%d", rq->raw_minor);
+	device_create(raw_class, NULL, MKDEV(RAW_MAJOR, rq->raw_minor), NULL,
+		      "raw%d", rq->raw_minor);
 }
 
 /*
@@ -283,8 +283,7 @@ static int __init raw_init(void)
 		ret = PTR_ERR(raw_class);
 		goto error_region;
 	}
-	device_create_drvdata(raw_class, NULL, MKDEV(RAW_MAJOR, 0), NULL,
-			      "rawctl");
+	device_create(raw_class, NULL, MKDEV(RAW_MAJOR, 0), NULL, "rawctl");
 
 	return 0;
 
diff --git a/drivers/char/snsc.c b/drivers/char/snsc.c
index 3ce60df..32b74de 100644
--- a/drivers/char/snsc.c
+++ b/drivers/char/snsc.c
@@ -444,8 +444,8 @@ scdrv_init(void)
 				continue;
 			}
 
-			device_create_drvdata(snsc_class, NULL, dev, NULL,
-					      "%s", devname);
+			device_create(snsc_class, NULL, dev, NULL,
+				      "%s", devname);
 
 			ia64_sn_irtr_intr_enable(scd->scd_nasid,
 						 0 /*ignored */ ,
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 8b8f07a..963b03f 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -4743,8 +4743,8 @@ static int __init stallion_module_init(void)
 	if (IS_ERR(stallion_class))
 		printk("STALLION: failed to create class\n");
 	for (i = 0; i < 4; i++)
-		device_create_drvdata(stallion_class, NULL, MKDEV(STL_SIOMEMMAJOR, i),
-				      NULL, "staliomem%d", i);
+		device_create(stallion_class, NULL, MKDEV(STL_SIOMEMMAJOR, i),
+			      NULL, "staliomem%d", i);
 
 	return 0;
 err_unrtty:
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 3f48d88..59f4721 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2850,7 +2850,7 @@ struct device *tty_register_device(struct tty_driver *driver, unsigned index,
 	else
 		tty_line_name(driver, index, name);
 
-	return device_create_drvdata(tty_class, device, dev, NULL, name);
+	return device_create(tty_class, device, dev, NULL, name);
 }
 EXPORT_SYMBOL(tty_register_device);
 
diff --git a/drivers/char/vc_screen.c b/drivers/char/vc_screen.c
index c2ae52d..4f3b3f9 100644
--- a/drivers/char/vc_screen.c
+++ b/drivers/char/vc_screen.c
@@ -481,10 +481,10 @@ static struct class *vc_class;
 
 void vcs_make_sysfs(struct tty_struct *tty)
 {
-	device_create_drvdata(vc_class, NULL, MKDEV(VCS_MAJOR, tty->index + 1),
-			      NULL, "vcs%u", tty->index + 1);
-	device_create_drvdata(vc_class, NULL, MKDEV(VCS_MAJOR, tty->index + 129),
-			      NULL, "vcsa%u", tty->index + 1);
+	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, tty->index + 1), NULL,
+		      "vcs%u", tty->index + 1);
+	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, tty->index + 129), NULL,
+		      "vcsa%u", tty->index + 1);
 }
 
 void vcs_remove_sysfs(struct tty_struct *tty)
@@ -499,7 +499,7 @@ int __init vcs_init(void)
 		panic("unable to get major %d for vcs device", VCS_MAJOR);
 	vc_class = class_create(THIS_MODULE, "vc");
 
-	device_create_drvdata(vc_class, NULL, MKDEV(VCS_MAJOR, 0), NULL, "vcs");
-	device_create_drvdata(vc_class, NULL, MKDEV(VCS_MAJOR, 128), NULL, "vcsa");
+	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, 0), NULL, "vcs");
+	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, 128), NULL, "vcsa");
 	return 0;
 }
diff --git a/drivers/char/viotape.c b/drivers/char/viotape.c
index 7a70a40..ffc9254 100644
--- a/drivers/char/viotape.c
+++ b/drivers/char/viotape.c
@@ -886,10 +886,10 @@ static int viotape_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	state[i].cur_part = 0;
 	for (j = 0; j < MAX_PARTITIONS; ++j)
 		state[i].part_stat_rwi[j] = VIOT_IDLE;
-	device_create_drvdata(tape_class, NULL, MKDEV(VIOTAPE_MAJOR, i),
-			      NULL, "iseries!vt%d", i);
-	device_create_drvdata(tape_class, NULL, MKDEV(VIOTAPE_MAJOR, i | 0x80),
-			      NULL, "iseries!nvt%d", i);
+	device_create(tape_class, NULL, MKDEV(VIOTAPE_MAJOR, i), NULL,
+		      "iseries!vt%d", i);
+	device_create(tape_class, NULL, MKDEV(VIOTAPE_MAJOR, i | 0x80), NULL,
+		      "iseries!nvt%d", i);
 	printk(VIOTAPE_KERN_INFO "tape iseries/vt%d is iSeries "
 			"resource %10.10s type %4.4s, model %3.3s\n",
 			i, viotape_unitinfo[i].rsrcname,
diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index 278c985..ed132fe 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -657,8 +657,7 @@ static int __devinit hwicap_setup(struct device *dev, int id,
 		goto failed3;
 	}
 
-	device_create_drvdata(icap_class, dev, devt, NULL,
-			      "%s%d", DRIVER_NAME, id);
+	device_create(icap_class, dev, devt, NULL, "%s%d", DRIVER_NAME, id);
 	return 0;		/* success */
 
  failed3:
-- 
1.6.0.2

