Return-Path: <linux-kernel-owner+w=401wt.eu-S1758903AbZDWO5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903AbZDWO5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 10:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758930AbZDWO5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 10:57:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43117 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758725AbZDWO5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 10:57:02 -0400
Date: Thu, 23 Apr 2009 15:57:01 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: "Peter 'p2' De Schrijver" <peter.de-schrijver@nokia.com>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       lrg@slimlogic.co.uk
Subject: Re: [PATCH 1/1] TWL4030: Activate VDD1, VDD2 and VPLL1 at startup
Message-ID: <20090423145701.GV30105@sirena.org.uk>
References: <1240492208-14791-1-git-send-email-peter.de-schrijver@nokia.com> <1240492208-14791-2-git-send-email-peter.de-schrijver@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240492208-14791-2-git-send-email-peter.de-schrijver@nokia.com>
X-Cookie: My vaseline is RUNNING...
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 04:10:08PM +0300, Peter 'p2' De Schrijver wrote:
> This patch activates VDD1, VDD2 and VPLL1 when booting. This is necessary
> because these resources are in warm reset state after a reboot. This means
> their voltage levels cannot be modified so DVFS and smartreflex don't work.

> Signed-off-by: Peter 'p2' De Schrijver <peter.de-schrijver@nokia.com>

Adding Liam again.

> ---
>  drivers/regulator/twl4030-regulator.c |   18 +++++++++++++++++-
>  1 files changed, 17 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl4030-regulator.c
> index 80a4e10..ab2a726 100644
> --- a/drivers/regulator/twl4030-regulator.c
> +++ b/drivers/regulator/twl4030-regulator.c
> @@ -506,6 +506,22 @@ static int twl4030reg_probe(struct platform_device *pdev)
>  	}
>  	platform_set_drvdata(pdev, rdev);
>  
> +	/* VDD1, VDD2 and VPLL1 are left in warm reset state after a reboot.
> +	 * We need to put them back to active state for DVFS and smartreflex.
> +	 */
> +
> +	if (twl4030_send_pb_msg(MSG_SINGULAR(DEV_GRP_P1, RES_VDD1,
> +		RES_STATE_ACTIVE)) < 0)
> +		pr_err("Unable to activate VDD1\n");
> +
> +	if (twl4030_send_pb_msg(MSG_SINGULAR(DEV_GRP_P1, RES_VDD2,
> +		RES_STATE_ACTIVE)) < 0)
> +		pr_err("Unable to activate VDD2\n");
> +
> +	if (twl4030_send_pb_msg(MSG_SINGULAR(DEV_GRP_P1, RES_VPLL1,
> +		RES_STATE_ACTIVE)) < 0)
> +		pr_err("Unable to activate VPLL1\n");
> +
>  	/* NOTE:  many regulators support short-circuit IRQs (presentable
>  	 * as REGULATOR_OVER_CURRENT notifications?) configured via:
>  	 *  - SC_CONFIG
> -- 
> 1.5.6.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
"You grabbed my hand and we fell into it, like a daydream - or a fever."
