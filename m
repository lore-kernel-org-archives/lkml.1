Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbZJUMAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbZJUMAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 08:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZJUMAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 08:00:53 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:44300 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbZJUMAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 08:00:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=e06k/jgeS5rrOJFFpPRBWwE7koVybHtUXGNbBsNQogHsVZtI2oEV/llZMnoUvrY41E
         dZqDdNvpp59q6eog4TiU24hduBvGypo1F8gIo99GpD7XWSGvxmUOptRxrPfm0ilvF/bt
         kbveiEK3cpbbFY+eGqegshdN8MaVn3JWl0q9E=
Message-ID: <4ADEFA54.1090005@gmail.com>
Date: Wed, 21 Oct 2009 14:11:00 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, amit.kucheria@verdurent.com,
       sameo@linux.intel.com, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mfd: fix check on unsigned in twl4030_configure_resource()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct twl4030_resconfig members devgroup, type and type2 are
unsigned.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
`git grep devgroup' and notice that these are initialized to -1 in
arch/arm/mach-omap2/board-rx51-peripherals.c:383-397

Is this the right fix?

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index d423e0c..cc984a5 100644
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
@@ -355,12 +355,12 @@ static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
 		return err;
 	}
 
-	if (rconfig->type >= 0) {
+	if (rconfig->type != -1) {
 		type &= ~TYPE_MASK;
 		type |= rconfig->type << TYPE_SHIFT;
 	}
 
-	if (rconfig->type2 >= 0) {
+	if (rconfig->type2 != -1) {
 		type &= ~TYPE2_MASK;
 		type |= rconfig->type2 << TYPE2_SHIFT;
 	}
