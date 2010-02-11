Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab0BKUld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:41:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51575 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979Ab0BKUlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:41:31 -0500
X-Authority-Analysis: v=1.0 c=1 a=DVvl71C119QA:10 a=yQdBAQUQAAAA:8 a=So18BY7o0NKAUTrffkMA:9 a=c3F9_dJ5xwAI7UmxvLDkE6JsnTIA:4 a=IcxpeKGZWnEA:10
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.235
Date: Thu, 11 Feb 2010 14:41:24 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bernhard Schiffner <bernhard@schiffner-limbach.de>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH] staging: r8187se: Fix for LED not following radio switch
Message-ID: <4b746b74.8SETcYq7pcTkXOg9%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current driver does not follow the state of the RF switch.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/staging/rtl8187se/r8180_core.c
===================================================================
--- wireless-testing.orig/drivers/staging/rtl8187se/r8180_core.c
+++ wireless-testing/drivers/staging/rtl8187se/r8180_core.c
@@ -4293,11 +4293,12 @@ void GPIOChangeRFWorkItemCallBack(struct
 			//HW radio On/Off according to the value of FF51[4](config0)
 			btConfig0 = btPSR = read_nic_byte(dev, CONFIG0);
 
-			//Turn on LED.
-			write_nic_byte(dev, PSR, btPSR| BIT3);
-
 			eRfPowerStateToSet = (btConfig0 & BIT4) ?  eRfOn : eRfOff;
 
+			/* Turn LED back on when radio enabled */
+			if (eRfPowerStateToSet == eRfOn)
+				write_nic_byte(dev, PSR, btPSR | BIT3);
+
 			if((priv->ieee80211->bHwRadioOff == true) && (eRfPowerStateToSet == eRfOn))
 			{
 				priv->ieee80211->bHwRadioOff = false;
