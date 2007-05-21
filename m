Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbXEUCaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbXEUCaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 22:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbXEUC34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 22:29:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:24906 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbXEUC3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 22:29:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=I94J9XPhFEwCmmLmHyLLzuHFiYS6jofqHx4D31X1AmfoxulhFWvj/Wv2JM8eyuWkevkcktNBmK+qGgwk7Jfg3zOnBhPa0+sPbF6ah363mJhV9Kk44Tq9Yd2vDRgPmq/lHJXVpGrRuvD2/Cxu4lwkP7UK+wn/Eod3RqRQYSMQftw=
Message-ID: <6defe8840705201929k1835f3bagf9f1e851f2493e33@mail.gmail.com>
Date: Sun, 20 May 2007 22:29:54 -0400
From: "Denver Gingerich" <denver@ossguy.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix compiler warning in fixed.c
In-Reply-To: <6defe8840705091826j4395f090rc62aa2200f020536@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6defe8840705091826j4395f090rc62aa2200f020536@mail.gmail.com>
X-Google-Sender-Auth: cd4d1c08d7f733fe
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Denver Gingerich <denver@ossguy.com>
Date: May 9, 2007 9:26 PM
Subject: [PATCH] fix compiler warning in fixed.c
To: kernel-janitors@lists.linux-foundation.org


Correct the following compiler warning (and warnings resulting from
the correction):
warning: 'fixed_mdio_register_device' defined but not used

Signed-off-by: Denver Gingerich <denver@ossguy.com>

---

--- linux-2.6.21/drivers/net/phy/fixed.c.000    2007-05-09
18:56:33.000000000 -0400
+++ linux-2.6.21/drivers/net/phy/fixed.c        2007-05-09
21:07:35.000000000 -0400
@@ -89,6 +89,7 @@ EXPORT_SYMBOL(fixed_mdio_set_link_update
 /*-----------------------------------------------------------------------------
  *  This is used for updating internal mii regs from the status
  *-----------------------------------------------------------------------------*/
+#if defined(CONFIG_FIXED_MII_100_FDX) || defined(CONFIG_FIXED_MII_10_FDX)
 static int fixed_mdio_update_regs(struct fixed_info *fixed)
 {
        u16 *regs = fixed->regs;
@@ -165,6 +166,7 @@ static int fixed_mii_reset(struct mii_bu
        /*nothing here - no way/need to reset it*/
        return 0;
 }
+#endif

 static int fixed_config_aneg(struct phy_device *phydev)
 {
@@ -194,6 +196,7 @@ static struct phy_driver fixed_mdio_driv
  * number is used to create multiple fixed PHYs, so that several devices can
  * utilize them simultaneously.
  *-----------------------------------------------------------------------------*/
+#if defined(CONFIG_FIXED_MII_100_FDX) || defined(CONFIG_FIXED_MII_10_FDX)
 static int fixed_mdio_register_device(int number, int speed, int duplex)
 {
        struct mii_bus *new_bus;
@@ -301,6 +304,7 @@ device_create_fail:

        return err;
 }
+#endif


 MODULE_DESCRIPTION("Fixed PHY device & driver for PAL");
