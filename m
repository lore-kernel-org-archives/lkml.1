Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbZHYSj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbZHYSj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbZHYSjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:39:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38030 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755570AbZHYSjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:39:55 -0400
Date: Tue, 25 Aug 2009 19:39:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Mike Rapoport <mike@compulab.co.il>,
       eric.y.miao@gmail.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] regulator: fix calculation of voltage range in
	da9034_set_ldo12_voltage()
Message-ID: <20090825183955.GA2724@opensource.wolfsonmicro.com>
References: <4A93EA28.9050105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A93EA28.9050105@gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 03:42:00PM +0200, Roel Kluin wrote:
> For val to be greater than 7 or less than 20 is logically always true.

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Looks good to me but CCing in Eric and Mike just in case the intent of
the code was something other than the new version.

> diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
> index b8b89ef..2d9bde5 100644
> --- a/drivers/regulator/da903x.c
> +++ b/drivers/regulator/da903x.c
> @@ -278,7 +278,7 @@ static int da9034_set_ldo12_voltage(struct regulator_dev *rdev,
>  	}
>  
>  	val = (min_uV - info->min_uV + info->step_uV - 1) / info->step_uV;
> -	val = (val > 7 || val < 20) ? 8 : val - 12;
> +	val = (val > 7 && val < 20) ? 8 : val - 12;
>  	val <<= info->vol_shift;
>  	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
>  
