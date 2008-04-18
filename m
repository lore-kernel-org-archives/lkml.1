Return-Path: <linux-kernel-owner+w=401wt.eu-S1761557AbYDUN1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557AbYDUN1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758033AbYDUNTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:19:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:8449 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759977AbYDUNTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:19:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=N1zdBv1pigsCLFCiWPhNrw29SmcHv+LhOugzmKUJsg0xaDKMG7xJvj1o89CFEDlzbobCzRjf1uFoAcTeu4ZtOz7TE53hqX+nMtGvL25MsV4Yu51tFlW1bEYb27qnw7Ftjx1lIwIgqy6C4bRGIhLzjDu2sCbG9/Y/ZeDZGJDv4q4=
Message-Id: <7b16d9ac49670e27c1c995b21d8108c899eba712.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Fri, 18 Apr 2008 00:25:18 -0400
Subject: [PATCH 36/37] Input: i8042 - fix incorrect usage of strncpy and strncat
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Roel Kluin <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect length argument for strncpy and strncat by replacing them with
strlcpy and strlcat

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/serio/i8042-x86ia64io.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 60931ac..5ece9f5 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -370,10 +370,10 @@ static int i8042_pnp_kbd_probe(struct pnp_dev *dev, const struct pnp_device_id *
 	if (pnp_irq_valid(dev,0))
 		i8042_pnp_kbd_irq = pnp_irq(dev, 0);
 
-	strncpy(i8042_pnp_kbd_name, did->id, sizeof(i8042_pnp_kbd_name));
+	strlcpy(i8042_pnp_kbd_name, did->id, sizeof(i8042_pnp_kbd_name));
 	if (strlen(pnp_dev_name(dev))) {
-		strncat(i8042_pnp_kbd_name, ":", sizeof(i8042_pnp_kbd_name));
-		strncat(i8042_pnp_kbd_name, pnp_dev_name(dev), sizeof(i8042_pnp_kbd_name));
+		strlcat(i8042_pnp_kbd_name, ":", sizeof(i8042_pnp_kbd_name));
+		strlcat(i8042_pnp_kbd_name, pnp_dev_name(dev), sizeof(i8042_pnp_kbd_name));
 	}
 
 	i8042_pnp_kbd_devices++;
@@ -391,10 +391,10 @@ static int i8042_pnp_aux_probe(struct pnp_dev *dev, const struct pnp_device_id *
 	if (pnp_irq_valid(dev, 0))
 		i8042_pnp_aux_irq = pnp_irq(dev, 0);
 
-	strncpy(i8042_pnp_aux_name, did->id, sizeof(i8042_pnp_aux_name));
+	strlcpy(i8042_pnp_aux_name, did->id, sizeof(i8042_pnp_aux_name));
 	if (strlen(pnp_dev_name(dev))) {
-		strncat(i8042_pnp_aux_name, ":", sizeof(i8042_pnp_aux_name));
-		strncat(i8042_pnp_aux_name, pnp_dev_name(dev), sizeof(i8042_pnp_aux_name));
+		strlcat(i8042_pnp_aux_name, ":", sizeof(i8042_pnp_aux_name));
+		strlcat(i8042_pnp_aux_name, pnp_dev_name(dev), sizeof(i8042_pnp_aux_name));
 	}
 
 	i8042_pnp_aux_devices++;
-- 
1.5.5.rc2.6.gf58d


