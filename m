Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbZGVUO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbZGVUO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 16:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbZGVUO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 16:14:59 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:58652 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZGVUO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 16:14:58 -0400
Subject: Re: [PATCH 3/6] regulator: Warn when unregistering an in-use
 regulator
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1248188428-11277-3-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1248188428-11277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1248188428-11277-2-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1248188428-11277-3-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 21:14:54 +0100
Message-Id: <1248293694.25964.817.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 16:00 +0100, Mark Brown wrote:
> We're probably going to start oopsing fairly soon after this happens.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 33a8c3c..e5ccc9f 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -2229,6 +2229,7 @@ void regulator_unregister(struct regulator_dev *rdev)
>  		return;
>  
>  	mutex_lock(&regulator_list_mutex);
> +	WARN_ON(rdev->open_count)

Missing ;  Fixed.

>  	unset_regulator_supplies(rdev);
>  	list_del(&rdev->list);
>  	if (rdev->supply)

Applied.

Thanks

Liam

