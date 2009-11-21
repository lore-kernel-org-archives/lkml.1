Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbZKUVdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbZKUVdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 16:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756090AbZKUVdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 16:33:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46034 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754806AbZKUVdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 16:33:12 -0500
References: <Pine.LNX.4.64.0911212218210.28848@ask.diku.dk> (sfid-20091121_211852_064475_1FE64446)
Message-Id: <542581F2-4F09-4771-B8C6-D81DC890ABC9@opensource.wolfsonmicro.com>
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
In-Reply-To: <Pine.LNX.4.64.0911212218210.28848@ask.diku.dk> (sfid-20091121_211852_064475_1FE64446)
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7D11)
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: [PATCH] drivers/regulator: use PTR_ERR to get error code
Date: Sat, 21 Nov 2009 21:33:25 +0000
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 Nov 2009, at 21:18, Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
>
> IS_ERR returns only 1 or 0.  The callsite of setup_regulators  
> expects a
> negative integer in an error case.  Thus, PTR_ERR has to be used to  
> extract
> it.
>
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression E,E1;
> @@
>
> *E = IS_ERR(...)
> ... when != E = E1
> *return E;
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: <broonie@opensource.wolfsonmicro.com>

>
> ---
> drivers/regulator/lp3971.c          |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
> index 7803a32..76d08c2 100644
> --- a/drivers/regulator/lp3971.c
> +++ b/drivers/regulator/lp3971.c
> @@ -446,8 +446,8 @@ static int setup_regulators(struct lp3971 *lp3971,
>        lp3971->rdev[i] = regulator_register(&regulators[id],
>            lp3971->dev, pdata->regulators[i].initdata, lp3971);
>
> -        err = IS_ERR(lp3971->rdev[i]);
> -        if (err) {
> +        if (IS_ERR(lp3971->rdev[i])) {
> +            err = PTR_ERR(lp3971->rdev[i]);
>            dev_err(lp3971->dev, "regulator init failed: %d\n",
>                err);
>            goto error;
