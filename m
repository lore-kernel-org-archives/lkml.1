Return-Path: <linux-kernel-owner+w=401wt.eu-S1753042AbZGVUlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbZGVUlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 16:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZGVUla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 16:41:30 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:48206 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbZGVUla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 16:41:30 -0400
Subject: Re: [PATCH 6/6] regulator: Provide mode to status conversion
 function
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1248188428-11277-6-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1248188428-11277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1248188428-11277-2-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1248188428-11277-3-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1248188428-11277-4-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1248188428-11277-5-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1248188428-11277-6-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 21:41:28 +0100
Message-Id: <1248295288.25964.844.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 16:00 +0100, Mark Brown wrote:
> This is useful for implementing get_status() in terms of get_mode().
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c         |   24 ++++++++++++++++++++++++
>  include/linux/regulator/driver.h |    2 ++
>  2 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index cba10ec..13d0f92 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1993,6 +1993,30 @@ int regulator_notifier_call_chain(struct regulator_dev *rdev,
>  }
>  EXPORT_SYMBOL_GPL(regulator_notifier_call_chain);
>  
> +/**
> + * regulator_mode_to_status - convert a regulator mode into a status
> + *
> + * @mode: Mode to convert
> + *
> + * Convert a regulator mode into a status.
> + */
> +int regulator_mode_to_status(unsigned int mode)
> +{
> +	switch (mode) {
> +	case REGULATOR_MODE_FAST:
> +		return REGULATOR_STATUS_FAST;
> +	case REGULATOR_MODE_NORMAL:
> +		return REGULATOR_STATUS_NORMAL;
> +	case REGULATOR_MODE_IDLE:
> +		return REGULATOR_STATUS_IDLE;
> +	case REGULATOR_STATUS_STANDBY:
> +		return REGULATOR_STATUS_STANDBY;
> +	default:
> +		return 0;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(regulator_mode_to_status);
> +
>  /*
>   * To avoid cluttering sysfs (and memory) with useless state, only
>   * create attributes that can be meaningfully displayed.
> diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
> index 60efbd1..73c9cd6 100644
> --- a/include/linux/regulator/driver.h
> +++ b/include/linux/regulator/driver.h
> @@ -195,6 +195,8 @@ void *rdev_get_drvdata(struct regulator_dev *rdev);
>  struct device *rdev_get_dev(struct regulator_dev *rdev);
>  int rdev_get_id(struct regulator_dev *rdev);
>  
> +int regulator_mode_to_status(unsigned int);
> +
>  void *regulator_get_init_drvdata(struct regulator_init_data *reg_init_data);
>  
>  #endif

I've applied all patches, but I'm wondering whether it would be better
to eventually merge MODE and STATUS. i.e. have REGULATOR_FAST instead of
REGULATOR_STATUS_FAST and REGULATOR_MODE_FAST. 

Thanks

Liam

