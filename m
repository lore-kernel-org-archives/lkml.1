Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbZKTTIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbZKTTIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 14:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbZKTTIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 14:08:53 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:51554 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbZKTTIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:08:53 -0500
Subject: Re: [PATCH 1/1] twl4030-regulator: Remove regulator from all
 groups when disabling
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Samuel Ortiz <sameo@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "\\\"De-Schrijver Peter (Nokia-D/Helsinki)\\\"" 
	<Peter.De-Schrijver@nokia.com>
In-Reply-To: <1258734559-15594-1-git-send-email-eduardo.valentin@nokia.com>
References: <1258734559-15594-1-git-send-email-eduardo.valentin@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Nov 2009 19:07:59 +0000
Message-ID: <1258744079.3640.435.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-20 at 18:29 +0200, Eduardo Valentin wrote:
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
>  	return twl4030reg_write(info, VREG_GRP, grp);
>  }
>  

Applied.

Thanks

Liam

