Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab0CIO1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 09:27:31 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44538 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab0CIO11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 09:27:27 -0500
Date: Tue, 9 Mar 2010 14:27:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: axel lin <axel.lin@gmail.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk
Subject: Re: [PATCH] Regulators: lp3971 - Fix setting val for LDO2 and LDO4
Message-ID: <20100309142723.GA4303@sirena.org.uk>
References: <427d64721003090114u5419e36dl23616cfa0afd3cde@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <427d64721003090114u5419e36dl23616cfa0afd3cde@mail.gmail.com>
X-Cookie: The meek don't want it.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 05:14:53PM +0800, axel lin wrote:
> From 4e4c5f8267a4fbf651b4cc26c5f72465514f6224 Mon Sep 17 00:00:00 2001
> From: Axel Lin <axel.lin@gmail.com>
> Date: Tue, 9 Mar 2010 16:53:59 +0800
> Subject: [PATCH] lp3971: Fix setting val for LDO2 and LDO4

Please try to follow the instructions for submitting patches in
Documentation/SubmittingPatches - this is missing Signed-off-by and CCs
to maintainers.

> In lp3971_ldo_set_voltage function, it requires val to left shift 4
> bits for LDO2 and LDO4.
> This patch fix this issue.

CCing in the folks who worked with the hardware for confirmation - the
patch looks OK to me but it's surprising that this wasn't noticed when
the driver was being developed, it might be that the chip is doing
something strange here.

> ---
>  drivers/regulator/lp3971.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
> index f5532ed..a28ae37 100644
> --- a/drivers/regulator/lp3971.c
> +++ b/drivers/regulator/lp3971.c
> @@ -187,7 +187,8 @@ static int lp3971_ldo_set_voltage(struct regulator_dev *dev,
>                 return -EINVAL;
> 
>         return lp3971_set_bits(lp3971, LP3971_LDO_VOL_CONTR_REG(ldo),
> -               LDO_VOL_CONTR_MASK << LDO_VOL_CONTR_SHIFT(ldo), val);
> +               LDO_VOL_CONTR_MASK << LDO_VOL_CONTR_SHIFT(ldo),
> +               val << LDO_VOL_CONTR_SHIFT(ldo));
>  }
> 
>  static struct regulator_ops lp3971_ldo_ops = {
