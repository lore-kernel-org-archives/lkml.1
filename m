Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbZLPP5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbZLPP5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbZLPP5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:57:15 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37230 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZLPP5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:57:14 -0500
Subject: Re: [PATCH] regulator: wm831x_reg_read() failure unnoticed in
 wm831x_aldo_get_mode()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B27DE73.6060909@gmail.com>
References: <4B27DE73.6060909@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 15:57:11 +0000
Message-ID: <1260979031.3525.307.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 20:07 +0100, Roel Kluin wrote:
> ret should be signed to notice a failure in wm831x_reg_read().
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Found using coccinelle: http://coccinelle.lip6.fr/
> 
> diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
> index 902db56..61e02ac 100644
> --- a/drivers/regulator/wm831x-ldo.c
> +++ b/drivers/regulator/wm831x-ldo.c
> @@ -470,7 +470,7 @@ static unsigned int wm831x_aldo_get_mode(struct regulator_dev *rdev)
>  	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
>  	struct wm831x *wm831x = ldo->wm831x;
>  	int on_reg = ldo->base + WM831X_LDO_ON_CONTROL;
> -	unsigned int ret;
> +	int ret;
>  
>  	ret = wm831x_reg_read(wm831x, on_reg);
>  	if (ret < 0)

Applied.

Thanks

Liam

