Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbZKYKaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbZKYKaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 05:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758501AbZKYKa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 05:30:29 -0500
Received: from smtp.nokia.com ([192.100.122.233]:21390 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZKYKa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:30:28 -0500
Subject: Re: [PATCHv2 3/3] Define critical regulators as always_on
From: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
In-Reply-To: <20091125101407.GA17420@opensource.wolfsonmicro.com>
References: <1259143495-9480-1-git-send-email-ext-juha.1.keski-saari@nokia.com>
	 <1259143495-9480-4-git-send-email-ext-juha.1.keski-saari@nokia.com>
	 <20091125101407.GA17420@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 12:29:59 +0200
Message-ID: <1259144999.10122.3.camel@keskisaa-workstation>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Nov 2009 10:30:03.0933 (UTC) FILETIME=[400BA4D0:01CA6DBA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 11:14 +0100, ext Mark Brown wrote:
> On Wed, Nov 25, 2009 at 12:04:55PM +0200, Juha Keski-Saari wrote:
> 
> > +	if (pdev->id == TWL4030_REG_VIO ||
> > +		pdev->id == TWL4030_REG_VDD1 ||
> > +		pdev->id == TWL4030_REG_VDD2 ||
> > +		pdev->id == TWL4030_REG_VPLL1 ||
> > +		pdev->id == TWL4030_REG_VINTANA1 ||
> > +		pdev->id == TWL4030_REG_VINTANA2 ||
> > +		pdev->id == TWL4030_REG_VINTDIG)
> > +		c->always_on = true;
> 
> This would be a bit clearer and much more idiomatic as a switch
> statement.

A switch statement sounds like a better idea, yes. Below is a version
that implements that change.

>From 469f1f3fac05a740484cb32469b64aae424ba4de Mon Sep 17 00:00:00 2001
From: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
Date: Wed, 25 Nov 2009 11:10:35 +0200
Subject: [PATCHv3 3/3] Define critical regulators as always_on

Defines VIO, VDD1, VDD2, VPLL1 and VINT* regulators as always_on by
default
since they are critical to TWL and its master's functionality and should
be on in all cases where RegFW is used

Signed-off-by: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
---
 drivers/regulator/twl4030-regulator.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/twl4030-regulator.c
b/drivers/regulator/twl4030-regulator.c
index 7029fb9..02100bc 100644
--- a/drivers/regulator/twl4030-regulator.c
+++ b/drivers/regulator/twl4030-regulator.c
@@ -456,6 +456,19 @@ static int twl4030reg_probe(struct platform_device
*pdev)
 	c->valid_ops_mask &= REGULATOR_CHANGE_VOLTAGE
 				| REGULATOR_CHANGE_MODE
 				| REGULATOR_CHANGE_STATUS;
+	switch(pdev->id) {
+		case TWL4030_REG_VIO:
+		case TWL4030_REG_VDD1:
+		case TWL4030_REG_VDD2:
+		case TWL4030_REG_VPLL1:
+		case TWL4030_REG_VINTANA1:
+		case TWL4030_REG_VINTANA2:
+		case TWL4030_REG_VINTDIG:
+			c->always_on = true;
+			break;
+		default:
+			break;
+	}
 
 	rdev = regulator_register(&info->desc, &pdev->dev, initdata, info);
 	if (IS_ERR(rdev)) {
-- 
1.6.3.3

