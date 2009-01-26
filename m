Return-Path: <linux-kernel-owner+w=401wt.eu-S1751887AbZAZAVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbZAZAVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 19:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZAZAVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 19:21:17 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:11430 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZAZAVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 19:21:16 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <497D01F9.30702@tremplin-utc.net>
Date: Mon, 26 Jan 2009 01:21:13 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Martin Kebert <gkmarty@gmail.com>
Subject: [PATCH 4/4] lis3lv02d: add axes knowledge for HP 6710
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Kebert <gkmarty@gmail.com>

Add support for the HP laptops of model 6710x for having correctly setup
axes.
Signed-off-by: Martin Kebert <gkmarty@gmail.com>
Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/hp_accel.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index 0eb53d2..abf4dfc 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -156,6 +156,7 @@ static struct axis_conversion lis3lv02d_axis_xy_rotated_left = {-2, 1, 3};
 static struct axis_conversion lis3lv02d_axis_xy_rotated_left_usd = {-2, 1, -3};
 static struct axis_conversion lis3lv02d_axis_xy_swap_inverted = {-2, -1, 3};
 static struct axis_conversion lis3lv02d_axis_xy_rotated_right = {2, -1, 3};
+static struct axis_conversion lis3lv02d_axis_xy_swap_yz_inverted = {2, -1, -3};
 
 #define AXIS_DMI_MATCH(_ident, _name, _axis) {		\
 	.ident = _ident,				\
@@ -177,9 +178,9 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 	AXIS_DMI_MATCH("NC653x", "HP Compaq 653", xy_rotated_left_usd),
 	AXIS_DMI_MATCH("NC673x", "HP Compaq 673", xy_rotated_left_usd),
 	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
+	AXIS_DMI_MATCH("NC671xx", "HP Compaq 671", xy_swap_yz_inverted),
 	{ NULL, }
 /* Laptop models without axis info (yet):
- * "NC671xx" "HP Compaq 671"
  * "NC6910" "HP Compaq 6910"
  * HP Compaq 8710x Notebook PC / Mobile Workstation
  * "NC2400" "HP Compaq nc2400"
-- 
1.6.1


