Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYLVLUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYLVLUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 06:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYLVLU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 06:20:27 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:49198 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbYLVLU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 06:20:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XZ/URsBUx8BNNR0sFUwHCVlHL8wWGUBhX/hhQo1BRAfjxU9XSPic3SaFvNTiLinx/B
         0TJslXbkBRuSeXRSsLym236yJ6Q3pC2Lp+fA/h0/QqDsJ9wSxvc4ejj5GV7TGEQHUCWP
         7M5U+jq6F+VzH6G1TXJoOax8zGG2isaUtvLcI=
Message-ID: <5d5443650812220320q365b97e4hdff226cb8101f6ed@mail.gmail.com>
Date: Mon, 22 Dec 2008 16:50:25 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Tony Lindgren" <tony@atomide.com>
Subject: Re: [irda-users] [PATCH] OMAP IrDA driver
Cc: samuel@sortiz.org, linux-kernel@vger.kernel.org,
       irda-users@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-omap@vger.kernel.org
In-Reply-To: <20081205203216.GJ9714@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d5443650812042234y6301148at6658f4855500b105@mail.gmail.com>
	 <ea9ea93a42eaf41cd9ee3ff11ad1a026@localhost>
	 <5d5443650812050148n2b3fca72m272a1af33629c478@mail.gmail.com>
	 <20081205203216.GJ9714@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

>
>> +
>> +/*
>> + * Set the IrDA communications speed.
>> + * Interrupt have to be disabled here.
>> + */
>> +static int omap_irda_startup(struct net_device *dev)
>> +{
>> +     struct omap_irda *omap_ir = netdev_priv(dev);
>> +
>> +     /* FIXME: use clk_* apis for UART3 clock*/
>> +     /* Enable UART3 clock and set UART3 to IrDA mode */
>> +     if (machine_is_omap_h2() || machine_is_omap_h3())
>> +             omap_writel(omap_readl(MOD_CONF_CTRL_0) | (1 << 31) | (1 << 15),
>> +                             MOD_CONF_CTRL_0);

This looks like muxing on H3.

>> +
>> +     /* Only for H2?
>> +      */
>> +     if (omap_ir->pdata->transceiver_mode && machine_is_omap_h2()) {
>> +             /* Is it select_irda on H2 ? */
>> +             omap_writel(omap_readl(FUNC_MUX_CTRL_A) | 7,
>> +                                     FUNC_MUX_CTRL_A);
>> +             omap_ir->pdata->transceiver_mode(omap_ir->dev, IR_SIRMODE);
>> +     }
>> +
>

I can move this to board-h3.c file instead with platform data flag probably.


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
