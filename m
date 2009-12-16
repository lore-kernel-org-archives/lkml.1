Return-Path: <linux-kernel-owner+w=401wt.eu-S933970AbZLPNkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970AbZLPNkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 08:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933861AbZLPNkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 08:40:06 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:65213 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933851AbZLPNkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 08:40:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=gbFxxO+TLYJJWk12Phlov94Nipclq5C+n+my1zE7IC57fEL4dZxxZBNIe/XKy3LETM
         km/VaUhGBC7roZaco6TPzI0R9+Gsi5hg1k7NG8sNB3yyhfaOlaKv+7dnGGgF76y/7J2L
         9MK4lrv1JDAc1N6WWwYDRLgb5148Pnmm0QMHU=
Message-ID: <4B28E3A4.1010601@gmail.com>
Date: Wed, 16 Dec 2009 14:41:56 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, amit.kucheria@verdurent.com
Subject: [PATCH] mfd: Fix test of unsigned in twl4030_configure_resource()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devgroup is unsigned so the test did not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

see
vi arch/arm/mach-omap2/board-rx51-peripherals.c +512

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index d423e0c..f207e28 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -335,7 +335,7 @@ static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
 		return err;
 	}
 
-	if (rconfig->devgroup >= 0) {
+	if (rconfig->devgroup != -1) {
 		grp &= ~DEVGROUP_MASK;
 		grp |= rconfig->devgroup << DEVGROUP_SHIFT;
 		err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
