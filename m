Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362Ab0AZLE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab0AZLE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 06:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560Ab0AZLE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 06:04:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50334 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750893Ab0AZLEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 06:04:22 -0500
Date: Tue, 26 Jan 2010 11:04:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/01] regulator: support max8649
Message-ID: <20100126110420.GI15759@rakim.wolfsonmicro.main>
References: <771cded01001120041ue24edabk8e4638ef7151c947@mail.gmail.com>
 <771cded01001120051l44fd76bx80d2fd4b6f60bd0b@mail.gmail.com>
 <20100112115156.GA546@rakim.wolfsonmicro.main>
 <771cded01001250301q465a9f8ma484f597ae9a292f@mail.gmail.com>
 <20100125135628.GB26613@rakim.wolfsonmicro.main>
 <771cded01001252226k342723b3p3ea235fe79c46843@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <771cded01001252226k342723b3p3ea235fe79c46843@mail.gmail.com>
X-Cookie: I'm ANN LANDERS!!  I can SHOPLIFT!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 01:26:08AM -0500, Haojian Zhuang wrote:

This all looks good except...

> +static int max8649_enable_time(struct regulator_dev *rdev)
> +{

...

> +	return (voltage / step);

I'd expect the time taken to enable to be the voltage multipled by the
step size rather than divided by the step size?

> +static int max8649_set_mode(struct regulator_dev *rdev, unsigned int mode)
> +{
> +	struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
> +
> +	switch (mode) {
> +	case REGULATOR_MODE_FAST:
> +		max8649_set_bits(info->i2c, info->vol_reg, MAX8649_FORCE_PWM,
> +				 MAX8649_FORCE_PWM);
> +		break;
> +	case REGULATOR_MODE_NORMAL:
> +		max8649_set_bits(info->i2c, info->vol_reg,
> +				 MAX8649_FORCE_PWM, 0);
> +		break;

This should really have a default case which rejects other modes.
