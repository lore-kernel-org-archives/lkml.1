Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbZISHnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbZISHnD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 03:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbZISHnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 03:43:00 -0400
Received: from nickg.me.uk ([78.47.77.182]:56254 "EHLO nickg.me.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbZISHnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 03:43:00 -0400
X-Greylist: delayed 1640 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Sep 2009 03:42:59 EDT
Message-ID: <4AB48658.2080709@nickg.me.uk>
Date: Sat, 19 Sep 2009 08:20:56 +0100
From: Nick Gasson <nick@nickg.me.uk>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: dmitry.torokhov@gmail.com
X-SA-Exim-Connect-IP: 78.143.208.249
X-SA-Exim-Mail-From: nick@nickg.me.uk
Subject: [PATCH] Fix fn-key release events for Samsung Q320 laptop
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on nickg.me.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a workaround for the missing fn-key release
events on Samsung Q320 and similar laptops.

Tested extensively on my own laptop.

Signed-off-by: Nick Gasson <nick@nickg.me.uk>
---
  drivers/input/keyboard/atkbd.c |    9 +++++++++
  1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index c9523e4..56a6ffa 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1630,6 +1630,15 @@ static struct dmi_system_id atkbd_dmi_quirk_table[] __initdata = {
                 .driver_data = atkbd_samsung_forced_release_keys,
         },
         {
+               .ident = "Samsung Q320/P320",
+               .matches = {
+                       DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "Q320/P320"),
+               },
+               .callback = atkbd_setup_forced_release,
+               .driver_data = atkbd_samsung_forced_release_keys,
+       },
+       {
                 .ident = "Samsung SQ45S70S",
                 .matches = {
                         DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
-- 
1.6.4.1

