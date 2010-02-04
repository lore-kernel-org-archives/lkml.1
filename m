Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab0BDLdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 06:33:53 -0500
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:56620 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756407Ab0BDLdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 06:33:51 -0500
Subject: [PATCH] staging wlan-ng: fix to allow driver to be built on
 2.6.33-rc6
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: lkml <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 11:33:49 +0000
Message-ID: <1265283229.2175.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the re-factoring of wext in commit
3d23e349d807177eaf519d444677cee86b1a04cf
    
WIRELESS_EXT must now be selected in Kconfig to allow this driver to be
built.
    
Also remove iw_handle_def private initialisations as they are no longer
need these.
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

----
Hi Greg,
I hadn't built this driver for a while & just noticed that it doesn't
built on 2.6.33-rc6.
Here's a minimal fix to at least get it going.

I didn't add the WEXT_SPY support as I've never used it & don't really
know how to test it. But if someone needs it, I can give it a try.

patch against 2.6.33-rc6 
Tested on fedora, and with the fix the card in my laptop works :)

regards
Richard
  



diff --git a/drivers/staging/wlan-ng/Kconfig b/drivers/staging/wlan-ng/Kconfig
index f44294b..41c9fda 100644
--- a/drivers/staging/wlan-ng/Kconfig
+++ b/drivers/staging/wlan-ng/Kconfig
@@ -1,6 +1,7 @@
 config PRISM2_USB
-	tristate "Prism2.5/3 USB driver"
-	depends on WLAN && USB && WIRELESS_EXT
+	tristate "Prism2.5/3 WLAN USB driver"
+	depends on WLAN && USB
+	select WIRELESS_EXT
 	default n
 	---help---
 	  This is the wlan-ng prism 2.5/3 USB driver for a wide range of
diff --git a/drivers/staging/wlan-ng/p80211wext.c b/drivers/staging/wlan-ng/p80211wext.c
index 74d8022..8f17dfb 100644
--- a/drivers/staging/wlan-ng/p80211wext.c
+++ b/drivers/staging/wlan-ng/p80211wext.c
@@ -1729,11 +1729,7 @@ static iw_handler p80211wext_handlers[] = {
 
 struct iw_handler_def p80211wext_handler_def = {
 	.num_standard = ARRAY_SIZE(p80211wext_handlers),
-	.num_private = 0,
-	.num_private_args = 0,
 	.standard = p80211wext_handlers,
-	.private = NULL,
-	.private_args = NULL,
 	.get_wireless_stats = p80211wext_get_wireless_stats
 };
 


