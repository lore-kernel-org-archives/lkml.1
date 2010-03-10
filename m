Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab0CJOCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 09:02:37 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:48105 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab0CJOCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 09:02:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=MTuo94PiWagnqmURkx04ldElSFY1AfejFeR66K7UPJX9ffPZ/ZVTF5U7RinL6RG1XE
         l7HIRh0bpKRTKmaNnaxPAi+oVo4c6ylf2mCC6LnH11iUcf/FJuocHzC2yTv8OfwWBHWy
         LyTqeQVw9nn2G5Wh3kjCfRkXexfPqyAhMpDAw=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 15/15] Staging: comedi: fix macro coding style issue in adl_pci9111.c
Date: Wed, 10 Mar 2010 14:02:15 +0000
Message-Id: <1268229735-5387-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch to the adl_pci9111.c file that fixes, ERROR: Macros with multiple statements should be enclosed in a do - while block, found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/adl_pci9111.c |   44 +++++++++++++++++--------
 1 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 5e6f72f..5171176 100755
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -207,12 +207,14 @@ Add external multiplexer support.
   outb(0, PCI9111_IO_BASE+PCI9111_REGISTER_SOFTWARE_TRIGGER)
 
 #define pci9111_fifo_reset() \
-  outb(PCI9111_FFEN_SET_FIFO_ENABLE, \
-    PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
-  outb(PCI9111_FFEN_SET_FIFO_DISABLE, \
-    PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
-  outb(PCI9111_FFEN_SET_FIFO_ENABLE, \
-    PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL)
+	do { \
+		outb(PCI9111_FFEN_SET_FIFO_ENABLE, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
+		outb(PCI9111_FFEN_SET_FIFO_DISABLE, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
+		outb(PCI9111_FFEN_SET_FIFO_ENABLE, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
+	} while (0);
 
 #define pci9111_is_fifo_full() \
   ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)& \
@@ -264,16 +266,28 @@ Add external multiplexer support.
   outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_8254_CONTROL)
 
 #define pci9111_8254_counter_0_set(data) \
-  outb(data & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_0); \
-  outb((data >> 8) & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_0)
+	do { \
+		outb(data & 0xFF, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_0); \
+		outb((data >> 8) & 0xFF, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_0); \
+	} while (0);
 
 #define pci9111_8254_counter_1_set(data) \
-  outb(data & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1); \
-  outb((data >> 8) & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1)
+	do { \
+		outb(data & 0xFF, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1); \
+		outb((data >> 8) & 0xFF, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1); \
+	} while (0);
 
 #define pci9111_8254_counter_2_set(data) \
-  outb(data & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2); \
-  outb((data >> 8) & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2)
+	do { \
+		outb(data & 0xFF, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2); \
+		outb((data >> 8) & 0xFF, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2); \
+	} while (0);
 
 /*  Function prototypes */
 
@@ -564,8 +578,10 @@ static int pci9111_ai_cancel(struct comedi_device *dev,
 /*  Test analog input command */
 
 #define pci9111_check_trigger_src(src, flags) \
-  tmp = src; \
-  src &= flags; if (!src || tmp != src) error++
+	do { \
+		tmp = src; \
+		src &= flags; if (!src || tmp != src) error++; \
+	} while (0);
 
 static int
 pci9111_ai_do_cmd_test(struct comedi_device *dev,
-- 
1.6.3.3

