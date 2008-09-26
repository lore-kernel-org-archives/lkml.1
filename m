Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYIZOAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYIZOAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 10:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYIZOA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 10:00:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3003 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbYIZOA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 10:00:26 -0400
Date: Fri, 26 Sep 2008 15:00:23 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Julien Brunel <brunel@diku.dk>
Cc: tiwai@suse.de, Geoffrey Wossum <geoffrey@pager.net>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] sound/soc/at32: Useless NULL test
Message-ID: <20080926140021.GD15493@sirena.org.uk>
References: <200809261523.46747.brunel@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809261523.46747.brunel@diku.dk>
X-Cookie: NANCY!!  Why is everything RED?!
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 03:23:46PM +0200, Julien Brunel wrote:

> The test (ssc != NULL) can only be reached if the call to the function
> ssc_request, the result of which ssc is assigned, succeeds. Moreover,
> statements assign NULL to ssc just before a return, which is useless
> since it is a local variable. So, we suggest to delete the test and
> the two assignments.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

For future reference if you're submitting other similar things (which I
guess you will given that you've got a tool to check for this stuff)
it'd be helpful if you could rewrite the explanation for the NULL test
to be something like:

    The test (ssc != NULL) is redundant since it can only be reached
    when ssc is guaranteed to have been set to a valid ssc.

which is much easier to parse.

> diff -u -p a/sound/soc/at32/playpaq_wm8510.c b/sound/soc/at32/playpaq_wm8510.c
> --- a/sound/soc/at32/playpaq_wm8510.c
> +++ b/sound/soc/at32/playpaq_wm8510.c
> @@ -405,7 +405,6 @@ static int __init playpaq_asoc_init(void
>  	ssc = ssc_request(0);
>  	if (IS_ERR(ssc)) {
>  		ret = PTR_ERR(ssc);
> -		ssc = NULL;
>  		goto err_ssc;
>  	}
>  	ssc_p->ssc = ssc;
> @@ -476,10 +475,7 @@ err_pll0:
>  		_gclk0 = NULL;
>  	}
>  err_gclk0:
> -	if (ssc != NULL) {
> -		ssc_free(ssc);
> -		ssc = NULL;
> -	}
> +	ssc_free(ssc);
