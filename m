Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbZDOGbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbZDOGbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757038AbZDOG3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:29:08 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:49603 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218AbZDOG3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:29:04 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       David Schleef <ds@schleef.org>
Subject: [PATCH resend 1/8] staging: comedi, remove interrupt.h
Date: Wed, 15 Apr 2009 08:28:40 +0200
Message-Id: <1239776927-16168-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove interrupt wraparound. Use defines from linux/interrupt.h
instead.

Change also parameter types of functions taking ISR to irq_handler_t.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: David Schleef <ds@schleef.org>
---
 drivers/staging/comedi/comedi_rt.h                 |    5 +-
 drivers/staging/comedi/comedidev.h                 |    1 -
 .../staging/comedi/drivers/addi-data/addi_common.c |    4 +-
 .../staging/comedi/drivers/addi-data/addi_common.h |    2 +-
 drivers/staging/comedi/drivers/adl_pci9111.c       |    3 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |    3 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |    4 +-
 drivers/staging/comedi/drivers/amplc_dio200.c      |    4 +-
 drivers/staging/comedi/drivers/amplc_pc236.c       |    6 ++-
 drivers/staging/comedi/drivers/amplc_pci224.c      |    4 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |    6 ++-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |    4 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |    5 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       |    5 +-
 drivers/staging/comedi/drivers/comedi_parport.c    |    3 +-
 drivers/staging/comedi/drivers/das16.c             |    4 +-
 drivers/staging/comedi/drivers/das16m1.c           |    4 +-
 drivers/staging/comedi/drivers/das1800.c           |    4 +-
 drivers/staging/comedi/drivers/das6402.c           |    2 +-
 drivers/staging/comedi/drivers/das800.c            |    4 +-
 drivers/staging/comedi/drivers/dmm32at.c           |    4 +-
 drivers/staging/comedi/drivers/dt2811.c            |    2 +-
 drivers/staging/comedi/drivers/dt2814.c            |    4 +-
 drivers/staging/comedi/drivers/dt282x.c            |    2 +-
 drivers/staging/comedi/drivers/dt3000.c            |    2 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c          |    4 +-
 drivers/staging/comedi/drivers/icp_multi.c         |    2 +-
 drivers/staging/comedi/drivers/me4000.c            |    4 +-
 drivers/staging/comedi/drivers/ni_6527.c           |    2 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |    2 +-
 drivers/staging/comedi/drivers/ni_660x.c           |    2 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c       |    4 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |    4 +-
 drivers/staging/comedi/drivers/ni_labpc.c          |    4 +-
 drivers/staging/comedi/drivers/ni_mio_common.c     |    2 +-
 drivers/staging/comedi/drivers/ni_pcidio.c         |    2 +-
 drivers/staging/comedi/drivers/pcl711.c            |    2 +-
 drivers/staging/comedi/drivers/pcl812.c            |    2 +-
 drivers/staging/comedi/drivers/pcl816.c            |    2 +-
 drivers/staging/comedi/drivers/pcl818.c            |    2 +-
 drivers/staging/comedi/drivers/pcmmio.c            |    4 +-
 drivers/staging/comedi/drivers/pcmuio.c            |    4 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |    2 +-
 drivers/staging/comedi/drivers/rtd520.c            |    5 +-
 drivers/staging/comedi/drivers/rti800.c            |    4 +-
 drivers/staging/comedi/drivers/s626.c              |    4 +-
 drivers/staging/comedi/drivers/usbduxfast.c        |    2 +-
 drivers/staging/comedi/interrupt.h                 |   51 --------------------
 drivers/staging/comedi/rt.c                        |   16 +++---
 drivers/staging/comedi/rt_pend_tq.c                |    2 +-
 50 files changed, 94 insertions(+), 131 deletions(-)
 delete mode 100644 drivers/staging/comedi/interrupt.h

diff --git a/drivers/staging/comedi/comedi_rt.h b/drivers/staging/comedi/comedi_rt.h
index 169ca96..cddd540 100644
--- a/drivers/staging/comedi/comedi_rt.h
+++ b/drivers/staging/comedi/comedi_rt.h
@@ -33,6 +33,7 @@
 #include <linux/errno.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
+#include <linux/interrupt.h>
 
 #ifdef CONFIG_COMEDI_RT
 
@@ -56,8 +57,8 @@
 #define rt_printk printk
 #endif
 
