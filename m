Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab0BVJpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 04:45:18 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33289 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667Ab0BVJpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 04:45:14 -0500
X-Sasl-enc: KHIJnyZc/tt5zJsVlVBt8K3ygo6bxDFv4yEk+02tfz0h 1266831913
Message-ID: <4B825228.8050405@ladisch.de>
Date: Mon, 22 Feb 2010 10:45:12 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] thinkpad-acpi: fix return value of volume callbacks
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the volume status setting functions to return a non-zero value if
the control value has changed, so that the ALSA framework can correctly
generate control change notifications.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

--- linux/drivers/platform/x86/thinkpad_acpi.c
+++ linux/drivers/platform/x86/thinkpad_acpi.c
@@ -6537,8 +6537,11 @@ static int volume_set_mute_ec(const bool
 	n = (mute) ? s | TP_EC_AUDIO_MUTESW_MSK :
 		     s & ~TP_EC_AUDIO_MUTESW_MSK;
 
-	if (n != s)
+	if (n != s) {
 		rc = volume_set_status_ec(n);
+		if (!rc)
+			rc = 1;
+	}
 
 unlock:
 	mutex_unlock(&volume_mutex);
@@ -6569,8 +6572,11 @@ static int volume_set_volume_ec(const u8
 
 	n = (s & ~TP_EC_AUDIO_LVL_MSK) | vol;
 
-	if (n != s)
+	if (n != s) {
 		rc = volume_set_status_ec(n);
+		if (!rc)
+			rc = 1;
+	}
 
 unlock:
 	mutex_unlock(&volume_mutex);
