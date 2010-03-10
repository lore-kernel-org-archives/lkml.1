Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab0CJAaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 19:30:05 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:61585 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab0CJAaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 19:30:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc
         :content-type;
        b=iPhhDQKP4VIOADaIoJ45I2Z/FTNwiNxoO259wOIDfkRq5srb24AlpOrcJY6aI9qQBn
         SpavXiCRy8xWwbjbbLHYWeEW0lD5DvSEokyIZrHRAiSbbWXKBGc/8aH4R4QzMuj6b5g2
         p99b/kB+xE3NiJO/HkOhd1493mys2YN8it4I8=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
From: axel lin <axel.lin@gmail.com>
Date: Wed, 10 Mar 2010 08:29:40 +0800
Message-ID: <427d64721003091629s4c5728b4y9005feeef9a05b7e@mail.gmail.com>
Subject: [PATCH] Regulators: lp3971 - Fix setting val for LDO2 and LDO4
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>, lrg@slimlogic.co.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 9 Mar 2010 16:53:59 +0800
Subject: [PATCH] lp3971: Fix setting val for LDO2 and LDO4

In lp3971_ldo_set_voltage function, it requires val to left shift 4
bits for LDO2 and LDO4.
This patch fix this issue.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/lp3971.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index f5532ed..a28ae37 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -187,7 +187,8 @@ static int lp3971_ldo_set_voltage(struct regulator_dev *dev,
                return -EINVAL;

        return lp3971_set_bits(lp3971, LP3971_LDO_VOL_CONTR_REG(ldo),
-               LDO_VOL_CONTR_MASK << LDO_VOL_CONTR_SHIFT(ldo), val);
+               LDO_VOL_CONTR_MASK << LDO_VOL_CONTR_SHIFT(ldo),
+               val << LDO_VOL_CONTR_SHIFT(ldo));
 }

 static struct regulator_ops lp3971_ldo_ops = {
--
1.5.4.3
