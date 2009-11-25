Return-Path: <linux-kernel-owner+w=401wt.eu-S964849AbZKYOXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964849AbZKYOXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:23:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934706AbZKYOXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:23:08 -0500
Received: from smtp.nokia.com ([192.100.122.230]:22607 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934690AbZKYOXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:23:07 -0500
Subject: Re: [PATCHv2 1/3] twl4030-regulator: Add all TWL regulators to
 twreg_info
From: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
To: ext Liam Girdwood <lrg@slimlogic.co.uk>
Cc: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
In-Reply-To: <1259156960.3697.74.camel@odin>
References: <1259143495-9480-1-git-send-email-ext-juha.1.keski-saari@nokia.com>
	 <1259143495-9480-2-git-send-email-ext-juha.1.keski-saari@nokia.com>
	 <1259156290.6303.2.camel@keskisaa-workstation>
	 <1259156960.3697.74.camel@odin>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 16:22:43 +0200
Message-ID: <1259158963.6303.5.camel@keskisaa-workstation>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Nov 2009 14:22:45.0147 (UTC) FILETIME=[C193D6B0:01CA6DDA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 14:49 +0100, ext Liam Girdwood wrote:
> On Wed, 2009-11-25 at 15:38 +0200, Juha Keski-Saari wrote:
> > Regrettably it seems I slipped a mistake into this patch which took out
> > the regulators VAUX1-3. Below is a version which removes this issue
> > 
> 
> Ah, I've just applied and pushed this series. Can you redo against
> voltage for-next ?
> 
> Thanks
> 
> Liam

Here are the additions done on recent voltage-2.6/for-next, my apologies
for the extra work

>From 03578bd4f927f7777557be6d473eb0011b80608a Mon Sep 17 00:00:00 2001
From: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
Date: Wed, 25 Nov 2009 16:18:35 +0200
Subject: [PATCH] twl4030-regulator: Fixes VAUX1-3 exclusion introduced
in 3277b9fce0fcaa68d5947429e062163852ebc6fb

Signed-off-by: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
---
 drivers/regulator/twl4030-regulator.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/twl4030-regulator.c
b/drivers/regulator/twl4030-regulator.c
index 02100bc..477c965 100644
--- a/drivers/regulator/twl4030-regulator.c
+++ b/drivers/regulator/twl4030-regulator.c
@@ -401,6 +401,10 @@ static struct regulator_ops twl4030fixed_ops = {
  * software control over them after boot.
  */
 static struct twlreg_info twl4030_regs[] = {
+	TWL_ADJUSTABLE_LDO(VAUX1, 0x17, 1),
+	TWL_ADJUSTABLE_LDO(VAUX2_4030, 0x1b, 2),
+	TWL_ADJUSTABLE_LDO(VAUX2, 0x1b, 2),
+	TWL_ADJUSTABLE_LDO(VAUX3, 0x1f, 3),
 	TWL_ADJUSTABLE_LDO(VAUX4, 0x23, 4),
 	TWL_ADJUSTABLE_LDO(VMMC1, 0x27, 5),
 	TWL_ADJUSTABLE_LDO(VMMC2, 0x2b, 6),
-- 
1.6.3.3



