Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbXIRSOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbXIRSOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 14:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbXIRSOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 14:14:12 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36080 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757817AbXIRSOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 14:14:11 -0400
Date: Tue, 18 Sep 2007 20:14:25 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Martin Bachem <info@colognechip.com>, Karsten Keil <kkeil@suse.de>
Cc: isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
Subject: [2.6 patch] isdn/hisax/hfc_usb.c: fix check-after-use
Message-ID: <20070918181425.GB16401@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a check-after-use spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/isdn/hisax/hfc_usb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

53472364f051d7e80182a5eb12d3853353e393be 
diff --git a/drivers/isdn/hisax/hfc_usb.c b/drivers/isdn/hisax/hfc_usb.c
index 60843b3..92a796d 100644
--- a/drivers/isdn/hisax/hfc_usb.c
+++ b/drivers/isdn/hisax/hfc_usb.c
@@ -1520,14 +1520,15 @@ hfc_usb_disconnect(struct usb_interface
 	hfcusb_data *context = usb_get_intfdata(intf);
 	int i;
 
+	if (!context)
+		return;
+	
 	handle_led(context, LED_POWER_OFF);
 	schedule_timeout((10 * HZ) / 1000);
 
 	printk(KERN_INFO "HFC-S USB: device disconnect\n");
 	context->disc_flag = 1;
 	usb_set_intfdata(intf, NULL);
-	if (!context)
-		return;
 	if (timer_pending(&context->t3_timer))
 		del_timer(&context->t3_timer);
 	if (timer_pending(&context->t4_timer))

