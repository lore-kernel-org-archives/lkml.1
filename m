Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab0BSRIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:08:23 -0500
Received: from kroah.org ([198.145.64.141]:57731 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956Ab0BSRBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:00 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:49 2010
Message-Id: <20100219163249.094055491@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sergey Matyukevich <geomatsi@gmail.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Sergey Lapin <slapin@ossfans.org>
Subject: [67/93] rtc-fm3130: add missing braces
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sergey Matyukevich <geomatsi@gmail.com>

commit f4b5162820de60204afa5c8639335f4931b7fb0c upstream.

Add missing braces for multiline 'if' statements in fm3130_probe.

Signed-off-by: Sergey Matyukevich <geomatsi@gmail.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sergey Lapin <slapin@ossfans.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/rtc/rtc-fm3130.c
+++ b/drivers/rtc/rtc-fm3130.c
@@ -376,20 +376,22 @@ static int __devinit fm3130_probe(struct i2c_client *client,
 	}
 
 	/* Disabling calibration mode */
-	if (fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_CAL)
+	if (fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_CAL) {
 		i2c_smbus_write_byte_data(client, FM3130_RTC_CONTROL,
 			fm3130->regs[FM3130_RTC_CONTROL] &
 				~(FM3130_RTC_CONTROL_BIT_CAL));
 		dev_warn(&client->dev, "Disabling calibration mode!\n");
+	}
 
 	/* Disabling read and write modes */
 	if (fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_WRITE ||
-	    fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_READ)
+	    fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_READ) {
 		i2c_smbus_write_byte_data(client, FM3130_RTC_CONTROL,
 			fm3130->regs[FM3130_RTC_CONTROL] &
 				~(FM3130_RTC_CONTROL_BIT_READ |
 					FM3130_RTC_CONTROL_BIT_WRITE));
 		dev_warn(&client->dev, "Disabling READ or WRITE mode!\n");
+	}
 
 	/* oscillator off?  turn it on, so clock can tick. */
 	if (fm3130->regs[FM3130_CAL_CONTROL] & FM3130_CAL_CONTROL_BIT_nOSCEN)


