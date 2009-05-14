Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbZENPLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbZENPLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 11:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbZENPLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 11:11:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40555 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZENPLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 11:11:33 -0400
Date: Thu, 14 May 2009 17:09:17 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] LP3971 PMIC regulator driver
In-reply-to: <20090514095700.GA28291@sirena.org.uk>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       "'Liam Girdwood'" <lrg@slimlogic.co.uk>, kyungmin.park@samsung.com
Message-id: <000001c9d4a6$003f2e10$00bd8a30$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcnUemrRdYO//s+RTpiUpZRTmRXXsgAIzp8w
References: <E4D3F24EA6C9E54F817833EAE0D912AC02245E982A@bssrvexch01.BS.local>
 <20090514095700.GA28291@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Thu, May 14, 2009 Mark Brown wrote:

> > This patch adds regulator drivers for National Semiconductors LP3971
> PMIC.
> > This LP3971 PMIC controller has 3 DC/DC voltage converters and 5 low
> drop-out
> > (LDO) regulators. LP3971 PMIC controller uses I2C interface.
> >
> > Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> This looks basically good, a few comments below but personally I'd be
> inclined to merge this as-is and deal with the remaining issues as
> separate patches so:
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> It'd be good to also implement list_voltage().

Ok. I will prepare a new patches that will add this functionality and fix
issues reported below.

> > +       if (reg <= BUCK_TARGET_VOL_MAX_IDX)
> > +               val = 1000 * buck_voltage_map[reg];
> > +       else
> > +               val = 0;
> 
> I'd expect some kind of warning to be displayed here?

Right.

> > +       /* Detect LP3971 (initial system control 1 reg is '0x60') */
> > +       ret = lp3971_i2c_read(i2c, LP3971_SYS_CONTROL1_REG, 1, &val);
> > +       if (ret < 0) {
> > +               dev_err(&i2c->dev, "failed to detect device\n");
> > +               goto err_detect;
> > +       }
> > +
> 
> You don't actually appear to check the value you read back here?

Right, I forgot. Now I noticed in the chip spec that some default bits can
be eeprom programmed. I will handle this too.

Thanks for your review.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


