Return-Path: <linux-kernel-owner+w=401wt.eu-S1161104AbXBVOpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161104AbXBVOpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 09:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161060AbXBVOpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 09:45:20 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:38800 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030202AbXBVOpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 09:45:18 -0500
X-Sasl-enc: r0n4enZ/YZAQl2WwvWXvkG4d5X3hBGpDpopKscqIGQzv 1172155604
Date: Thu, 22 Feb 2007 12:45:11 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-acpi@vger.kernel.org
Subject: ACPI: ibm-acpi: fix initial status of backlight device
Message-ID: <20070222144511.GC25887@khazad-dum.debian.net>
References: <20070219000412.acad13de.akpm@linux-foundation.org> <1171876788.6046.3.camel@localhost.localdomain> <877iub9mu2.fsf@sycorax.lbl.gov> <1172097718.5790.29.camel@localhost.localdomain> <20070221231706.GA3336@khazad-dum.debian.net> <1172103159.5790.45.camel@localhost.localdomain> <20070222005122.GA7928@khazad-dum.debian.net> <20070222011017.GA8845@khazad-dum.debian.net> <20070222011643.GB8845@khazad-dum.debian.net> <1172138587.5837.37.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172138587.5837.37.camel@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The brightness class core does not update the initial status of the
device's brightness at register time.  Do it by ourselves.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Richard Purdie <rpurdie@rpsys.net>
---

Waiting ACK from Richard Purdie, applies on top of 2.6.21-rc1.  Also fixes a
whitespace problem.

 drivers/acpi/ibm_acpi.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/ibm_acpi.c b/drivers/acpi/ibm_acpi.c
index 4cc534e..c59ebff 100644
--- a/drivers/acpi/ibm_acpi.c
+++ b/drivers/acpi/ibm_acpi.c
@@ -1711,6 +1711,12 @@ static struct backlight_ops ibm_backlight_data = {
 
 static int brightness_init(void)
 {
+	int b;
+
+	b = brightness_get(NULL);
+	if (b < 0)
+		return b;
+
 	ibm_backlight_device = backlight_device_register("ibm", NULL, NULL,
 							 &ibm_backlight_data);
 	if (IS_ERR(ibm_backlight_device)) {
@@ -1718,7 +1724,8 @@ static int brightness_init(void)
 		return PTR_ERR(ibm_backlight_device);
 	}
 
-        ibm_backlight_device->props.max_brightness = 7;
+	ibm_backlight_device->props.max_brightness = 7;
+	ibm_backlight_device->props.brightness = b;
 
 	return 0;
 }
-- 
1.4.4.4

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
