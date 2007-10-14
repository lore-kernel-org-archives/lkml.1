Return-Path: <linux-kernel-owner+w=401wt.eu-S1751537AbXJNShL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbXJNShL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760528AbXJNSfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:35:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47925 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761544AbXJNSfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:35:31 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] signedness: module_param_array nump argument
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1Ih8JG-000431-6z@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 14 Oct 2007 19:35:30 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


... should be unsigned int

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/char/ipmi/ipmi_si_intf.c       |   18 +++++++++---------
 drivers/eisa/eisa-bus.c                |    4 ++--
 drivers/media/video/ivtv/ivtv-driver.c |    6 +++---
 drivers/media/video/ov511.c            |    2 +-
 drivers/media/video/pwc/pwc-if.c       |    4 ++--
 drivers/mtd/nand/cafe_nand.c           |    2 +-
 drivers/pcmcia/i82365.c                |    2 +-
 drivers/pcmcia/pd6729.c                |    2 +-
 drivers/pcmcia/tcic.c                  |    2 +-
 drivers/usb/atm/speedtch.c             |    2 +-
 drivers/usb/atm/xusbatm.c              |    2 +-
 drivers/usb/serial/ti_usb_3410_5052.c  |    8 ++++----
 12 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index a2894d4..c1222e9 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1072,19 +1072,19 @@ static char          *si_type[SI_MAX_PARMS];
 #define MAX_SI_TYPE_STR 30
 static char          si_type_str[MAX_SI_TYPE_STR];
 static unsigned long addrs[SI_MAX_PARMS];
-static int num_addrs;
+static unsigned int num_addrs;
 static unsigned int  ports[SI_MAX_PARMS];
-static int num_ports;
+static unsigned int num_ports;
 static int           irqs[SI_MAX_PARMS];
-static int num_irqs;
+static unsigned int num_irqs;
 static int           regspacings[SI_MAX_PARMS];
-static int num_regspacings;
+static unsigned int num_regspacings;
 static int           regsizes[SI_MAX_PARMS];
-static int num_regsizes;
+static unsigned int num_regsizes;
 static int           regshifts[SI_MAX_PARMS];
-static int num_regshifts;
+static unsigned int num_regshifts;
 static int slave_addrs[SI_MAX_PARMS];
-static int num_slave_addrs;
+static unsigned int num_slave_addrs;
 
 #define IPMI_IO_ADDR_SPACE  0
 #define IPMI_MEM_ADDR_SPACE 1
@@ -1106,12 +1106,12 @@ MODULE_PARM_DESC(type, "Defines the type of each interface, each"
 		 " interface separated by commas.  The types are 'kcs',"
 		 " 'smic', and 'bt'.  For example si_type=kcs,bt will set"
 		 " the first interface to kcs and the second to bt");
-module_param_array(addrs, long, &num_addrs, 0);
+module_param_array(addrs, ulong, &num_addrs, 0);
 MODULE_PARM_DESC(addrs, "Sets the memory address of each interface, the"
 		 " addresses separated by commas.  Only use if an interface"
 		 " is in memory.  Otherwise, set it to zero or leave"
 		 " it blank.");
-module_param_array(ports, int, &num_ports, 0);
+module_param_array(ports, uint, &num_ports, 0);
 MODULE_PARM_DESC(ports, "Sets the port address of each interface, the"
 		 " addresses separated by commas.  Only use if an interface"
 		 " is a port.  Otherwise, set it to zero or leave"
diff --git a/drivers/eisa/eisa-bus.c b/drivers/eisa/eisa-bus.c
index 4d4a473..65dcf04 100644
--- a/drivers/eisa/eisa-bus.c
+++ b/drivers/eisa/eisa-bus.c
@@ -35,9 +35,9 @@ static struct eisa_device_info __initdata eisa_table[] = {
 #define EISA_MAX_FORCED_DEV 16
 
 static int enable_dev[EISA_MAX_FORCED_DEV];
-static int enable_dev_count;
+static unsigned int enable_dev_count;
 static int disable_dev[EISA_MAX_FORCED_DEV];
-static int disable_dev_count;
+static unsigned int disable_dev_count;
 
 static int is_forced_dev (int *forced_tab,
 			  int forced_count,
diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
index 511a662..fd7a932 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -98,9 +98,9 @@ static int radio[IVTV_MAX_CARDS] = { -1, -1, -1, -1, -1, -1, -1, -1,
 				     -1, -1, -1, -1, -1, -1, -1, -1,
 				     -1, -1, -1, -1, -1, -1, -1, -1 };
 
-static int cardtype_c = 1;
-static int tuner_c = 1;
-static int radio_c = 1;
+static unsigned int cardtype_c = 1;
+static unsigned int tuner_c = 1;
+static unsigned int radio_c = 1;
 static char pal[] = "--";
 static char secam[] = "--";
 static char ntsc[] = "-";
diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
index 9eb2562..b8d4ac0 100644
--- a/drivers/media/video/ov511.c
+++ b/drivers/media/video/ov511.c
@@ -181,7 +181,7 @@ module_param(force_palette, int, 0);
 MODULE_PARM_DESC(force_palette, "Force the palette to a specific value");
 module_param(backlight, int, 0);
 MODULE_PARM_DESC(backlight, "For objects that are lit from behind");
-static int num_uv;
+static unsigned int num_uv;
 module_param_array(unit_video, int, &num_uv, 0);
 MODULE_PARM_DESC(unit_video,
   "Force use of specific minor number(s). 0 is not allowed.");
diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index 0b67d4e..950da25 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -1903,9 +1903,9 @@ static int fbufs;
 static int mbufs;
 static int compression = -1;
 static int leds[2] = { -1, -1 };
-static int leds_nargs;
+static unsigned int leds_nargs;
 static char *dev_hint[MAX_DEV_HINTS];
-static int dev_hint_nargs;
+static unsigned int dev_hint_nargs;
 
 module_param(size, charp, 0444);
 module_param(fps, int, 0444);
diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index e2832d0..1e81171 100644
--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -80,7 +80,7 @@ module_param(regdebug, int, 0644);
 static int checkecc = 1;
 module_param(checkecc, int, 0644);
 
-static int numtimings;
+static unsigned int numtimings;
 static int timing[3];
 module_param_array(timing, int, &numtimings, 0644);
 
diff --git a/drivers/pcmcia/i82365.c b/drivers/pcmcia/i82365.c
index 71b3370..839bb1c 100644
--- a/drivers/pcmcia/i82365.c
+++ b/drivers/pcmcia/i82365.c
@@ -101,7 +101,7 @@ static int ignore = -1;
 /* Bit map or list of interrupts to choose from */
 static u_int irq_mask = 0xffff;
 static int irq_list[16];
-static int irq_list_count;
+static unsigned int irq_list_count;
 /* The card status change interrupt -- 0 means autoselect */
 static int cs_irq = 0;
 
diff --git a/drivers/pcmcia/pd6729.c b/drivers/pcmcia/pd6729.c
index dd0ddf1..abc10fe 100644
--- a/drivers/pcmcia/pd6729.c
+++ b/drivers/pcmcia/pd6729.c
@@ -58,7 +58,7 @@ MODULE_AUTHOR("Jun Komuro <komurojun-mbn@nifty.com>");
 
 static int irq_mode = 1; /* 0 = ISA interrupt, 1 = PCI interrupt */
 static int irq_list[16];
-static int irq_list_count = 0;
+static unsigned int irq_list_count = 0;
 
 module_param(irq_mode, int, 0444);
 module_param_array(irq_list, int, &irq_list_count, 0444);
diff --git a/drivers/pcmcia/tcic.c b/drivers/pcmcia/tcic.c
index c158cf3..749ac37 100644
--- a/drivers/pcmcia/tcic.c
+++ b/drivers/pcmcia/tcic.c
@@ -90,7 +90,7 @@ static int do_scan = 1;
 /* Bit map of interrupts to choose from */
 static u_int irq_mask = 0xffff;
 static int irq_list[16];
-static int irq_list_count;
+static unsigned int irq_list_count;
 
 /* The card status change interrupt -- 0 means autoselect */
 static int cs_irq;
diff --git a/drivers/usb/atm/speedtch.c b/drivers/usb/atm/speedtch.c
index 8b132c4..7d27c9c 100644
--- a/drivers/usb/atm/speedtch.c
+++ b/drivers/usb/atm/speedtch.c
@@ -88,7 +88,7 @@ static const unsigned char DEFAULT_MODEM_OPTION[MODEM_OPTION_LENGTH] = {
 static unsigned int BMaxDSL = DEFAULT_B_MAX_DSL;
 static unsigned char ModemMode = DEFAULT_MODEM_MODE;
 static unsigned char ModemOption[MODEM_OPTION_LENGTH];
-static int num_ModemOption;
+static unsigned int num_ModemOption;
 
 module_param(altsetting, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(altsetting,
diff --git a/drivers/usb/atm/xusbatm.c b/drivers/usb/atm/xusbatm.c
index 70125c6..8472543 100644
--- a/drivers/usb/atm/xusbatm.c
+++ b/drivers/usb/atm/xusbatm.c
@@ -29,7 +29,7 @@
 
 #define XUSBATM_PARM(name, type, parmtype, desc) \
 	static type name[XUSBATM_DRIVERS_MAX]; \
-	static int num_##name; \
+	static unsigned int num_##name; \
 	module_param_array(name, parmtype, &num_##name, 0444); \
 	MODULE_PARM_DESC(name, desc)
 
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index f98626a..1f01494 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -214,13 +214,13 @@ static int debug;
 static int low_latency = TI_DEFAULT_LOW_LATENCY;
 static int closing_wait = TI_DEFAULT_CLOSING_WAIT;
 static ushort vendor_3410[TI_EXTRA_VID_PID_COUNT];
-static int vendor_3410_count;
+static unsigned int vendor_3410_count;
 static ushort product_3410[TI_EXTRA_VID_PID_COUNT];
-static int product_3410_count;
+static unsigned int product_3410_count;
 static ushort vendor_5052[TI_EXTRA_VID_PID_COUNT];
-static int vendor_5052_count;
+static unsigned int vendor_5052_count;
 static ushort product_5052[TI_EXTRA_VID_PID_COUNT];
-static int product_5052_count;
+static unsigned int product_5052_count;
 
 /* supported devices */
 /* the array dimension is the number of default entries plus */
-- 
1.5.3.GIT


