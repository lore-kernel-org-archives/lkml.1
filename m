Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbYACLB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbYACLB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 06:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYACLBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 06:01:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:38679 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbYACLBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 06:01:50 -0500
Date: Thu, 3 Jan 2008 12:01:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: malattia@linux.it, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Cc: trivial@kernel.org
Subject: struct should not be named same way as function in sony-laptop
Message-ID: <20080103110154.GA2376@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naming struct and function by same name is evil. Rename the struct.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/misc/sony-laptop.c b/drivers/misc/sony-laptop.c
index b0f6803..31ce39d 100644
--- a/drivers/misc/sony-laptop.c
+++ b/drivers/misc/sony-laptop.c
@@ -1180,7 +1180,7 @@ struct sony_pic_ioport {
 	struct list_head	list;
 };
 
-struct sony_pic_irq {
+struct sony_pic_irqdesc {
 	struct acpi_resource_irq	irq;
 	struct list_head		list;
 };
@@ -1192,7 +1192,7 @@ struct sony_pic_dev {
 	u8			bluetooth_power;
 	u8			wwan_power;
 	struct acpi_device	*acpi_dev;
-	struct sony_pic_irq	*cur_irq;
+	struct sony_pic_irqdesc	*cur_irq;
 	struct sony_pic_ioport	*cur_ioport;
 	struct list_head	interrupts;
 	struct list_head	ioports;
@@ -2094,7 +2094,7 @@ sony_pic_read_possible_resource(struct a
 	case ACPI_RESOURCE_TYPE_IRQ:
 		{
 			struct acpi_resource_irq *p = &resource->data.irq;
-			struct sony_pic_irq *interrupt = NULL;
+			struct sony_pic_irqdesc *interrupt = NULL;
 			if (!p || !p->interrupt_count) {
 				/*
 				 * IRQ descriptors may have no IRQ# bits set,
@@ -2218,7 +2218,7 @@ static int sony_pic_disable(struct acpi_
  *  Call _SRS to set current resources
  */
 static int sony_pic_enable(struct acpi_device *device,
-		struct sony_pic_ioport *ioport, struct sony_pic_irq *irq)
+		struct sony_pic_ioport *ioport, struct sony_pic_irqdesc *irq)
 {
 	acpi_status status;
 	int result = 0;
@@ -2381,7 +2381,7 @@ found:
 static int sony_pic_remove(struct acpi_device *device, int type)
 {
 	struct sony_pic_ioport *io, *tmp_io;
-	struct sony_pic_irq *irq, *tmp_irq;
+	struct sony_pic_irqdesc *irq, *tmp_irq;
 
 	if (sony_pic_disable(device)) {
 		printk(KERN_ERR DRV_PFX "Couldn't disable device.\n");
@@ -2422,7 +2422,7 @@ static int sony_pic_add(struct acpi_devi
 {
 	int result;
 	struct sony_pic_ioport *io, *tmp_io;
-	struct sony_pic_irq *irq, *tmp_irq;
+	struct sony_pic_irqdesc *irq, *tmp_irq;
 
 	printk(KERN_INFO DRV_PFX "%s v%s.\n",
 		SONY_PIC_DRIVER_NAME, SONY_LAPTOP_DRIVER_VERSION);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
