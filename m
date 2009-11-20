Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbZKTRJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbZKTRJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbZKTRJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:09:19 -0500
Received: from smtp.nokia.com ([192.100.122.230]:49530 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbZKTRJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:09:15 -0500
Date: Fri, 20 Nov 2009 19:08:55 +0200
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Samuel Ortiz <sameo@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>
Subject: Re: [PATCH 1/1] twl4030-regulator: Remove regulator from all
 groups when disabling
Message-ID: <20091120170855.GA15828@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1258734559-15594-1-git-send-email-eduardo.valentin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258734559-15594-1-git-send-email-eduardo.valentin@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 20 Nov 2009 17:08:58.0841 (UTC) FILETIME=[264C0490:01CA6A04]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 05:29:19PM +0100, Valentin Eduardo (Nokia-D/Helsinki) wrote:
> Just remove regulator from all groups when disabling. This way we
> avoid problems if boot loader touches twl4030 registers.
> 
> Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> ---
>  drivers/regulator/twl4030-regulator.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl4030-regulator.c
> index e2032fb..27b3115 100644
> --- a/drivers/regulator/twl4030-regulator.c
> +++ b/drivers/regulator/twl4030-regulator.c
> @@ -126,7 +126,7 @@ static int twl4030reg_disable(struct regulator_dev *rdev)
>  	if (grp < 0)
>  		return grp;
>  
> -	grp &= ~P1_GRP;
> +	grp &= ~(P1_GRP & P2_GRP | P3_GRP);
                        ^
This has actually a typo. So please ignore it. I'll resend it.

>  	return twl4030reg_write(info, VREG_GRP, grp);
>  }
>  
> -- 
> 1.6.5.7.g9ecb2

-- 
Eduardo Valentin
