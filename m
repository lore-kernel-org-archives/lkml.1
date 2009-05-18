Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbZERIMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbZERIMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 04:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbZERIMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 04:12:36 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:59824 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbZERIMf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 04:12:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZJbe1N8dB7ztbs+ZsRL4p/NW6TFC9ilFGRHly7UwSfxu6VUDDqGUltCo2Rn8WF3xey
         Nhu9EwMpqLcm/OxSwPiDrDcPdzCyUt1xSOfUlj6VyKhXooCAdQaV22mpz0kzPTj1DUQr
         fWl9bnhyBAdbriikAREPgK2OmRqS6erjoKDyg=
MIME-Version: 1.0
In-Reply-To: <1242413433-26688-1-git-send-email-vapier@gentoo.org>
References: <1242413433-26688-1-git-send-email-vapier@gentoo.org>
Date: Mon, 18 May 2009 16:12:36 +0800
Message-ID: <f17812d70905180112h6fdff033h2235919ca2f29987@mail.gmail.com>
Subject: Re: [PATCH] regulator: da903x: add missing __devexit_p()
From: Eric Miao <eric.y.miao@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mike Rapoport <mike@compulab.co.il>, Eric Miao <eric.miao@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 2:50 AM, Mike Frysinger <vapier@gentoo.org> wrote:
> The remove function uses __devexit, so the .remove assignment needs
> __devexit_p() to fix a build error with hotplug disabled.
>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> CC: Liam Girdwood <lrg@slimlogic.co.uk>
> CC: Mike Rapoport <mike@compulab.co.il>
> CC: Eric Miao <eric.miao@marvell.com>

Yes, Acked.

> ---
>  drivers/regulator/da903x.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
> index 72b1549..c6628f5 100644
> --- a/drivers/regulator/da903x.c
> +++ b/drivers/regulator/da903x.c
> @@ -497,7 +497,7 @@ static struct platform_driver da903x_regulator_driver = {
>                .owner  = THIS_MODULE,
>        },
>        .probe          = da903x_regulator_probe,
> -       .remove         = da903x_regulator_remove,
> +       .remove         = __devexit_p(da903x_regulator_remove),
>  };
>
>  static int __init da903x_regulator_init(void)
> --
> 1.6.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
