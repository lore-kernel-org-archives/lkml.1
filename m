Return-Path: <linux-kernel-owner+w=401wt.eu-S932994AbXBVBQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbXBVBQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932987AbXBVBQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:16:49 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:42169 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932955AbXBVBQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:16:47 -0500
X-Sasl-enc: AcnPks8jsBNXFGbiNSIbShPAzJq1vpGbD4wKhuNv865J 1172107087
Date: Wed, 21 Feb 2007 23:16:43 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-acpi@vger.kernel.org
Subject: ACPI: ibm-acpi: fix initial status of backlight device
Message-ID: <20070222011643.GB8845@khazad-dum.debian.net>
References: <20070219044616.GC25659@washoe.onerussian.com> <20070219000412.acad13de.akpm@linux-foundation.org> <1171876788.6046.3.camel@localhost.localdomain> <877iub9mu2.fsf@sycorax.lbl.gov> <1172097718.5790.29.camel@localhost.localdomain> <20070221231706.GA3336@khazad-dum.debian.net> <1172103159.5790.45.camel@localhost.localdomain> <20070222005122.GA7928@khazad-dum.debian.net> <20070222011017.GA8845@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222011017.GA8845@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The brightness class core does not update the initial status of
the device's brightness at register time.  Do it by ourselves
before we register the class device.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Richard Purdie <rpurdie@rpsys.net>
---

NOTE: This patch needs an ACK from Richard Purdie before it can be merged,
as he might want to change the backlight class code instead.

 drivers/acpi/ibm_acpi.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/ibm_acpi.c b/drivers/acpi/ibm_acpi.c
index 2429e11..6875421 100644
--- a/drivers/acpi/ibm_acpi.c
+++ b/drivers/acpi/ibm_acpi.c
@@ -1713,6 +1713,13 @@ static struct backlight_properties ibm_backlight_data = {
 
 static int brightness_init(void)
 {
+	int b;
+
+	b = brightness_get(NULL);
+	if (b < 0)
+		return b;
+	ibm_backlight_data.brightness = b;
+
 	ibm_backlight_device = backlight_device_register("ibm", NULL, NULL,
 							 &ibm_backlight_data);
 	if (IS_ERR(ibm_backlight_device)) {
-- 
1.4.4.4

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
