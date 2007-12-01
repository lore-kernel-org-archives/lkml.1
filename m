Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbXLAPnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbXLAPnG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 10:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbXLAPmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 10:42:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:39158 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbXLAPms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 10:42:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=MNN/sxErVcqfL1+FBEeY412MO/7PkefIijd9H3ZXo0CW03GeDHVho3tgVPqoj9tXGgkaS6Ps0y1cN4xYtCSdSpMWk4Fj+vqbYJzE/xGxWsDZFfVQwYLyZFZwNqv3vOeIYRKpI+bSx0rvkzUiiLxSIRYVqOh9/HbCM5PF4V8CpZw=
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] acpi: remove duplicated warning message
Date: Sat, 1 Dec 2007 16:42:51 +0100
User-Agent: KMail/1.9.7
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712011642.52165.mboton@gmail.com>
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated warning message in acpi_power_transition()

This warning message is printed by acpi_bus_set_power() so we don't
need to print it again.

Signed-off-by: Miguel Botón <mboton@gmail.com>

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index af1769a..b4af974 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -458,11 +458,9 @@ int acpi_power_transition(struct acpi_device *device, int state)
 	}
 
      end:
-	if (result) {
+	if (result) 
 		device->power.state = ACPI_STATE_UNKNOWN;
-		printk(KERN_WARNING PREFIX "Transitioning device [%s] to D%d\n",
-			      device->pnp.bus_id, state);
-	} else {
+	else {
 	/* We shouldn't change the state till all above operations succeed */
 		device->power.state = state;
 	}


-- 
	Miguel Botón
