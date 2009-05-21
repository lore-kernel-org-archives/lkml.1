Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbZEULiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbZEULiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 07:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZEULiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 07:38:16 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:28952 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbZEULiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 07:38:16 -0400
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4A153D25.8050907@tremplin-utc.net>
Date: Thu, 21 May 2009 13:38:13 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Isaac702 <isaac702@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Christian Weidle <slateroni@gmail.com>,
       Pavel Herrmann <morpheus.ibis@gmail.com>
Subject: Re: [PATCH 4/4] lis3: Add three new laptop models
References: <4A151E9F.1080405@tremplin-utc.net>	 <4A151FFF.70406@tremplin-utc.net> <20090521104952.GB2637@elf.ucw.cz>	 <4A1535FB.9000909@tremplin-utc.net> <36a8c4f10905210424i65f5efadjdd6f13dea77cb2e6@mail.gmail.com>
In-Reply-To: <36a8c4f10905210424i65f5efadjdd6f13dea77cb2e6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 21-05-09 13:24, Isaac702 schreef:
> I apologize however when I reported that I was still using the 6710
> settings. When the normal axis settings were used the results showed the
> 6715 should be using "y_inverted" to behave normally.
> I'm sorry for reporting this incorrectly in the beginning.
> 
Thank you for noticing this so quickly. Here is an updated patch.

Eric

==

Separate the 6710 and 6715, and set the right axis information for the
6715.
Reported-by: Isaac702 <isaac702@gmail.com>

Add the 6930.
Reported-by: Christian Weidle <slateroni@gmail.com>

Add the 2710.
Reported-by: Pavel Herrmann <morpheus.ibis@gmail.com>

Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/hp_accel.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index 92db68e..6679854 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -158,6 +158,7 @@ static struct axis_conversion lis3lv02d_axis_normal = {1, 2, 3};
 static struct axis_conversion lis3lv02d_axis_y_inverted = {1, -2, 3};
 static struct axis_conversion lis3lv02d_axis_x_inverted = {-1, 2, 3};
 static struct axis_conversion lis3lv02d_axis_z_inverted = {1, 2, -3};
+static struct axis_conversion lis3lv02d_axis_xy_swap = {2, 1, 3};
 static struct axis_conversion lis3lv02d_axis_xy_rotated_left = {-2, 1, 3};
 static struct axis_conversion lis3lv02d_axis_xy_rotated_left_usd = {-2, 1, -3};
 static struct axis_conversion lis3lv02d_axis_xy_swap_inverted = {-2, -1, 3};
@@ -191,13 +192,16 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 	AXIS_DMI_MATCH("NX9420", "HP Compaq nx9420", x_inverted),
 	AXIS_DMI_MATCH("NW9440", "HP Compaq nw9440", x_inverted),
 	AXIS_DMI_MATCH("NC2510", "HP Compaq 2510", y_inverted),
+	AXIS_DMI_MATCH("NC2710", "HP Compaq 2710", xy_swap),
 	AXIS_DMI_MATCH("NC8510", "HP Compaq 8510", xy_swap_inverted),
 	AXIS_DMI_MATCH("HP2133", "HP 2133", xy_rotated_left),
 	AXIS_DMI_MATCH("HP2140", "HP 2140", xy_swap_inverted),
 	AXIS_DMI_MATCH("NC653x", "HP Compaq 653", xy_rotated_left_usd),
 	AXIS_DMI_MATCH("NC673x", "HP Compaq 673", xy_rotated_left_usd),
 	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
-	AXIS_DMI_MATCH("NC671xx", "HP Compaq 671", xy_swap_yz_inverted),
+	AXIS_DMI_MATCH("NC6710x", "HP Compaq 6710", xy_swap_yz_inverted),
+	AXIS_DMI_MATCH("NC6715x", "HP Compaq 6715", y_inverted),
+	AXIS_DMI_MATCH("NC693xx", "HP EliteBook 693", xy_rotated_right),
 	/* Intel-based HP Pavilion dv5 */
 	AXIS_DMI_MATCH2("HPDV5_I",
 			PRODUCT_NAME, "HP Pavilion dv5",
@@ -213,7 +217,6 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"
- * HP Compaq 8710x Notebook PC / Mobile Workstation
  * "NC2400" "HP Compaq nc2400"
  * "NX74x0" "HP Compaq nx74"
  * "NX6325" "HP Compaq nx6325"
-- 
1.6.2.4


