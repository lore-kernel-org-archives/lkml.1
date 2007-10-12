Return-Path: <linux-kernel-owner+w=401wt.eu-S933719AbXJLWe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933719AbXJLWe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932522AbXJLWTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:19:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:53264 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422AbXJLWTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:19:50 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "tonyj@suse.de" <tonyj@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 29/75] Convert from class_device to device in drivers/char
Date: Fri, 12 Oct 2007 15:16:33 -0700
Message-Id: <1192227574129-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922275693989-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: tonyj@suse.de <tonyj@suse.de>

Convert from class_device to device in drivers/char.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/dsp56k.c            |    4 ++--
 drivers/char/ip2/ip2main.c       |   12 ++++++------
 drivers/char/ipmi/ipmi_devintf.c |    6 +++---
 drivers/char/istallion.c         |    8 +++-----
 drivers/char/lp.c                |    5 ++---
 drivers/char/pcmcia/cm4000_cs.c  |    5 ++---
 drivers/char/pcmcia/cm4040_cs.c  |    5 ++---
 drivers/char/snsc.c              |    3 +--
 drivers/char/stallion.c          |    7 +++----
 drivers/char/tipar.c             |    6 +++---
 drivers/char/viotape.c           |   10 +++++-----
 11 files changed, 32 insertions(+), 39 deletions(-)

diff --git a/drivers/char/dsp56k.c b/drivers/char/dsp56k.c
index 9b8278e..acbfe1c 100644
--- a/drivers/char/dsp56k.c
+++ b/drivers/char/dsp56k.c
@@ -513,7 +513,7 @@ static int __init dsp56k_init_driver(void)
 		err = PTR_ERR(dsp56k_class);
 		goto out_chrdev;
 	}
-	class_device_create(dsp56k_class, NULL, MKDEV(DSP56K_MAJOR, 0), NULL, "dsp56k");
+	device_create(dsp56k_class, NULL, MKDEV(DSP56K_MAJOR, 0), "dsp56k");
 
 	printk(banner);
 	goto out;
@@ -527,7 +527,7 @@ module_init(dsp56k_init_driver);
 
 static void __exit dsp56k_cleanup_driver(void)
 {
-	class_device_destroy(dsp56k_class, MKDEV(DSP56K_MAJOR, 0));
+	device_destroy(dsp56k_class, MKDEV(DSP56K_MAJOR, 0));
 	class_destroy(dsp56k_class);
 	unregister_chrdev(DSP56K_MAJOR, "dsp56k");
 }
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 8d74b87..bd94d5f 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -411,8 +411,8 @@ cleanup_module(void)
 			iiResetDelay( i2BoardPtrTable[i] );
 			/* free io addresses and Tibet */
 			release_region( ip2config.addr[i], 8 );
-			class_device_destroy(ip2_class, MKDEV(IP2_IPL_MAJOR, 4 * i));
-			class_device_destroy(ip2_class, MKDEV(IP2_IPL_MAJOR, 4 * i + 1));
+			device_destroy(ip2_class, MKDEV(IP2_IPL_MAJOR, 4 * i));
+			device_destroy(ip2_class, MKDEV(IP2_IPL_MAJOR, 4 * i + 1));
 		}
 		/* Disable and remove interrupt handler. */
 		if ( (ip2config.irq[i] > 0) && have_requested_irq(ip2config.irq[i]) ) {	
@@ -718,12 +718,12 @@ ip2_loadmain(int *iop, int *irqp, unsigned char *firmware, int firmsize)
 			}
 
 			if ( NULL != ( pB = i2BoardPtrTable[i] ) ) {
-				class_device_create(ip2_class, NULL,
+				device_create(ip2_class, NULL,
 						MKDEV(IP2_IPL_MAJOR, 4 * i),
-						NULL, "ipl%d", i);
-				class_device_create(ip2_class, NULL,
+						"ipl%d", i);
+				device_create(ip2_class, NULL,
 						MKDEV(IP2_IPL_MAJOR, 4 * i + 1),
-						NULL, "stat%d", i);
+						"stat%d", i);
 
 			    for ( box = 0; box < ABS_MAX_BOXES; ++box )
 			    {
diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index c2aa44e..0246a2b 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -865,7 +865,7 @@ static void ipmi_new_smi(int if_num, struct device *device)
 	entry->dev = dev;
 
 	mutex_lock(&reg_list_mutex);
-	class_device_create(ipmi_class, NULL, dev, device, "ipmi%d", if_num);
+	device_create(ipmi_class, device, dev, "ipmi%d", if_num);
 	list_add(&entry->link, &reg_list);
 	mutex_unlock(&reg_list_mutex);
 }
@@ -883,7 +883,7 @@ static void ipmi_smi_gone(int if_num)
 			break;
 		}
 	}
