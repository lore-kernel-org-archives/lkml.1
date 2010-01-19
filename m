Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189Ab0ASTy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab0ASTy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 14:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398Ab0ASTy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 14:54:56 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46079 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab0ASTyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 14:54:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=XlWVQhkDkIm7RSSl2rqmdV2r4g7oI7xSJqNxKcazh+geOVuCuu7kcO/9fAboM6DFHQ
         0DOGKPMqmXOcOr1MwaDENhfxUZy2SvN1rUCfGteK9+GA21AIYRQk/pePkH1T+veRuxhX
         xk6dk1c08pbEHeUFRw6qPttVNrqtY0aLPQOBE=
Message-ID: <4B560F33.1080805@gmail.com>
Date: Tue, 19 Jan 2010 20:59:47 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       ibm-acpi-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] thinkpad-acpi: wrong thermal attribute_group removed in thermal_exit()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_remove_group() removed the wrong attribute_group for 
thermal_read_mode TPEC_8, ACPI_TMP07 and ACPI_UPDT

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Was this maybe intended? otherwise in case TPACPI_THERMAL_TPEC_16:
the same code is executed. Please review.

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index e67e4fe..eb603f1 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -5771,7 +5771,7 @@ static void thermal_exit(void)
 	case TPACPI_THERMAL_ACPI_TMP07:
 	case TPACPI_THERMAL_ACPI_UPDT:
 		sysfs_remove_group(&tpacpi_sensors_pdev->dev.kobj,
-				   &thermal_temp_input16_group);
+				   &thermal_temp_input8_group);
 		break;
 	case TPACPI_THERMAL_NONE:
 	default:
