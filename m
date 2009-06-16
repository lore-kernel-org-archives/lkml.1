Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbZFPJQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbZFPJQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbZFPJP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:15:57 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:37185 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbZFPJPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:15:54 -0400
Subject: Re: [PATCH] regulator: Report regulator_get() failure in virtual
 consumer
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1245092461-8813-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1245092461-8813-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 10:15:55 +0100
Message-Id: <1245143755.21421.95.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 20:01 +0100, Mark Brown wrote:
> The core will no longer complain so we should log an error here.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/virtual.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/virtual.c b/drivers/regulator/virtual.c
> index e7db566..e953c18 100644
> --- a/drivers/regulator/virtual.c
> +++ b/drivers/regulator/virtual.c
> @@ -285,6 +285,8 @@ static int regulator_virtual_consumer_probe(struct platform_device *pdev)
>  	drvdata->regulator = regulator_get(&pdev->dev, reg_id);
>  	if (IS_ERR(drvdata->regulator)) {
>  		ret = PTR_ERR(drvdata->regulator);
> +		dev_err(&pdev->dev, "Failed to obtain supply '%s': %d\n",
> +			reg_id, ret);
>  		goto err;
>  	}
>  

Applied.

Thanks

Liam

