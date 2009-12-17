Return-Path: <linux-kernel-owner+w=401wt.eu-S1763665AbZLQBpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763665AbZLQBpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763589AbZLQBow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:44:52 -0500
Received: from kroah.org ([198.145.64.141]:47820 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763541AbZLQBUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:00 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:00 2009
Message-Id: <20091217011600.203236971@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Igor Grinberg <grinberg@compulab.co.il>,
       Mike Rapoport <mike@compulab.co.il>, Eric Miao <eric.y.miao@gmail.com>
Subject: [18/90] [ARM] pxa/em-x270: fix usb hub power up/reset sequence
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Igor Grinberg <grinberg@compulab.co.il>

commit 1b82e4c32fba96d8805b1e2126ba5382e56fac32 upstream.

Signed-off-by: Igor Grinberg <grinberg@compulab.co.il>
Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-pxa/em-x270.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/arch/arm/mach-pxa/em-x270.c
+++ b/arch/arm/mach-pxa/em-x270.c
@@ -497,16 +497,15 @@ static int em_x270_usb_hub_init(void)
 		goto err_free_vbus_gpio;
 
 	/* USB Hub power-on and reset */
-	gpio_direction_output(usb_hub_reset, 0);
+	gpio_direction_output(usb_hub_reset, 1);
+	gpio_direction_output(GPIO9_USB_VBUS_EN, 0);
 	regulator_enable(em_x270_usb_ldo);
-	gpio_set_value(usb_hub_reset, 1);
 	gpio_set_value(usb_hub_reset, 0);
+	gpio_set_value(usb_hub_reset, 1);
 	regulator_disable(em_x270_usb_ldo);
 	regulator_enable(em_x270_usb_ldo);
-	gpio_set_value(usb_hub_reset, 1);
-
-	/* enable VBUS */
-	gpio_direction_output(GPIO9_USB_VBUS_EN, 1);
+	gpio_set_value(usb_hub_reset, 0);
+	gpio_set_value(GPIO9_USB_VBUS_EN, 1);
 
 	return 0;
 


