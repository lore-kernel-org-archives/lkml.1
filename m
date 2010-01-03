Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988Ab0ACR3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab0ACR3n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 12:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898Ab0ACR3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 12:29:43 -0500
Received: from mail.perches.com ([173.55.12.10]:1481 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab0ACR3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 12:29:42 -0500
Subject: [PATCH] mach-osiris-dvs.c: Convert boolean bit tests to logical
 tests
From: Joe Perches <joe@perches.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 03 Jan 2010 09:29:41 -0800
Message-ID: <1262539781.1932.128.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bit tests on booleans seem odd, logical tests more appropriate

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/arch/arm/mach-s3c2440/mach-osiris-dvs.c b/arch/arm/mach-s3c2440/mach-osiris-dvs.c
index ad2792d..2367606 100644
--- a/arch/arm/mach-s3c2440/mach-osiris-dvs.c
+++ b/arch/arm/mach-s3c2440/mach-osiris-dvs.c
@@ -69,16 +69,14 @@ static int osiris_dvs_notify(struct notifier_block *nb,
 
 	switch (val) {
 	case CPUFREQ_PRECHANGE:
-		if (old_dvs & !new_dvs ||
-		    cur_dvs & !new_dvs) {
+		if ((old_dvs && !new_dvs) || (cur_dvs && !new_dvs)) {
 			pr_debug("%s: exiting dvs\n", __func__);
 			cur_dvs = false;
 			gpio_set_value(OSIRIS_GPIO_DVS, 1);
 		}
 		break;
 	case CPUFREQ_POSTCHANGE:
-		if (!old_dvs & new_dvs ||
-		    !cur_dvs & new_dvs) {
+		if ((!old_dvs && new_dvs) || (!cur_dvs && new_dvs)) {
 			pr_debug("entering dvs\n");
 			cur_dvs = true;
 			gpio_set_value(OSIRIS_GPIO_DVS, 0);