-	class_device_destroy(ipmi_class, dev);
+	device_destroy(ipmi_class, dev);
 	mutex_unlock(&reg_list_mutex);
 }
 
@@ -938,7 +938,7 @@ static __exit void cleanup_ipmi(void)
 	mutex_lock(&reg_list_mutex);
 	list_for_each_entry_safe(entry, entry2, &reg_list, link) {
 		list_del(&entry->link);
-		class_device_destroy(ipmi_class, entry->dev);
+		device_destroy(ipmi_class, entry->dev);
 		kfree(entry);
 	}
 	mutex_unlock(&reg_list_mutex);
diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 3c66f40..1f27be1 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -4624,9 +4624,8 @@ static int __init istallion_module_init(void)
 
 	istallion_class = class_create(THIS_MODULE, "staliomem");
 	for (i = 0; i < 4; i++)
-		class_device_create(istallion_class, NULL,
-				MKDEV(STL_SIOMEMMAJOR, i),
-				NULL, "staliomem%d", i);
+		device_create(istallion_class, NULL, MKDEV(STL_SIOMEMMAJOR, i),
+			      "staliomem%d", i);
 
 	return 0;
 err_deinit:
@@ -4659,8 +4658,7 @@ static void __exit istallion_module_exit(void)
 	unregister_chrdev(STL_SIOMEMMAJOR, "staliomem");
 
 	for (j = 0; j < 4; j++)
-		class_device_destroy(istallion_class, MKDEV(STL_SIOMEMMAJOR,
-					j));
+		device_destroy(istallion_class, MKDEV(STL_SIOMEMMAJOR, j));
 	class_destroy(istallion_class);
 
 	pci_unregister_driver(&stli_pcidriver);
diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index 62051f8..c59e2a0 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -799,8 +799,7 @@ static int lp_register(int nr, struct parport *port)
 	if (reset)
 		lp_reset(nr);
 
-	class_device_create(lp_class, NULL, MKDEV(LP_MAJOR, nr), port->dev,
-				"lp%d", nr);
+	device_create(lp_class, port->dev, MKDEV(LP_MAJOR, nr), "lp%d", nr);
 
 	printk(KERN_INFO "lp%d: using %s (%s).\n", nr, port->name, 
 	       (port->irq == PARPORT_IRQ_NONE)?"polling":"interrupt-driven");
@@ -971,7 +970,7 @@ static void lp_cleanup_module (void)
 		if (lp_table[offset].dev == NULL)
 			continue;
 		parport_unregister_device(lp_table[offset].dev);
-		class_device_destroy(lp_class, MKDEV(LP_MAJOR, offset));
+		device_destroy(lp_class, MKDEV(LP_MAJOR, offset));
 	}
 	class_destroy(lp_class);
 }
diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index 4177f6d..cc5d777 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -1863,8 +1863,7 @@ static int cm4000_probe(struct pcmcia_device *link)
 		return ret;
 	}
 
-	class_device_create(cmm_class, NULL, MKDEV(major, i), NULL,
-			    "cmm%d", i);
+	device_create(cmm_class, NULL, MKDEV(major, i), "cmm%d", i);
 
 	return 0;
 }
@@ -1888,7 +1887,7 @@ static void cm4000_detach(struct pcmcia_device *link)
 	dev_table[devno] = NULL;
 	kfree(dev);
 
-	class_device_destroy(cmm_class, MKDEV(major, devno));
+	device_destroy(cmm_class, MKDEV(major, devno));
 
 	return;
 }
diff --git a/drivers/char/pcmcia/cm4040_cs.c b/drivers/char/pcmcia/cm4040_cs.c
index b24a3e7..a0b9c87 100644
--- a/drivers/char/pcmcia/cm4040_cs.c
+++ b/drivers/char/pcmcia/cm4040_cs.c
@@ -642,8 +642,7 @@ static int reader_probe(struct pcmcia_device *link)
 		return ret;
 	}
 
-	class_device_create(cmx_class, NULL, MKDEV(major, i), NULL,
-			    "cmx%d", i);
+	device_create(cmx_class, NULL, MKDEV(major, i), "cmx%d", i);
 
 	return 0;
 }
@@ -666,7 +665,7 @@ static void reader_detach(struct pcmcia_device *link)
 	dev_table[devno] = NULL;
 	kfree(dev);
 
-	class_device_destroy(cmx_class, MKDEV(major, devno));
+	device_destroy(cmx_class, MKDEV(major, devno));
 
 	return;
 }
diff --git a/drivers/char/snsc.c b/drivers/char/snsc.c
index 52753e7..b9c1dba 100644
--- a/drivers/char/snsc.c
+++ b/drivers/char/snsc.c
@@ -441,8 +441,7 @@ scdrv_init(void)
 				continue;
 			}
 
-			class_device_create(snsc_class, NULL, dev, NULL,
-						"%s", devname);
+			device_create(snsc_class, NULL, dev, "%s", devname);
 
 			ia64_sn_irtr_intr_enable(scd->scd_nasid,
 						 0 /*ignored */ ,
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 4a80b2f..45758d5 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -4778,9 +4778,8 @@ static int __init stallion_module_init(void)
 	if (IS_ERR(stallion_class))
 		printk("STALLION: failed to create class\n");
 	for (i = 0; i < 4; i++)
-		class_device_create(stallion_class, NULL,
-				    MKDEV(STL_SIOMEMMAJOR, i), NULL,
-				    "staliomem%d", i);
+		device_create(stallion_class, NULL, MKDEV(STL_SIOMEMMAJOR, i),
+			      "staliomem%d", i);
 
 	return 0;
 err_unrtty:
@@ -4816,7 +4815,7 @@ static void __exit stallion_module_exit(void)
 	}
 
 	for (i = 0; i < 4; i++)
-		class_device_destroy(stallion_class, MKDEV(STL_SIOMEMMAJOR, i));
+		device_destroy(stallion_class, MKDEV(STL_SIOMEMMAJOR, i));
 	unregister_chrdev(STL_SIOMEMMAJOR, "staliomem");
 	class_destroy(stallion_class);
 
diff --git a/drivers/char/tipar.c b/drivers/char/tipar.c
index 35b40b9..cef55c4 100644
--- a/drivers/char/tipar.c
+++ b/drivers/char/tipar.c
@@ -441,8 +441,8 @@ tipar_register(int nr, struct parport *port)
 		goto out;
 	}
 
-	class_device_create(tipar_class, NULL, MKDEV(TIPAR_MAJOR,
-			TIPAR_MINOR + nr), port->dev, "par%d", nr);
+	device_create(tipar_class, port->dev, MKDEV(TIPAR_MAJOR,
+			TIPAR_MINOR + nr), "par%d", nr);
 
 	/* Display informations */
 	pr_info("tipar%d: using %s (%s)\n", nr, port->name, (port->irq ==
@@ -534,7 +534,7 @@ tipar_cleanup_module(void)
 		if (table[i].dev == NULL)
 			continue;
 		parport_unregister_device(table[i].dev);
-		class_device_destroy(tipar_class, MKDEV(TIPAR_MAJOR, i));
+		device_destroy(tipar_class, MKDEV(TIPAR_MAJOR, i));
 	}
 	class_destroy(tipar_class);
 
diff --git a/drivers/char/viotape.c b/drivers/char/viotape.c
index f1d60f0..db7a731 100644
--- a/drivers/char/viotape.c
+++ b/drivers/char/viotape.c
@@ -871,10 +871,10 @@ static int viotape_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	state[i].cur_part = 0;
 	for (j = 0; j < MAX_PARTITIONS; ++j)
 		state[i].part_stat_rwi[j] = VIOT_IDLE;
-	class_device_create(tape_class, NULL, MKDEV(VIOTAPE_MAJOR, i), NULL,
+	device_create(tape_class, NULL, MKDEV(VIOTAPE_MAJOR, i),
 			"iseries!vt%d", i);
-	class_device_create(tape_class, NULL, MKDEV(VIOTAPE_MAJOR, i | 0x80),
-			NULL, "iseries!nvt%d", i);
+	device_create(tape_class, NULL, MKDEV(VIOTAPE_MAJOR, i | 0x80),
+			"iseries!nvt%d", i);
 	printk(VIOTAPE_KERN_INFO "tape iseries/vt%d is iSeries "
 			"resource %10.10s type %4.4s, model %3.3s\n",
 			i, viotape_unitinfo[i].rsrcname,
@@ -886,8 +886,8 @@ static int viotape_remove(struct vio_dev *vdev)
 {
 	int i = vdev->unit_address;
 
-	class_device_destroy(tape_class, MKDEV(VIOTAPE_MAJOR, i | 0x80));
-	class_device_destroy(tape_class, MKDEV(VIOTAPE_MAJOR, i));
+	device_destroy(tape_class, MKDEV(VIOTAPE_MAJOR, i | 0x80));
+	device_destroy(tape_class, MKDEV(VIOTAPE_MAJOR, i));
 	return 0;
 }
 
-- 
1.5.3.4

