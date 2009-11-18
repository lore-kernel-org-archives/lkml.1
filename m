Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbZKRRvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbZKRRvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757976AbZKRRvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:51:31 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:58288 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984AbZKRRva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:51:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VH1ruFDFZ1diNkcZMgms1NaYkoESDzvB7FI8OQufmlENbLzRXOlamOQ+heWTG18std
         cqGtcvcMfD99SFOxSVgDYDEQBO9STnzUxjJFs5n/jQsC3ITgDuTkmTOqAmJx6CO4uZuu
         3W+2bNt4nCexJhtZDLSHd64fm08XSDckiR+v4=
Date: Wed, 18 Nov 2009 09:51:31 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "tony@atomide.com" <tony@atomide.com>,
       "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>,
       "amit.kucheria@verdurent.com" <amit.kucheria@verdurent.com>,
       "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "Kristo Tero (Nokia-D/Tampere)" <Tero.Kristo@nokia.com>
Subject: Re: [PATCH 1/1] Add all TWL4030 regulators to Regulator framework
Message-ID: <20091118175131.GC4458@core.coreip.homeip.net>
References: <4B03DE53.6010007@nokia.com> <4B03DE9B.40800@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B03DE9B.40800@nokia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 01:46:35PM +0200, Juha Keski-Saari wrote:
> This patch adds all the remaining TWL4030 regulators into the implementation,
> also adding VINT* regulators in this way since they can be derived out from
> the TWL
>
> Signed-off-by: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
> ---
>  drivers/mfd/twl4030-core.c            |   30 ++++++++++++++++++++++++++----
>  drivers/regulator/twl4030-regulator.c |   27 +++++++++++++++++----------
>  include/linux/i2c/twl4030.h           |    8 ++++++--
>  3 files changed, 49 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
> index a1c47ee..0748b43 100644
> --- a/drivers/mfd/twl4030-core.c
> +++ b/drivers/mfd/twl4030-core.c
> @@ -602,13 +602,15 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
>  	}
>
>  	if (twl_has_regulator()) {
> -		/*
> -		child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1);
> +		child = add_regulator(TWL4030_REG_VDD1, pdata->vdd1);
>  		if (IS_ERR(child))
>  			return PTR_ERR(child);
> -		*/
>
> -		child = add_regulator(TWL4030_REG_VMMC1, pdata->vmmc1);
> +		child = add_regulator(TWL4030_REG_VDD2, pdata->vdd2);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
> +
> +		child = add_regulator(TWL4030_REG_VIO, pdata->vio);
>  		if (IS_ERR(child))
>  			return PTR_ERR(child);

Not specifically targeted at this patch - this driver error handling is
severely lacking and leaves bund of devices behind when one of them
fails to be added.

-- 
Dmitry
