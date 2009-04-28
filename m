Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbZD1FSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbZD1FSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 01:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbZD1FSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 01:18:25 -0400
Received: from cathcart.site5.com ([74.54.107.137]:39162 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbZD1FSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 01:18:24 -0400
Message-ID: <49F6919C.2070200@compulab.co.il>
Date: Tue, 28 Apr 2009 08:18:20 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Move regulator drivers to subsys_initcall()
References: <1240852878-8276-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1240852878-8276-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Mark Brown wrote:
> Regulators need to be available early in init in order to allow them
> to be available for consumers when requested. This is generally done
> by registering them at subsys_initcall() time but not all regulator
> drivers have done that. Convert these drivers to do so in order to
> mimimise future support.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/da903x.c             |    2 +-
>  drivers/regulator/fixed.c              |    2 +-
>  drivers/regulator/pcf50633-regulator.c |    2 +-
>  drivers/regulator/wm8400-regulator.c   |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
> index 72b1549..2a491bf 100644
> --- a/drivers/regulator/da903x.c
> +++ b/drivers/regulator/da903x.c
> @@ -504,7 +504,7 @@ static int __init da903x_regulator_init(void)
>  {
>  	return platform_driver_register(&da903x_regulator_driver);
>  }
> -module_init(da903x_regulator_init);
> +subsys_initcall(da903x_regulator_init);

For DA903x part

Acked-by: Mike Rapoport <mike@compulab.co.il>

>  static void __exit da903x_regulator_exit(void)
>  {
> diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
> index 23d5546..6e0bede 100644
> --- a/drivers/regulator/fixed.c
> +++ b/drivers/regulator/fixed.c
> @@ -117,7 +117,7 @@ static int __init regulator_fixed_voltage_init(void)
>  {
>  	return platform_driver_register(&regulator_fixed_voltage_driver);
>  }
> -module_init(regulator_fixed_voltage_init);
> +subsys_initcall(regulator_fixed_voltage_init);
>  
>  static void __exit regulator_fixed_voltage_exit(void)
>  {
> diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
> index cd761d8..8e14900 100644
> --- a/drivers/regulator/pcf50633-regulator.c
> +++ b/drivers/regulator/pcf50633-regulator.c
> @@ -316,7 +316,7 @@ static int __init pcf50633_regulator_init(void)
>  {
>  	return platform_driver_register(&pcf50633_regulator_driver);
>  }
> -module_init(pcf50633_regulator_init);
> +subsys_initcall(pcf50633_regulator_init);
>  
>  static void __exit pcf50633_regulator_exit(void)
>  {
> diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
> index 1574260..01a6c95 100644
> --- a/drivers/regulator/wm8400-regulator.c
> +++ b/drivers/regulator/wm8400-regulator.c
> @@ -380,7 +380,7 @@ static int __init wm8400_regulator_init(void)
>  {
>  	return platform_driver_register(&wm8400_regulator_driver);
>  }
> -module_init(wm8400_regulator_init);
> +subsys_initcall(wm8400_regulator_init);
>  
>  static void __exit wm8400_regulator_exit(void)
>  {

-- 
Sincerely yours,
Mike.

