Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbZJBNoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbZJBNoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 09:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbZJBNoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 09:44:37 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:32599 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877AbZJBNo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 09:44:29 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4AC602E8.6060005@tremplin-utc.net>
Date: Fri, 02 Oct 2009 15:40:56 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20090830 Mandriva/2.0.0.23-2mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Pavel Herrmann <morpheus.ibis@gmail.com>
Subject: [PATCH 1/3] lis3: Better support for hp 6730x
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Herrmann <morpheus.ibis@gmail.com>

I have learned that the 6730b and 6730s have different accelerometer
orientation, and have modified the driver accordingly (diff attached), while
dropping the wild guess for AMD based 6735 having the same orientation as
Intel based 6730 (this is not true for any other related series/family, thus
is not probable for 673x).

Signed-off-by: Pavel Herrmann <morpheus.ibis@gmail.com>
Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/hp_accel.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index 6679854..2d3f95c 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -197,7 +197,8 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 	AXIS_DMI_MATCH("HP2133", "HP 2133", xy_rotated_left),
 	AXIS_DMI_MATCH("HP2140", "HP 2140", xy_swap_inverted),
 	AXIS_DMI_MATCH("NC653x", "HP Compaq 653", xy_rotated_left_usd),
-	AXIS_DMI_MATCH("NC673x", "HP Compaq 673", xy_rotated_left_usd),
+	AXIS_DMI_MATCH("NC6730b", "HP Compaq 6730b", xy_rotated_left_usd),
+	AXIS_DMI_MATCH("NC6730s", "HP Compaq 6730s", xy_swap),
 	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
 	AXIS_DMI_MATCH("NC6710x", "HP Compaq 6710", xy_swap_yz_inverted),
 	AXIS_DMI_MATCH("NC6715x", "HP Compaq 6715", y_inverted),
-- 
1.6.4.4


