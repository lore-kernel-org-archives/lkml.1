Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbZHKMqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbZHKMqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbZHKMqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:46:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38402 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753847AbZHKMqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:46:48 -0400
Date: Tue, 11 Aug 2009 11:19:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 5/5] [regulator] Add a Freescale MC13783 regulator
 driver
Message-ID: <20090811101939.GC7572@rakim.wolfsonmicro.main>
References: <1249981667-4366-1-git-send-email-s.hauer@pengutronix.de>
 <1249981667-4366-2-git-send-email-s.hauer@pengutronix.de>
 <1249981667-4366-3-git-send-email-s.hauer@pengutronix.de>
 <1249981667-4366-4-git-send-email-s.hauer@pengutronix.de>
 <1249981667-4366-5-git-send-email-s.hauer@pengutronix.de>
 <1249981667-4366-6-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249981667-4366-6-git-send-email-s.hauer@pengutronix.de>
X-Cookie: Beware of geeks bearing graft.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 11:07:47AM +0200, Sascha Hauer wrote:

This looks basically OK - a few small nitpicks below.

> +static int mc13783_enable(struct regulator_dev *rdev)
> +{
> +	struct mc13783_priv *priv = rdev_get_drvdata(rdev);
> +	int id = rdev_get_id(rdev);
> +
> +	dev_info(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);

This is too verbose - it should be dev_dbg() if anything.

> +static int __devinit mc13783_regulator_probe(struct platform_device *pdev)
> +{
> +	struct mc13783_priv *priv;
> +	struct mc13783 *mc13783 = pdev->dev.platform_data;
> +	struct mc13783_regulator_init_data *init_data;
> +	int i, ret;
> +
> +	dev_info(&pdev->dev, "mc13783_regulator_probe id %d\n", pdev->id);

dev_dbg() please.

> +static int __init mc13783_regulator_init(void)
> +{
> +	return platform_driver_register(&mc13783_regulator_driver);
> +}
> +module_init(mc13783_regulator_init);

This should be subsys_initcall().
