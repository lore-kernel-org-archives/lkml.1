Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbZKYKF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbZKYKF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 05:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758329AbZKYKF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 05:05:57 -0500
Received: from smtp.nokia.com ([192.100.122.233]:19380 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551AbZKYKFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:05:53 -0500
From: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
To: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Cc: peter.de-schrijver@nokia.com, eduardo.valentin@nokia.com,
       ext-juha.1.keski-saari@nokia.com
Subject: [PATCHv2 2/3] Reset REMAP configuration in regulator probe
Date: Wed, 25 Nov 2009 12:04:54 +0200
Message-Id: <1259143495-9480-3-git-send-email-ext-juha.1.keski-saari@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1259143495-9480-1-git-send-email-ext-juha.1.keski-saari@nokia.com>
References: <1259143495-9480-1-git-send-email-ext-juha.1.keski-saari@nokia.com>
X-OriginalArrivalTime: 25 Nov 2009 10:05:05.0730 (UTC) FILETIME=[C30C0220:01CA6DB6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the probe recover the regulator REMAP configuration into
the state it is on reset to make sure the RegFW has proper control over
the regulator states

Signed-off-by: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
---
 drivers/regulator/twl4030-regulator.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl4030-regulator.c
index 75da6af..7029fb9 100644
--- a/drivers/regulator/twl4030-regulator.c
+++ b/drivers/regulator/twl4030-regulator.c
@@ -420,6 +420,13 @@ static struct twlreg_info twl4030_regs[] = {
 	/* VUSBCP is managed *only* by the USB subchip */
 };
 
+static const u8 REG_REMAP_table[] = {
+	0x08, 0x08, 0x08, 0x08, 0x00, 0x08, 0x08,
+	0x08, 0x00, 0x08, 0x08, 0x08, 0x08, 0x08,
+	0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08,
+	0x08,
+};
+
 static int twl4030reg_probe(struct platform_device *pdev)
 {
 	int				i;
@@ -458,6 +465,8 @@ static int twl4030reg_probe(struct platform_device *pdev)
 	}
 	platform_set_drvdata(pdev, rdev);
 
+       twl4030reg_write(info, VREG_REMAP, REG_REMAP_table[pdev->id]);
+
 	/* NOTE:  many regulators support short-circuit IRQs (presentable
 	 * as REGULATOR_OVER_CURRENT notifications?) configured via:
 	 *  - SC_CONFIG
-- 
1.6.3.3