-int comedi_request_irq(unsigned int irq, irqreturn_t(*handler) (int,
-		void *PT_REGS_ARG), unsigned long flags, const char *device,
+int comedi_request_irq(unsigned int irq, irq_handler_t handler,
+		unsigned long flags, const char *device,
 		struct comedi_device *dev_id);
 void comedi_free_irq(unsigned int irq, struct comedi_device *dev_id);
 void comedi_rt_init(void);
diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index ea31936..414a2cf 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -35,7 +35,6 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/vmalloc.h>
-#include "interrupt.h"
 #include <linux/dma-mapping.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.c b/drivers/staging/comedi/drivers/addi-data/addi_common.c
index 618c69b..9c55fd0 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.c
@@ -3003,7 +3003,7 @@ static int i_ADDI_Reset(struct comedi_device * dev)
 /*
 +----------------------------------------------------------------------------+
 | Function name     :                                                        |
-|static void v_ADDI_Interrupt(int irq, void *d  PT_REGS_ARG)                 |
+|static void v_ADDI_Interrupt(int irq, void *d)                 |
 |                                        									 |
 +----------------------------------------------------------------------------+
 | Task              : Registerd interrupt routine						     |
@@ -3018,7 +3018,7 @@ static int i_ADDI_Reset(struct comedi_device * dev)
 +----------------------------------------------------------------------------+
 */
 
-static irqreturn_t v_ADDI_Interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t v_ADDI_Interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	this_board->v_hwdrv_Interrupt(irq, d);
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.h b/drivers/staging/comedi/drivers/addi-data/addi_common.h
index 19df5c1..2c359c1 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.h
@@ -457,6 +457,6 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 static int i_ADDI_Detach(struct comedi_device *dev);
 static int i_ADDI_Reset(struct comedi_device *dev);
 
-static irqreturn_t v_ADDI_Interrupt(int irq, void *d PT_REGS_ARG);
+static irqreturn_t v_ADDI_Interrupt(int irq, void *d);
 static int i_ADDIDATA_InsnReadEeprom(struct comedi_device *dev, struct comedi_subdevice *s,
 				     struct comedi_insn *insn, unsigned int *data);
diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index b4a61c5..28b6b8d 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -77,6 +77,7 @@ TODO:
 #include "../comedidev.h"
 
 #include <linux/delay.h>
+#include <linux/interrupt.h>
 
 #include "8253.h"
 #include "comedi_pci.h"
@@ -884,7 +885,7 @@ static void pci9111_ai_munge(struct comedi_device * dev, struct comedi_subdevice
 
 #undef INTERRUPT_DEBUG
 
-static irqreturn_t pci9111_interrupt(int irq, void *p_device PT_REGS_ARG)
+static irqreturn_t pci9111_interrupt(int irq, void *p_device)
 {
 	struct comedi_device *dev = p_device;
 	struct comedi_subdevice *subdevice = dev->read_subdev;
diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 278cf30..d438dd6 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -66,6 +66,7 @@ Configuration options:
 #include "../pci_ids.h"
 
 #include <linux/delay.h>
+#include <linux/interrupt.h>
 
 #include "amcc_s5933.h"
 #include "8253.h"
@@ -674,7 +675,7 @@ static void interrupt_pci9118_ai_dma(struct comedi_device * dev, struct comedi_s
 /*
 ==============================================================================
 */
-static irqreturn_t interrupt_pci9118(int irq, void *d PT_REGS_ARG)
+static irqreturn_t interrupt_pci9118(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	unsigned int int_daq = 0, int_amcc, int_adstat;
diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 29eac74..1e4a556 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -41,6 +41,8 @@ Configuration options:
           device will be used.
 */
 
+#include <linux/interrupt.h>
+
 #include "../comedidev.h"
 
 #include "comedi_pci.h"
@@ -760,7 +762,7 @@ static void interrupt_pci1710_half_fifo(void *d)
 /*
 ==============================================================================
 */
-static irqreturn_t interrupt_service_pci1710(int irq, void *d PT_REGS_ARG)
+static irqreturn_t interrupt_service_pci1710(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 
diff --git a/drivers/staging/comedi/drivers/amplc_dio200.c b/drivers/staging/comedi/drivers/amplc_dio200.c
index 8555e27..771e88c 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200.c
@@ -205,6 +205,8 @@ is packed into a short value, one bit per requested channel, in the
 order they appear in the channel list.
 */
 
+#include <linux/interrupt.h>
+
 #include "../comedidev.h"
 
 #include "comedi_pci.h"
@@ -1010,7 +1012,7 @@ dio200_subdev_intr_cleanup(struct comedi_device * dev, struct comedi_subdevice *
 /*
  * Interrupt service routine.
  */
-static irqreturn_t dio200_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t dio200_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	int handled;
diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 2027c75..2945003 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -52,6 +52,8 @@ the IRQ jumper.  If no interrupt is connected, then subdevice 1 is
 unused.
 */
 
+#include <linux/interrupt.h>
+
 #include "../comedidev.h"
 
 #include "comedi_pci.h"
@@ -194,7 +196,7 @@ static int pc236_intr_cmdtest(struct comedi_device * dev, struct comedi_subdevic
 	struct comedi_cmd * cmd);
 static int pc236_intr_cmd(struct comedi_device * dev, struct comedi_subdevice * s);
 static int pc236_intr_cancel(struct comedi_device * dev, struct comedi_subdevice * s);
-static irqreturn_t pc236_interrupt(int irq, void *d PT_REGS_ARG);
+static irqreturn_t pc236_interrupt(int irq, void *d);
 
 /*
  * This function looks for a PCI device matching the requested board name,
@@ -638,7 +640,7 @@ static int pc236_intr_cancel(struct comedi_device * dev, struct comedi_subdevice
  * Interrupt service routine.
  * Based on the comedi_parport driver.
  */
-static irqreturn_t pc236_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t pc236_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->subdevices + 1;
diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 770b966..70381b5 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -103,6 +103,8 @@ Caveats:
      correctly.
 */
 
+#include <linux/interrupt.h>
+
 #include "../comedidev.h"
 
 #include "comedi_pci.h"
@@ -1212,7 +1214,7 @@ pci224_ao_munge(struct comedi_device * dev, struct comedi_subdevice * s, void *d
 /*
  * Interrupt handler.
  */
-static irqreturn_t pci224_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t pci224_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = &dev->subdevices[0];
diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 0c9e573..0fa228f 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -187,9 +187,11 @@ Extra triggered scan functionality, interrupt bug-fix added by Steve Sharples.
 Support for PCI230+/260+, more triggered scan functionality, and workarounds
 for (or detection of) various hardware problems added by Ian Abbott.
 */
+
 #include "../comedidev.h"
 
 #include <linux/delay.h>
+#include <linux/interrupt.h>
 
 #include "comedi_pci.h"
 #include "8253.h"
@@ -625,7 +627,7 @@ static void pci230_ct_setup_ns_mode(struct comedi_device * dev, unsigned int ct,
 	unsigned int mode, uint64_t ns, unsigned int round);
 static void pci230_ns_to_single_timer(unsigned int *ns, unsigned int round);
 static void pci230_cancel_ct(struct comedi_device * dev, unsigned int ct);
-static irqreturn_t pci230_interrupt(int irq, void *d PT_REGS_ARG);
+static irqreturn_t pci230_interrupt(int irq, void *d);
 static int pci230_ao_cmdtest(struct comedi_device * dev, struct comedi_subdevice * s,
 	struct comedi_cmd * cmd);
 static int pci230_ao_cmd(struct comedi_device * dev, struct comedi_subdevice * s);
@@ -2559,7 +2561,7 @@ static void pci230_cancel_ct(struct comedi_device * dev, unsigned int ct)
 }
 
 /* Interrupt handler */
-static irqreturn_t pci230_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t pci230_interrupt(int irq, void *d)
 {
 	unsigned char status_int, valid_status_int;
 	struct comedi_device *dev = (struct comedi_device *) d;
diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 0bfe4c9..aebb9fe 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -108,7 +108,7 @@ static const struct comedi_lrange das16cs_ai_range = { 4, {
 	}
 };
 
-static irqreturn_t das16cs_interrupt(int irq, void *d PT_REGS_ARG);
+static irqreturn_t das16cs_interrupt(int irq, void *d);
 static int das16cs_ai_rinsn(struct comedi_device * dev, struct comedi_subdevice * s,
 	struct comedi_insn * insn, unsigned int * data);
 static int das16cs_ai_cmd(struct comedi_device * dev, struct comedi_subdevice * s);
@@ -276,7 +276,7 @@ static int das16cs_detach(struct comedi_device * dev)
 	return 0;
 }
 
-static irqreturn_t das16cs_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t das16cs_interrupt(int irq, void *d)
 {
 	//struct comedi_device *dev = d;
 	return IRQ_HANDLED;
diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index fcc5516..5982b82 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -63,6 +63,7 @@ analog triggering on 1602 series
 
 #include "../comedidev.h"
 #include <linux/delay.h>
+#include <linux/interrupt.h>
 
 #include "8253.h"
 #include "8255.h"
@@ -468,7 +469,7 @@ static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
 				unsigned int trig_num);
 static int cb_pcidas_ao_cmdtest(struct comedi_device * dev, struct comedi_subdevice * s,
 	struct comedi_cmd * cmd);
-static irqreturn_t cb_pcidas_interrupt(int irq, void *d PT_REGS_ARG);
+static irqreturn_t cb_pcidas_interrupt(int irq, void *d);
 static void handle_ao_interrupt(struct comedi_device * dev, unsigned int status);
 static int cb_pcidas_cancel(struct comedi_device * dev, struct comedi_subdevice * s);
 static int cb_pcidas_ao_cancel(struct comedi_device * dev, struct comedi_subdevice * s);
@@ -1476,7 +1477,7 @@ static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
 	return 0;
 }
 
-static irqreturn_t cb_pcidas_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = (struct comedi_device *) d;
 	struct comedi_subdevice *s = dev->read_subdev;
diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 1a580bd..515a635 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -85,6 +85,7 @@ TODO:
 
 #include "../comedidev.h"
 #include <linux/delay.h>
+#include <linux/interrupt.h>
 #include <asm/system.h>
 
 #include "comedi_pci.h"
@@ -1152,7 +1153,7 @@ static int ao_inttrig(struct comedi_device * dev, struct comedi_subdevice * subd
 	unsigned int trig_num);
 static int ao_cmdtest(struct comedi_device * dev, struct comedi_subdevice * s,
 	struct comedi_cmd * cmd);
-static irqreturn_t handle_interrupt(int irq, void *d PT_REGS_ARG);
+static irqreturn_t handle_interrupt(int irq, void *d);
 static int ai_cancel(struct comedi_device * dev, struct comedi_subdevice * s);
 static int ao_cancel(struct comedi_device * dev, struct comedi_subdevice * s);
 static int dio_callback(int dir, int port, int data, unsigned long arg);
@@ -3128,7 +3129,7 @@ static void handle_ao_interrupt(struct comedi_device * dev, unsigned short statu
 	cfc_handle_events(dev, s);
 }
 
-static irqreturn_t handle_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t handle_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	unsigned short status;
diff --git a/drivers/staging/comedi/drivers/comedi_parport.c b/drivers/staging/comedi/drivers/comedi_parport.c
index a233391..3848fd4 100644
--- a/drivers/staging/comedi/drivers/comedi_parport.c
+++ b/drivers/staging/comedi/drivers/comedi_parport.c
@@ -82,6 +82,7 @@ pin, which can be used to wake up tasks.
  */
 
 #include "../comedidev.h"
+#include <linux/interrupt.h>
 #include <linux/ioport.h>
 
 #define PARPORT_SIZE 3
@@ -274,7 +275,7 @@ static int parport_intr_cancel(struct comedi_device *dev, struct comedi_subdevic
 	return 0;
 }
 
-static irqreturn_t parport_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t parport_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->subdevices + 3;
diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index 6b6b042..b89316d 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -343,7 +343,7 @@ static void das16_ai_munge(struct comedi_device * dev, struct comedi_subdevice *
 	void *array, unsigned int num_bytes, unsigned int start_chan_index);
 
 static void das16_reset(struct comedi_device * dev);
-static irqreturn_t das16_dma_interrupt(int irq, void *d PT_REGS_ARG);
+static irqreturn_t das16_dma_interrupt(int irq, void *d);
 static void das16_timer_interrupt(unsigned long arg);
 static void das16_interrupt(struct comedi_device * dev);
 
@@ -1135,7 +1135,7 @@ static int das16_ao_winsn(struct comedi_device * dev, struct comedi_subdevice *
 	return i;
 }
 
-static irqreturn_t das16_dma_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t das16_dma_interrupt(int irq, void *d)
 {
 	int status;
 	struct comedi_device *dev = d;
diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index 0e423e1..1a5cb12 100644
--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -144,7 +144,7 @@ static int das16m1_cmd_exec(struct comedi_device * dev, struct comedi_subdevice
 static int das16m1_cancel(struct comedi_device * dev, struct comedi_subdevice * s);
 
 static int das16m1_poll(struct comedi_device * dev, struct comedi_subdevice * s);
-static irqreturn_t das16m1_interrupt(int irq, void *d PT_REGS_ARG);
+static irqreturn_t das16m1_interrupt(int irq, void *d);
 static void das16m1_handler(struct comedi_device * dev, unsigned int status);
 
 static unsigned int das16m1_set_pacer(struct comedi_device * dev, unsigned int ns,
@@ -476,7 +476,7 @@ static int das16m1_poll(struct comedi_device * dev, struct comedi_subdevice * s)
 	return s->async->buf_write_count - s->async->buf_read_count;
 }
 
-static irqreturn_t das16m1_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t das16m1_interrupt(int irq, void *d)
 {
 	int status;
 	struct comedi_device *dev = d;
diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index cd4cd4e..774e6d7 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -184,7 +184,7 @@ static int das1800_attach(struct comedi_device * dev, struct comedi_devconfig *
 static int das1800_detach(struct comedi_device * dev);
 static int das1800_probe(struct comedi_device * dev);
 static int das1800_cancel(struct comedi_device * dev, struct comedi_subdevice * s);
-static irqreturn_t das1800_interrupt(int irq, void *d PT_REGS_ARG);
+static irqreturn_t das1800_interrupt(int irq, void *d);
 static int das1800_ai_poll(struct comedi_device * dev, struct comedi_subdevice * s);
 static void das1800_ai_handler(struct comedi_device * dev);
 static void das1800_handle_dma(struct comedi_device * dev, struct comedi_subdevice * s,
@@ -879,7 +879,7 @@ static int das1800_ai_poll(struct comedi_device * dev, struct comedi_subdevice *
 	return s->async->buf_write_count - s->async->buf_read_count;
 }
 
-static irqreturn_t das1800_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t das1800_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	unsigned int status;
diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
index 2a8ca05..9dccd82 100644
--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -151,7 +151,7 @@ static void das6402_setcounter(struct comedi_device * dev)
 	outb_p(p, dev->iobase + 14);
 }
 
-static irqreturn_t intr_handler(int irq, void *d PT_REGS_ARG)
+static irqreturn_t intr_handler(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->subdevices;
diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/comedi/drivers/das800.c
index 7a6656b..ee659fd 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -256,7 +256,7 @@ static struct comedi_driver driver_das800 = {
       offset:sizeof(struct das800_board),
 };
 
-static irqreturn_t das800_interrupt(int irq, void *d PT_REGS_ARG);
+static irqreturn_t das800_interrupt(int irq, void *d);
 static void enable_das800(struct comedi_device * dev);
 static void disable_das800(struct comedi_device * dev);
 static int das800_ai_do_cmdtest(struct comedi_device * dev, struct comedi_subdevice * s,
@@ -343,7 +343,7 @@ static int das800_probe(struct comedi_device * dev)
 COMEDI_INITCLEANUP(driver_das800);
 
 /* interrupt service routine */
-static irqreturn_t das800_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t das800_interrupt(int irq, void *d)
 {
 	short i;		/* loop index */
 	short dataPoint = 0;
diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index 8290836..101c22f 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -304,7 +304,7 @@ static int dmm32at_ai_cmdtest(struct comedi_device * dev, struct comedi_subdevic
 static int dmm32at_ai_cmd(struct comedi_device * dev, struct comedi_subdevice * s);
 static int dmm32at_ai_cancel(struct comedi_device * dev, struct comedi_subdevice * s);
 static int dmm32at_ns_to_timer(unsigned int *ns, int round);
-static irqreturn_t dmm32at_isr(int irq, void *d PT_REGS_ARG);
+static irqreturn_t dmm32at_isr(int irq, void *d);
 void dmm32at_setaitimer(struct comedi_device * dev, unsigned int nansec);
 
 /*
@@ -828,7 +828,7 @@ static int dmm32at_ai_cancel(struct comedi_device * dev, struct comedi_subdevice
 	return 0;
 }
 
-static irqreturn_t dmm32at_isr(int irq, void *d PT_REGS_ARG)
+static irqreturn_t dmm32at_isr(int irq, void *d)
 {
 	unsigned char intstat;
 	unsigned int samp;
diff --git a/drivers/staging/comedi/drivers/dt2811.c b/drivers/staging/comedi/drivers/dt2811.c
index 795932e..957cde6 100644
--- a/drivers/staging/comedi/drivers/dt2811.c
+++ b/drivers/staging/comedi/drivers/dt2811.c
@@ -265,7 +265,7 @@ static const struct comedi_lrange *dac_range_types[] = {
 #define DT2811_TIMEOUT 5
 
 #if 0
-static irqreturn_t dt2811_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t dt2811_interrupt(int irq, void *d)
 {
 	int lo, hi;
 	int data;
diff --git a/drivers/staging/comedi/drivers/dt2814.c b/drivers/staging/comedi/drivers/dt2814.c
index 8320139..e806520 100644
--- a/drivers/staging/comedi/drivers/dt2814.c
+++ b/drivers/staging/comedi/drivers/dt2814.c
@@ -70,7 +70,7 @@ static struct comedi_driver driver_dt2814 = {
 
 COMEDI_INITCLEANUP(driver_dt2814);
 
-static irqreturn_t dt2814_interrupt(int irq, void *dev PT_REGS_ARG);
+static irqreturn_t dt2814_interrupt(int irq, void *dev);
 
 struct dt2814_private {
 
@@ -343,7 +343,7 @@ static int dt2814_detach(struct comedi_device * dev)
 	return 0;
 }
 
-static irqreturn_t dt2814_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t dt2814_interrupt(int irq, void *d)
 {
 	int lo, hi;
 	struct comedi_device *dev = d;
diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index 4882c3e..275644a 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -577,7 +577,7 @@ static int prep_ao_dma(struct comedi_device * dev, int dma_index, int n)
 	return n;
 }
 
-static irqreturn_t dt282x_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t dt282x_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s;
diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index d946798..26ab3ba 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -347,7 +347,7 @@ static int debug_n_ints = 0;
 
 // FIXME! Assumes shared interrupt is for this card.
 // What's this debug_n_ints stuff? Obviously needs some work...
-static irqreturn_t dt3k_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t dt3k_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s;
diff --git a/drivers/staging/comedi/drivers/gsc_hpdi.c b/drivers/staging/comedi/drivers/gsc_hpdi.c
index 49e5c86..22f0a34 100644
--- a/drivers/staging/comedi/drivers/gsc_hpdi.c
+++ b/drivers/staging/comedi/drivers/gsc_hpdi.c
@@ -59,7 +59,7 @@ static int hpdi_cmd(struct comedi_device * dev, struct comedi_subdevice * s);
 static int hpdi_cmd_test(struct comedi_device * dev, struct comedi_subdevice * s,
 	struct comedi_cmd * cmd);
 static int hpdi_cancel(struct comedi_device * dev, struct comedi_subdevice * s);
-static irqreturn_t handle_interrupt(int irq, void *d PT_REGS_ARG);
+static irqreturn_t handle_interrupt(int irq, void *d);
 static int dio_config_block_size(struct comedi_device * dev, unsigned int * data);
 
 #undef HPDI_DEBUG		// disable debugging messages
@@ -945,7 +945,7 @@ static void drain_dma_buffers(struct comedi_device * dev, unsigned int channel)
 	// XXX check for buffer overrun somehow
 }
 
-static irqreturn_t handle_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t handle_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->read_subdev;
diff --git a/drivers/staging/comedi/drivers/icp_multi.c b/drivers/staging/comedi/drivers/icp_multi.c
index 15fce01..7121b37 100644
--- a/drivers/staging/comedi/drivers/icp_multi.c
+++ b/drivers/staging/comedi/drivers/icp_multi.c
@@ -618,7 +618,7 @@ static int icp_multi_insn_write_ctr(struct comedi_device *dev, struct comedi_sub
 
 ==============================================================================
 */
-static irqreturn_t interrupt_service_icp_multi(int irq, void *d PT_REGS_ARG)
+static irqreturn_t interrupt_service_icp_multi(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	int int_no;
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 12481a0..c3db3b8 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -183,7 +183,7 @@ static int ai_prepare(struct comedi_device *dev,
 static int ai_write_chanlist(struct comedi_device *dev,
 	struct comedi_subdevice *s, struct comedi_cmd *cmd);
 
-static irqreturn_t me4000_ai_isr(int irq, void *dev_id PT_REGS_ARG);
+static irqreturn_t me4000_ai_isr(int irq, void *dev_id);
 
 static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 	struct comedi_subdevice *s, struct comedi_cmd *cmd);
@@ -1740,7 +1740,7 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 	return 0;
 }
 
-static irqreturn_t me4000_ai_isr(int irq, void *dev_id PT_REGS_ARG)
+static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 {
 	unsigned int tmp;
 	struct comedi_device *dev = dev_id;
diff --git a/drivers/staging/comedi/drivers/ni_6527.c b/drivers/staging/comedi/drivers/ni_6527.c
index e01ecb6..b32833e 100644
--- a/drivers/staging/comedi/drivers/ni_6527.c
+++ b/drivers/staging/comedi/drivers/ni_6527.c
@@ -212,7 +212,7 @@ static int ni6527_do_insn_bits(struct comedi_device * dev, struct comedi_subdevi
 	return 2;
 }
 
-static irqreturn_t ni6527_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t ni6527_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->subdevices + 2;
diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index 6e85da1..97b9be3 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -454,7 +454,7 @@ static int ni_65xx_dio_insn_bits(struct comedi_device * dev, struct comedi_subde
 	return insn->n;
 }
 
-static irqreturn_t ni_65xx_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t ni_65xx_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->subdevices + 2;
diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index 14e35ba..b75ea44 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -909,7 +909,7 @@ static void ni_660x_handle_gpct_interrupt(struct comedi_device * dev,
 	}
 }
 
-static irqreturn_t ni_660x_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t ni_660x_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s;
diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index 5d45bf2..e5385e2 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -180,7 +180,7 @@ static struct comedi_driver driver_a2150 = {
       detach:a2150_detach,
 };
 
-static irqreturn_t a2150_interrupt(int irq, void *d PT_REGS_ARG);
+static irqreturn_t a2150_interrupt(int irq, void *d);
 static int a2150_ai_cmdtest(struct comedi_device * dev, struct comedi_subdevice * s,
 	struct comedi_cmd * cmd);
 static int a2150_ai_cmd(struct comedi_device * dev, struct comedi_subdevice * s);
@@ -209,7 +209,7 @@ static void ni_dump_regs(struct comedi_device * dev)
 #endif
 
 /* interrupt service routine */
-static irqreturn_t a2150_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t a2150_interrupt(int irq, void *d)
 {
 	int i;
 	int status;
diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index 35fcd17..e837844 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -127,7 +127,7 @@ static const struct atmio16_board_t atmio16_boards[] = {
 /* function prototypes */
 static int atmio16d_attach(struct comedi_device * dev, struct comedi_devconfig * it);
 static int atmio16d_detach(struct comedi_device * dev);
-static irqreturn_t atmio16d_interrupt(int irq, void *d PT_REGS_ARG);
+static irqreturn_t atmio16d_interrupt(int irq, void *d);
 static int atmio16d_ai_cmdtest(struct comedi_device * dev, struct comedi_subdevice * s,
 	struct comedi_cmd * cmd);
 static int atmio16d_ai_cmd(struct comedi_device * dev, struct comedi_subdevice * s);
@@ -257,7 +257,7 @@ static void reset_atmio16d(struct comedi_device * dev)
 	outw(2048, dev->iobase + DAC1_REG);
 }
 
-static irqreturn_t atmio16d_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t atmio16d_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 37898d8..cc23b49 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -165,7 +165,7 @@ NI manuals:
 
 static int labpc_attach(struct comedi_device * dev, struct comedi_devconfig * it);
 static int labpc_cancel(struct comedi_device * dev, struct comedi_subdevice * s);
-static irqreturn_t labpc_interrupt(int irq, void *d PT_REGS_ARG);
+static irqreturn_t labpc_interrupt(int irq, void *d);
 static int labpc_drain_fifo(struct comedi_device * dev);
 static void labpc_drain_dma(struct comedi_device * dev);
 static void handle_isa_dma(struct comedi_device * dev);
@@ -1309,7 +1309,7 @@ static int labpc_ai_cmd(struct comedi_device * dev, struct comedi_subdevice * s)
 }
 
 /* interrupt service routine */
-static irqreturn_t labpc_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t labpc_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->read_subdev;
diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 542bd0d..87f87bd 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -762,7 +762,7 @@ static inline void ni_set_bits(struct comedi_device * dev, int reg, unsigned bit
 	ni_set_bitfield(dev, reg, bits, bit_values);
 }
 
-static irqreturn_t ni_E_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t ni_E_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	unsigned short a_status;
diff --git a/drivers/staging/comedi/drivers/ni_pcidio.c b/drivers/staging/comedi/drivers/ni_pcidio.c
index 87def2c..55c7ad4 100644
--- a/drivers/staging/comedi/drivers/ni_pcidio.c
+++ b/drivers/staging/comedi/drivers/ni_pcidio.c
@@ -479,7 +479,7 @@ void ni_pcidio_event(struct comedi_device * dev, struct comedi_subdevice * s)
 	comedi_event(dev, s);
 }
 
-static irqreturn_t nidio_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t nidio_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->subdevices;
diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index ce42506..7b99471 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -185,7 +185,7 @@ struct pcl711_private {
 
 #define devpriv ((struct pcl711_private *)dev->private)
 
-static irqreturn_t pcl711_interrupt(int irq, void *d PT_REGS_ARG)
+static irqreturn_t pcl711_interrupt(int irq, void *d)
 {
 	int lo, hi;
 	int data;
diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 11dfd23..c5bae29 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -1061,7 +1061,7 @@ static irqreturn_t interrupt_pcl812_ai_dma(int irq, void *d)
 /*
 ==============================================================================
 */
-static irqreturn_t interrupt_pcl812(int irq, void *d PT_REGS_ARG)
+static irqreturn_t interrupt_pcl812(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 
diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index 515ba74..b3469f5 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -409,7 +409,7 @@ static irqreturn_t interrupt_pcl816_ai_mode13_dma(int irq, void *d)
 ==============================================================================
     INT procedure
 */
-static irqreturn_t interrupt_pcl816(int irq, void *d PT_REGS_ARG)
+static irqreturn_t interrupt_pcl816(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	DPRINTK("<I>");
diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 43a9d56..3e3f7f1 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -810,7 +810,7 @@ static irqreturn_t interrupt_pcl818_ai_mode13_fifo(int irq, void *d)
 ==============================================================================
     INT procedure
 */
-static irqreturn_t interrupt_pcl818(int irq, void *d PT_REGS_ARG)
+static irqreturn_t interrupt_pcl818(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 
diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index 01e40f1..8c332c2 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -300,7 +300,7 @@ static int pcmmio_dio_insn_bits(struct comedi_device * dev, struct comedi_subdev
 static int pcmmio_dio_insn_config(struct comedi_device * dev, struct comedi_subdevice * s,
 	struct comedi_insn * insn, unsigned int * data);
 
-static irqreturn_t interrupt_pcmmio(int irq, void *d PT_REGS_ARG);
+static irqreturn_t interrupt_pcmmio(int irq, void *d);
 static void pcmmio_stop_intr(struct comedi_device *, struct comedi_subdevice *);
 static int pcmmio_cancel(struct comedi_device * dev, struct comedi_subdevice * s);
 static int pcmmio_cmd(struct comedi_device * dev, struct comedi_subdevice * s);
@@ -765,7 +765,7 @@ static void unlock_port(struct comedi_device * dev, int asic, int port)
 }
 #endif /* notused */
 
-static irqreturn_t interrupt_pcmmio(int irq, void *d PT_REGS_ARG)
+static irqreturn_t interrupt_pcmmio(int irq, void *d)
 {
 	int asic, got1 = 0;
 	struct comedi_device *dev = (struct comedi_device *) d;
diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index 4e7d8b6..de9c135 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -258,7 +258,7 @@ static int pcmuio_dio_insn_bits(struct comedi_device * dev, struct comedi_subdev
 static int pcmuio_dio_insn_config(struct comedi_device * dev, struct comedi_subdevice * s,
 	struct comedi_insn * insn, unsigned int * data);
 
-static irqreturn_t interrupt_pcmuio(int irq, void *d PT_REGS_ARG);
+static irqreturn_t interrupt_pcmuio(int irq, void *d);
 static void pcmuio_stop_intr(struct comedi_device *, struct comedi_subdevice *);
 static int pcmuio_cancel(struct comedi_device * dev, struct comedi_subdevice * s);
 static int pcmuio_cmd(struct comedi_device * dev, struct comedi_subdevice * s);
@@ -688,7 +688,7 @@ static void unlock_port(struct comedi_device * dev, int asic, int port)
 }
 #endif /* notused */
 
-static irqreturn_t interrupt_pcmuio(int irq, void *d PT_REGS_ARG)
+static irqreturn_t interrupt_pcmuio(int irq, void *d)
 {
 	int asic, got1 = 0;
 	struct comedi_device *dev = (struct comedi_device *) d;
diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index 795c452..d05f33b 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -262,7 +262,7 @@ static int daqp_ai_cancel(struct comedi_device * dev, struct comedi_subdevice *
  * which run pretty quick.
  */
 
-static void daqp_interrupt(int irq, void *dev_id PT_REGS_ARG)
+static void daqp_interrupt(int irq, void *dev_id)
 {
 	struct local_info_t *local = (struct local_info_t *) dev_id;
 	struct comedi_device *dev;
diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index ca347f2..700090d 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -706,7 +706,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s);
 static int rtd_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s);
 /* static int rtd_ai_poll (struct comedi_device *dev,struct comedi_subdevice *s); */
 static int rtd_ns_to_timer(unsigned int *ns, int roundMode);
-static irqreturn_t rtd_interrupt(int irq, void *d PT_REGS_ARG);
+static irqreturn_t rtd_interrupt(int irq, void *d);
 static int rtd520_probe_fifo_depth(struct comedi_device *dev);
 
 /*
@@ -1494,8 +1494,7 @@ static int ai_process_dma(struct comedi_device *dev, struct comedi_subdevice *s)
   The data conversion may someday happen in a "bottom half".
 */
 static irqreturn_t rtd_interrupt(int irq,	/* interrupt number (ignored) */
-	void *d			/* our data */
-	PT_REGS_ARG)
+	void *d)		/* our data */
 {				/* cpu context (ignored) */
 	struct comedi_device *dev = d;	/* must be called "dev" for devpriv */
 	u16 status;
diff --git a/drivers/staging/comedi/drivers/rti800.c b/drivers/staging/comedi/drivers/rti800.c
index 334ac57..5c7ef8e 100644
--- a/drivers/staging/comedi/drivers/rti800.c
+++ b/drivers/staging/comedi/drivers/rti800.c
@@ -145,7 +145,7 @@ static struct comedi_driver driver_rti800 = {
 
 COMEDI_INITCLEANUP(driver_rti800);
 
-static irqreturn_t rti800_interrupt(int irq, void *dev PT_REGS_ARG);
+static irqreturn_t rti800_interrupt(int irq, void *dev);
 
 struct rti800_private {
 	enum {
@@ -172,7 +172,7 @@ struct rti800_private {
 
 #define RTI800_TIMEOUT 100
 
-static irqreturn_t rti800_interrupt(int irq, void *dev PT_REGS_ARG)
+static irqreturn_t rti800_interrupt(int irq, void *dev)
 {
 	return IRQ_HANDLED;
 }
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 30dec9d..bf7e204 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -253,7 +253,7 @@ static int s626_ns_to_timer(int *nanosec, int round_mode);
 static int s626_ai_load_polllist(uint8_t *ppl, struct comedi_cmd *cmd);
 static int s626_ai_inttrig(struct comedi_device *dev, struct comedi_subdevice *s,
 	unsigned int trignum);
-static irqreturn_t s626_irq_handler(int irq, void *d PT_REGS_ARG);
+static irqreturn_t s626_irq_handler(int irq, void *d);
 static unsigned int s626_ai_reg_to_uint(int data);
 /* static unsigned int s626_uint_to_reg(struct comedi_subdevice *s, int data); */
 
@@ -968,7 +968,7 @@ static unsigned int s626_ai_reg_to_uint(int data)
 /*   return 0; */
 /* } */
 
-static irqreturn_t s626_irq_handler(int irq, void *d PT_REGS_ARG)
+static irqreturn_t s626_irq_handler(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s;
diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 2fb64de..6435f6c 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -314,7 +314,7 @@ static int usbduxfast_ai_cancel(struct comedi_device *dev, struct comedi_subdevi
  * analogue IN
  * interrupt service routine
  */
-static void usbduxfastsub_ai_Irq(struct urb *urb PT_REGS_ARG)
+static void usbduxfastsub_ai_Irq(struct urb *urb)
 {
 	int n, err;
 	struct usbduxfastsub_s *udfs;
diff --git a/drivers/staging/comedi/interrupt.h b/drivers/staging/comedi/interrupt.h
deleted file mode 100644
index d1f0989..0000000
--- a/drivers/staging/comedi/interrupt.h
+++ /dev/null
@@ -1,51 +0,0 @@
-/*
-    linux/interrupt.h compatibility header
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#ifndef __COMPAT_LINUX_INTERRUPT_H_
-#define __COMPAT_LINUX_INTERRUPT_H_
-
-#include <linux/interrupt.h>
-
-#ifndef IRQF_DISABLED
-#define IRQF_DISABLED           SA_INTERRUPT
-#define IRQF_SAMPLE_RANDOM      SA_SAMPLE_RANDOM
-#define IRQF_SHARED             SA_SHIRQ
-#define IRQF_PROBE_SHARED       SA_PROBEIRQ
-#define IRQF_PERCPU             SA_PERCPU
-#ifdef SA_TRIGGER_MASK
-#define IRQF_TRIGGER_NONE       0
-#define IRQF_TRIGGER_LOW        SA_TRIGGER_LOW
-#define IRQF_TRIGGER_HIGH       SA_TRIGGER_HIGH
-#define IRQF_TRIGGER_FALLING    SA_TRIGGER_FALLING
-#define IRQF_TRIGGER_RISING     SA_TRIGGER_RISING
-#define IRQF_TRIGGER_MASK       SA_TRIGGER_MASK
-#else
-#define IRQF_TRIGGER_NONE       0
-#define IRQF_TRIGGER_LOW        0
-#define IRQF_TRIGGER_HIGH       0
-#define IRQF_TRIGGER_FALLING    0
-#define IRQF_TRIGGER_RISING     0
-#define IRQF_TRIGGER_MASK       0
-#endif
-#endif
-
-#define PT_REGS_ARG
-#define PT_REGS_CALL
-#define PT_REGS_NULL
-
-#endif
diff --git a/drivers/staging/comedi/rt.c b/drivers/staging/comedi/rt.c
index e9f5777..ace360d 100644
--- a/drivers/staging/comedi/rt.c
+++ b/drivers/staging/comedi/rt.c
@@ -27,6 +27,7 @@
 #include <linux/comedidev.h>
 
 #include <linux/errno.h>
+#include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/fcntl.h>
@@ -54,7 +55,7 @@
 struct comedi_irq_struct {
 	int rt;
 	int irq;
-	 irqreturn_t(*handler) (int irq, void *dev_id PT_REGS_ARG);
+	irq_handler_t handler;
 	unsigned long flags;
 	const char *device;
 	struct comedi_device *dev_id;
@@ -65,9 +66,8 @@ static int comedi_rt_release_irq(struct comedi_irq_struct *it);
 
 static struct comedi_irq_struct *comedi_irqs[NR_IRQS];
 
-int comedi_request_irq(unsigned irq, irqreturn_t(*handler) (int,
-		void *PT_REGS_ARG), unsigned long flags, const char *device,
-	struct comedi_device *dev_id)
+int comedi_request_irq(unsigned irq, irq_handler_t handler, unsigned long flags,
+		const char *device, struct comedi_device *dev_id)
 {
 	struct comedi_irq_struct *it;
 	int ret;
@@ -191,7 +191,7 @@ static void handle_void_irq(int irq)
 		rt_printk("comedi: null irq struct?\n");
 		return;
 	}
-	it->handler(irq, it->dev_id PT_REGS_NULL);
+	it->handler(irq, it->dev_id);
 	rt_enable_irq(irq);	/* needed by rtai-adeos, seems like it shouldn't hurt earlier versions */
 }
 
@@ -307,7 +307,7 @@ static void fusion_handle_irq(unsigned int irq, void *cookie)
 {
 	struct comedi_irq_struct *it = cookie;
 
-	it->handler(irq, it->dev_id PT_REGS_NULL);
+	it->handler(irq, it->dev_id);
 	rthal_irq_enable(irq);
 }
 
@@ -340,14 +340,14 @@ void comedi_rt_cleanup(void)
 /* RTLinux section */
 #ifdef CONFIG_COMEDI_RTL
 
-static unsigned int handle_rtl_irq(unsigned int irq PT_REGS_ARG)
+static unsigned int handle_rtl_irq(unsigned int irq)
 {
 	struct comedi_irq_struct *it;
 
 	it = comedi_irqs[irq];
 	if (it == NULL)
 		return 0;
-	it->handler(irq, it->dev_id PT_REGS_NULL);
+	it->handler(irq, it->dev_id);
 	rtl_hard_enable_irq(irq);
 	return 0;
 }
diff --git a/drivers/staging/comedi/rt_pend_tq.c b/drivers/staging/comedi/rt_pend_tq.c
index f9dfd9d..a374284 100644
--- a/drivers/staging/comedi/rt_pend_tq.c
+++ b/drivers/staging/comedi/rt_pend_tq.c
@@ -69,7 +69,7 @@ void rt_pend_irq_handler(void)
 #elif defined(CONFIG_COMEDI_FUSION)
 void rt_pend_irq_handler(void *cookie)
 #elif defined(CONFIG_COMEDI_RTL)
-void rt_pend_irq_handler(int irq, void *dev PT_REGS_ARG)
+void rt_pend_irq_handler(int irq, void *dev)
 #endif
 {
 	while (rt_pend_head != rt_pend_tail) {
-- 
1.6.2

