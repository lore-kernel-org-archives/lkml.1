Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbZBGAsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbZBGAsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 19:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZBGAsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 19:48:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:42880 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbZBGAsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 19:48:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hjuoxEM63R0VDQZVL7CLwXmZhgQSaBcImAcJCR9AmnpCUxbijH7VR3aj11ZtekRReF
         bRWeWJtzab7U0wlmgiL2qyMIeOG2F19SctcuPXKzpzWF/K59E4bqvbXwfvIbpmS5VCmj
         3K/n69ly4YIzHTQHCOuBsR25rNCzkbzT9694o=
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Cc: <linux-kernel@vger.kernel.org>,
       Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Subject: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
Date: Sat,  7 Feb 2009 01:48:01 +0100
Message-Id: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>
X-Mailer: git-send-email 1.6.1.399.g0d272
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for HP Pavlion dv5 models, whose sensor has an inverted x
axis.

Signed-off-by: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
---
My HP Pavilion dv5 has an inverted x axis of the accelerometer, so this
patch marks the inversion for all the dv5. I can include the full
dmidecode output if this is deemed necessary.

With the laptop standing still on my desk jstest reports X and Y values
fluctuating from -8k to +8k (more or less). I assume this is normal?

 drivers/hwmon/hp_accel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index abf4dfc..5a379bd 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -179,6 +179,7 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 	AXIS_DMI_MATCH("NC673x", "HP Compaq 673", xy_rotated_left_usd),
 	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
 	AXIS_DMI_MATCH("NC671xx", "HP Compaq 671", xy_swap_yz_inverted),
+	AXIS_DMI_MATCH("HPDV5", "HP Pavilion dv5", x_inverted),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"
-- 
1.6.1.399.g0d272

