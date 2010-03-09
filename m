Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab0CIUuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 15:50:05 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:62096 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab0CIUuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:50:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=RwfBHxkb0iU1gUWodx/efb67XLshCDjfdGyziKRQAbM3pgmmykdc+Eope+ES1WnVc3
         No1gKGtxWL+njBjwo+X4umXzkpg4ipb2gBX9S5wDEXEhvl9QV49swXH7T9M+FNrS8Qj1
         CUFght4cfRJYpCKTq58UVNL7YyjyJPiK4jgGs=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] Staging: comedi: fixes parenthesis errors in adl_pci9111.c
Date: Tue,  9 Mar 2010 20:49:45 +0000
Message-Id: <1268167785-2303-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch to the adl_pci9111.c file that fixes ERROR: Macros with complex values should be enclosed in parenthesis

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/adl_pci9111.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index bf47f79..5e6f72f 100755
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -181,7 +181,7 @@ Add external multiplexer support.
 #define PCI9111_FIFO_FULL_MASK				0x40
 #define PCI9111_AD_BUSY_MASK				0x80
 
-#define PCI9111_IO_BASE dev->iobase
+#define PCI9111_IO_BASE (dev->iobase)
 
 /*
  * Define inlined function
@@ -231,22 +231,24 @@ Add external multiplexer support.
     PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_CONTROL)
 
 #define pci9111_ai_channel_get() \
-  inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_READBACK)&PCI9111_CHANNEL_MASK
+  inb((PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_READBACK)& \
+							PCI9111_CHANNEL_MASK)
 
 #define pci9111_ai_range_set(range) \
   outb((range)&PCI9111_RANGE_MASK, \
     PCI9111_IO_BASE+PCI9111_REGISTER_INPUT_SIGNAL_RANGE)
 
 #define pci9111_ai_range_get() \
-  inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)&PCI9111_RANGE_MASK
+  inb((PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)& \
+							PCI9111_RANGE_MASK)
 
 #define pci9111_ai_get_data() \
-  ((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE)>>4) \
-    &PCI9111_AI_RESOLUTION_MASK) ^ PCI9111_AI_RESOLUTION_2_CMP_BIT
+  (((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE)>>4) \
+    &PCI9111_AI_RESOLUTION_MASK) ^ PCI9111_AI_RESOLUTION_2_CMP_BIT)
 
 #define pci9111_hr_ai_get_data() \
-  (inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE) \
-    &PCI9111_HR_AI_RESOLUTION_MASK) ^ PCI9111_HR_AI_RESOLUTION_2_CMP_BIT
+  ((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE) \
+    &PCI9111_HR_AI_RESOLUTION_MASK) ^ PCI9111_HR_AI_RESOLUTION_2_CMP_BIT)
 
 #define pci9111_ao_set_data(data) \
   outw(data&PCI9111_AO_RESOLUTION_MASK, \
-- 
1.6.3.3

