Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbYJPW4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbYJPW4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbYJPWz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:55:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757280AbYJPWz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:55:56 -0400
Date: Thu, 16 Oct 2008 15:55:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: eric.piel@tremplin-utc.net, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, rpurdie@rpsys.net, trenn@suse.de,
       burman.yan@gmail.com
Subject: Re: Driver for HP harddisk protection LED
Message-Id: <20081016155514.eed60f09.akpm@linux-foundation.org>
In-Reply-To: <20081016091016.GA15439@atrey.karlin.mff.cuni.cz>
References: <48C984F5.5000804@tudelft.nl>
	<200809120736.06594.trenn@suse.de>
	<48CAD89F.1050806@tremplin-utc.net>
	<20081015072511.GA20607@atrey.karlin.mff.cuni.cz>
	<20081016091016.GA15439@atrey.karlin.mff.cuni.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 11:10:16 +0200
Pavel Machek <pavel@suse.cz> wrote:

> HP notebooks contain accelerometer-based disk protection subsystem,
> and LED that indicates hard disk is protected. This is driver for the
> LED part.

- fix comment typo

- use standard suspend/resume ifdef avoidance trick


 drivers/leds/leds-hp-disk.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/leds/leds-hp-disk.c~leds-driver-for-hp-harddisk-protection-led-fix
+++ a/drivers/leds/leds-hp-disk.c
@@ -49,7 +49,7 @@ static struct acpi_hpled adev;
 
 static acpi_status hpled_acpi_write(acpi_handle handle, int reg)
 {
-	unsigned long ret; /* Not used when writting */
+	unsigned long ret; /* Not used when writing */
 	union acpi_object in_obj[1];
 	struct acpi_object_list args = { 1, in_obj };
 
@@ -83,6 +83,9 @@ static int hpled_resume(struct acpi_devi
 	led_classdev_resume(&hpled_led);
 	return 0;
 }
+#else
+#define hpled_suspend NULL
+#define hpled_resume NULL
 #endif
 
 static int hpled_add(struct acpi_device *device)
@@ -119,10 +122,8 @@ static struct acpi_driver leds_hp_driver
 	.ops = {
 		.add     = hpled_add,
 		.remove  = hpled_remove,
-#ifdef CONFIG_PM
 		.suspend = hpled_suspend,
 		.resume  = hpled_resume,
-#endif
 	}
 };
 
_

