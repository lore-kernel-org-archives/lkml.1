Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab0CIJPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 04:15:17 -0500
Received: from mail-px0-f188.google.com ([209.85.216.188]:57594 "EHLO
	mail-px0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab0CIJPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 04:15:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:content-type;
        b=LDCXxN5O+2R0idRI+8+B2D4LFZZvfupprOp+75eXEol4L9trh/lT1bGvSH3MQ7sWOI
         qlSIlMTDi0G1+t7Ay89c39+7MafuB8/0/UI0Wp786qt+3qx6KL3GQmb+BTkHMDTMo4z7
         Ea362dPSbFCSaGB2Hc1sCvQQLzRmklrgd+2GY=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
From: axel lin <axel.lin@gmail.com>
Date: Tue, 9 Mar 2010 17:14:53 +0800
Message-ID: <427d64721003090114u5419e36dl23616cfa0afd3cde@mail.gmail.com>
Subject: [PATCH] Regulators: lp3971 - Fix setting val for LDO2 and LDO4
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4e4c5f8267a4fbf651b4cc26c5f72465514f6224 Mon Sep 17 00:00:00 2001
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 9 Mar 2010 16:53:59 +0800
Subject: [PATCH] lp3971: Fix setting val for LDO2 and LDO4

In lp3971_ldo_set_voltage function, it requires val to left shift 4
bits for LDO2 and LDO4.
This patch fix this issue.
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
