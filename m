Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778Ab0ALMhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab0ALMhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 07:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299Ab0ALMhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 07:37:17 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:38172 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab0ALMhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 07:37:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=FmsoHGUrXqwtOTKecTLuWbb6Ze8D/J7tFrzlxMv01iyYrX/HXe3NGYj8K7kiQx9rSx
         itUQxhYYmllWaU7wjHfMARB9ZiZfyIZPwA89gTHIriyqrA92Qfl1fvzytiDu+2k6rYkx
         NAB9ZDuG/hXdTRfJLsgbttzHW2zdklOmnqOsk=
Subject: [PATCH] drivers/acpi/power_meter.c : remove double kfree()
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: djwong@us.ibm.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jan 2010 23:37:07 +1100
Message-ID: <1263299827.4571.11.camel@ICE-BOX>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resource->domain_devices can be double kfree()'d in a couple of places.
Fix this by setting num_domain_devices = 0 after the kfree().

Coverity CID: 13356, 13355, 13354

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com> 

diff --git drivers/acpi/power_meter.c drivers/acpi/power_meter.c
index 2ef7030..18ce00a 100644
--- drivers/acpi/power_meter.c
+++ drivers/acpi/power_meter.c
@@ -534,6 +534,7 @@ static void remove_domain_devices(struct acpi_power_meter_resource *resource)
 
 	kfree(resource->domain_devices);
 	kobject_put(resource->holders_dir);
+	resource->num_domain_devices = 0;
 }
 
 static int read_domain_devices(struct acpi_power_meter_resource *resource)
@@ -740,7 +741,6 @@ skip_unsafe_cap:
 
 	return res;
 error:
-	remove_domain_devices(resource);
 	remove_attrs(resource);
 	return res;
 }


