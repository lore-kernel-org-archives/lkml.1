Return-Path: <linux-kernel-owner+w=401wt.eu-S1751629AbZJWKQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbZJWKQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 06:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZJWKQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 06:16:09 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:60062 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbZJWKQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 06:16:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=LoPg8afYNvQ+Yl9i7QZQJWZJAt17/DCEHhDPS1ixQ79+hK3ZvVLJ6A8IRzS0Bds1B8
         bN0gQIwmxn2wSGyAo1Dgpn2rG/i1M812XRuL4FVt/WheEnnNB5ib6IWnewS6kwZwFTTf
         TWTTlbXJ2/dqODLQhCl4or6lBbpjcBXsf013A=
Message-ID: <4AE184D1.4030006@gmail.com>
Date: Fri, 23 Oct 2009 12:26:25 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] addi-data: Cleanup redundant tests on unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variables are unsigned so the test `>= 0' is always true,
In these cases the other part of the test catch wrapped values.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Chrono.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Chrono.c
index ccb109a..0af12fd 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Chrono.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Chrono.c
@@ -1386,8 +1386,7 @@ int i_APCI1710_ReadChronoValue(struct comedi_device *dev,
 				/* Test the timout parameter */
 		 /*****************************/
 
-				if ((ui_TimeOut >= 0)
-					&& (ui_TimeOut <= 65535UL)) {
+				if (ui_TimeOut <= 65535UL) {
 
 					for (;;) {
 			  /*******************/
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c
index e9021cd..723a97b 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c
@@ -150,7 +150,7 @@ int i_APCI1032_Read1DigitalInput(struct comedi_device *dev, struct comedi_subdev
 	unsigned int ui_TmpValue = 0;
 	unsigned int ui_Channel;
 	ui_Channel = CR_CHAN(insn->chanspec);
-	if (ui_Channel >= 0 && ui_Channel <= 31) {
+	if (ui_Channel <= 31) {
 		ui_TmpValue = (unsigned int) inl(devpriv->iobase + APCI1032_DIGITAL_IP);
 /*
 * since only 1 channel reqd to bring it to last bit it is rotated 8
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index 236b8a3..36b929f 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -968,7 +968,7 @@ int i_APCI1500_ReadMoreDigitalInput(struct comedi_device *dev, struct comedi_sub
 
 	switch (data[0]) {
 	case 0:
-		if (ui_Channel >= 0 && ui_Channel <= 15) {
+		if (ui_Channel <= 15) {
 			ui_TmpValue =
 				(unsigned int) inw(devpriv->i_IobaseAddon +
 				APCI1500_DIGITAL_IP);
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
index 3841635..866eb8d 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
@@ -79,7 +79,7 @@ int i_APCI1516_Read1DigitalInput(struct comedi_device *dev, struct comedi_subdev
 	unsigned int ui_TmpValue = 0;
 	unsigned int ui_Channel;
 	ui_Channel = CR_CHAN(insn->chanspec);
-	if (ui_Channel >= 0 && ui_Channel <= 7) {
+	if (ui_Channel <= 7) {
 		ui_TmpValue = (unsigned int) inw(devpriv->iobase + APCI1516_DIGITAL_IP);
 		/*   since only 1 channel reqd  to bring it to last bit it is rotated */
 		/*   8 +(chan - 1) times then ANDed with 1 for last bit. */
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 3a47c30..3ae663b 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -154,7 +154,7 @@ int i_APCI1564_Read1DigitalInput(struct comedi_device *dev, struct comedi_subdev
 	unsigned int ui_Channel;
 
 	ui_Channel = CR_CHAN(insn->chanspec);
-	if (ui_Channel >= 0 && ui_Channel <= 31) {
+	if (ui_Channel <= 31) {
 		ui_TmpValue =
 			(unsigned int) inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP);
 /*
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c
index 457917f..d348cd5 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c
@@ -117,7 +117,7 @@ int i_APCI2016_WriteDigitalOutput(struct comedi_device *dev, struct comedi_subde
 	unsigned int ui_NoOfChannel;
 	unsigned int ui_Temp, ui_Temp1;
 	ui_NoOfChannel = CR_CHAN(insn->chanspec);
-	if ((ui_NoOfChannel < 0) || (ui_NoOfChannel > 15)) {
+	if (ui_NoOfChannel > 15) {
 		comedi_error(dev,
 			"Invalid Channel Numbers !!!, Channel Numbers must be between 0 and 15\n");
 		return -EINVAL;
@@ -272,7 +272,7 @@ int i_APCI2016_BitsDigitalOutput(struct comedi_device *dev, struct comedi_subdev
 	unsigned int ui_Temp;
 	unsigned int ui_NoOfChannel;
 	ui_NoOfChannel = CR_CHAN(insn->chanspec);
-	if ((ui_NoOfChannel < 0) || (ui_NoOfChannel > 15)) {
+	if (ui_NoOfChannel > 15) {
 		comedi_error(dev,
 			"Invalid Channel Numbers !!!, Channel Numbers must be between 0 and 15\n");
 		return -EINVAL;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c
index a853c62..aa159dc 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c
@@ -79,7 +79,7 @@ int i_APCI2200_Read1DigitalInput(struct comedi_device *dev, struct comedi_subdev
 	unsigned int ui_TmpValue = 0;
 	unsigned int ui_Channel;
 	ui_Channel = CR_CHAN(insn->chanspec);
-	if (ui_Channel >= 0 && ui_Channel <= 7) {
+	if (ui_Channel <= 7) {
 		ui_TmpValue = (unsigned int) inw(devpriv->iobase + APCI2200_DIGITAL_IP);
 		*data = (ui_TmpValue >> ui_Channel) & 0x1;
 	}			/* if(ui_Channel >= 0 && ui_Channel <=7) */
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
index 169cee4..222b549 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
@@ -2350,7 +2350,7 @@ int i_APCI3120_InsnReadDigitalInput(struct comedi_device *dev,
 	ui_Chan = CR_CHAN(insn->chanspec);	/*  channel specified */
 
 	/* this_board->i_hwdrv_InsnReadDigitalInput(dev,ui_Chan,data); */
-	if (ui_Chan >= 0 && ui_Chan <= 3) {
+	if (ui_Chan <= 3) {
 		ui_TmpValue = (unsigned int) inw(devpriv->iobase + APCI3120_RD_STATUS);
 
 /*
@@ -2539,8 +2539,7 @@ int i_APCI3120_InsnWriteDigitalOutput(struct comedi_device *dev,
 			"Not a valid Data !!! ,Data should be 1 or 0\n");
 		return -EINVAL;
 	}
-	if ((ui_NoOfChannel > (this_board->i_NbrDoChannel - 1))
-		|| (ui_NoOfChannel < 0)) {
+	if (ui_NoOfChannel > this_board->i_NbrDoChannel - 1) {
 		comedi_error(dev,
 			"This board doesn't have specified channel !!! \n");
 		return -EINVAL;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
index 010697f..98c2387 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
@@ -461,7 +461,7 @@ int i_APCI3200_GetChannelCalibrationValue(struct comedi_device *dev,
 	if (s_BoardInfos[dev->minor].i_ConnectionType == 1) {
 		/* if diff */
 
-		if ((ui_Channel_num >= 0) && (ui_Channel_num <= 1))
+		if (ui_Channel_num <= 1)
 			i_DiffChannel = ui_Channel_num, i_Module = 0;
 		else if ((ui_Channel_num >= 2) && (ui_Channel_num <= 3))
 			i_DiffChannel = ui_Channel_num - 2, i_Module = 1;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.c
index 3387278..1d1e5fc 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.c
@@ -148,7 +148,7 @@ int i_APCI3XXX_AnalogInputConfigOperatingMode(struct comedi_device *dev,
 			/* Test the convert time value */
 	      /*******************************/
 
-			if ((dw_ReloadValue >= 0) && (dw_ReloadValue <= 65535)) {
+			if (dw_ReloadValue <= 65535) {
 				dw_TestReloadValue = dw_ReloadValue;
 
 				if (b_TimeBase == 1) {
