Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbZD1NYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbZD1NYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756503AbZD1NYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:24:16 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:48959 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788AbZD1NYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:24:15 -0400
Subject: Re: [PATCH 1/2] regulator: Support list_voltage for fixed voltage
 regulator
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1240913635-22404-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1240913635-22404-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 14:24:13 +0100
Message-Id: <1240925053.14165.145.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 11:13 +0100, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/fixed.c |   15 ++++++++++++++-
>  1 files changed, 14 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
> index 6e0bede..4c525af 100644
> --- a/drivers/regulator/fixed.c
> +++ b/drivers/regulator/fixed.c
> @@ -44,10 +44,22 @@ static int fixed_voltage_get_voltage(struct regulator_dev *dev)
>  	return data->microvolts;
>  }
>  
> +static int fixed_voltage_list_voltage(struct regulator_dev *dev,
> +				      unsigned selector)
> +{
> +	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
> +
> +	if (selector != 0)
> +		return -EINVAL;
> +
> +	return data->microvolts;
> +}
> +
>  static struct regulator_ops fixed_voltage_ops = {
>  	.is_enabled = fixed_voltage_is_enabled,
>  	.enable = fixed_voltage_enable,
>  	.get_voltage = fixed_voltage_get_voltage,
> +	.list_voltage = fixed_voltage_list_voltage,
>  };
>  
>  static int regulator_fixed_voltage_probe(struct platform_device *pdev)
> @@ -69,7 +81,8 @@ static int regulator_fixed_voltage_probe(struct platform_device *pdev)
>  	}
>  	drvdata->desc.type = REGULATOR_VOLTAGE;
>  	drvdata->desc.owner = THIS_MODULE;
> -	drvdata->desc.ops = &fixed_voltage_ops,
> +	drvdata->desc.ops = &fixed_voltage_ops;
> +	drvdata->desc.n_voltages = 1;
>  
>  	drvdata->microvolts = config->microvolts;
>  

Applied.

Thanks

Liam

