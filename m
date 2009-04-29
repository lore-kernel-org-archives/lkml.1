Return-Path: <linux-kernel-owner+w=401wt.eu-S1758911AbZD2TWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbZD2TWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbZD2TWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:22:15 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50791 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZD2TWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:22:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=d0WCMqI/HQZx/JLPJJ/0/Kh262n2PDI6E/LvenmKSRKiQg+iiuluLBiPFKUWr49QrP
         oeinaHquZ3/rWdMbZiFoE0OMcc7nENBGJcTse4eIDVA+2iozHsBrq6eKKQJzuNhe7TuE
         ljOv7f2tQ4dH/wJpthWXlhw73EtSPmfNgdA7E=
Date: Wed, 29 Apr 2009 21:22:55 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>
Subject: [PATCH] asus_atk0110: fix compiler warning
Message-ID: <20090429192255.GA8623@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atk_sensor_type is only used when DEBUG is defined.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>

---
Jean can you pick this up?

 drivers/hwmon/asus_atk0110.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
index 0897ede..bff0103 100644
--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -348,6 +348,7 @@ static int validate_hwmon_pack(struct atk_data *data, union acpi_object *obj)
 	return 0;
 }
 
+#ifdef DEBUG
 static char const *atk_sensor_type(union acpi_object *flags)
 {
 	u64 type = flags->integer.value & ATK_TYPE_MASK;
@@ -370,6 +371,7 @@ static char const *atk_sensor_type(union acpi_object *flags)
 
 	return what;
 }
+#endif
 
 static void atk_print_sensor(struct atk_data *data, union acpi_object *obj)
 {


Luca
-- 
Se il  destino di un uomo  e` annegare, anneghera` anche  in un bicchier
d'acqua.
Proverbio yddish
