Return-Path: <linux-kernel-owner+w=401wt.eu-S1760991AbXKQLCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991AbXKQLCI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 06:02:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbXKQLB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 06:01:56 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:50309 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbXKQLBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 06:01:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=aGh+kGTh+Rtvqb24hqGbVyx9QBatZuhE+ccDI9ganfv1lQ/e1HAqRuxikwm+YW865FT0+bvV7BVD3eHA63zger51n4WLYGtmKFIfwiLrpE9lAp1+zYQYI7PaxJqQnoiV33HnaoWhLDB2WpYJ9pM6N9UVqSGCG2h8NeUqWw8nvEQ=
Date: Sat, 17 Nov 2007 19:55:58 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] power: use kasprintf
Message-ID: <20071117105558.GA4861@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
	David Woodhouse <dwmw2@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use kasprintf instead of kmalloc()-strcpy()-strcat().

Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 drivers/power/power_supply_leds.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

Index: 2.6-mm/drivers/power/power_supply_leds.c
===================================================================
--- 2.6-mm.orig/drivers/power/power_supply_leds.c
+++ 2.6-mm/drivers/power/power_supply_leds.c
@@ -10,6 +10,7 @@
  *  You may use this code as per GPL version 2
  */
 
+#include <linux/kernel.h>
 #include <linux/power_supply.h>
 
 #include "power_supply.h"
@@ -48,28 +49,20 @@ static int power_supply_create_bat_trigg
 {
 	int rc = 0;
 
-	psy->charging_full_trig_name = kmalloc(strlen(psy->name) +
-				  sizeof("-charging-or-full"), GFP_KERNEL);
+	psy->charging_full_trig_name = kasprintf(GFP_KERNEL,
+					"%s-charging-or-full", psy->name);
 	if (!psy->charging_full_trig_name)
 		goto charging_full_failed;
 
-	psy->charging_trig_name = kmalloc(strlen(psy->name) +
-					  sizeof("-charging"), GFP_KERNEL);
+	psy->charging_trig_name = kasprintf(GFP_KERNEL,
+					"%s-charging", psy->name);
 	if (!psy->charging_trig_name)
 		goto charging_failed;
 
-	psy->full_trig_name = kmalloc(strlen(psy->name) +
-				      sizeof("-full"), GFP_KERNEL);
+	psy->full_trig_name = kasprintf(GFP_KERNEL, "%s-full", psy->name);
 	if (!psy->full_trig_name)
 		goto full_failed;
 
-	strcpy(psy->charging_full_trig_name, psy->name);
-	strcat(psy->charging_full_trig_name, "-charging-or-full");
-	strcpy(psy->charging_trig_name, psy->name);
-	strcat(psy->charging_trig_name, "-charging");
-	strcpy(psy->full_trig_name, psy->name);
-	strcat(psy->full_trig_name, "-full");
-
 	led_trigger_register_simple(psy->charging_full_trig_name,
 				    &psy->charging_full_trig);
 	led_trigger_register_simple(psy->charging_trig_name,
@@ -120,14 +113,10 @@ static int power_supply_create_gen_trigg
 {
 	int rc = 0;
 
-	psy->online_trig_name = kmalloc(strlen(psy->name) + sizeof("-online"),
-					GFP_KERNEL);
+	psy->online_trig_name = kasprintf(GFP_KERNEL, "%s-online", psy->name);
 	if (!psy->online_trig_name)
 		goto online_failed;
 
-	strcpy(psy->online_trig_name, psy->name);
-	strcat(psy->online_trig_name, "-online");
-
 	led_trigger_register_simple(psy->online_trig_name, &psy->online_trig);
 
 	goto success;
