Return-Path: <linux-kernel-owner+w=401wt.eu-S936093AbZLQEFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936093AbZLQEFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935547AbZLQEE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:27 -0500
Received: from kroah.org ([198.145.64.141]:55514 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763981AbZLQEES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:18 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:50 2009
Message-Id: <20091217035649.905521468@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Igor Grinberg <grinberg@compulab.co.il>,
       Mike Rapoport <mike@compulab.co.il>, Eric Miao <eric.y.miao@gmail.com>
Subject: [054/151] [ARM] pxa/em-x270: fix usb hub power up/reset sequence
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
 


