Return-Path: <linux-kernel-owner+w=401wt.eu-S1751328AbXBZQMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbXBZQMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbXBZQMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:12:35 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:60118 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbXBZQMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:12:34 -0500
X-Sasl-enc: W7WlQ5qe1697BezYwCUpZy8FBxP1c8zWyVHG4MdLQ4Vc 1172506337
Date: Mon, 26 Feb 2007 13:12:03 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI: ibm-acpi: improve backlight power handling
Message-ID: <20070226161203.GD2909@khazad-dum.debian.net>
References: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz> <1172490091.5824.30.camel@localhost.localdomain> <Pine.LNX.4.64.0702261329270.10496@twin.jikos.cz> <20070226142157.GA2909@khazad-dum.debian.net> <1172501357.5824.91.camel@localhost.localdomain> <20070226152035.GB2909@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226152035.GB2909@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the backlight code to emulate as much as possible the power
management events, as we are unable to really power on or power off the
backlight.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Richard Purdie <rpurdie@rpsys.net>
---

 Status: waiting ACK from Richard Purdie <rpurdie@rpsys.net>

 drivers/acpi/ibm_acpi.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/ibm_acpi.c b/drivers/acpi/ibm_acpi.c
index e7309a6..cb5885e 100644
--- a/drivers/acpi/ibm_acpi.c
+++ b/drivers/acpi/ibm_acpi.c
@@ -86,6 +86,7 @@
 
 #include <linux/proc_fs.h>
 #include <linux/backlight.h>
+#include <linux/fb.h>
 #include <asm/uaccess.h>
 
 #include <linux/dmi.h>
@@ -1707,7 +1708,8 @@ static int brightness_write(char *buf)
 
 static int brightness_update_status(struct backlight_device *bd)
 {
-	return brightness_set(bd->props.brightness);
+	return brightness_set((bd->props.fb_blank == FB_BLANK_UNBLANK)? 
+				bd->props.brightness : 0);
 }
 
 static struct backlight_ops ibm_backlight_data = {
-- 
1.5.0.1

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
