Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbYKKVeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbYKKVeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYKKVeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 16:34:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:40607 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYKKVeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 16:34:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=sEbPcStwZY43zHh50h7b3YNJJgtpk+ayW53MVqbz58Pf6iGUEu0LStwj9/196wXJkZ
         JMeSZ9t2lchAVTlwogkcn4RoZTTgdtfs4d69iHeMsq5+Q5QB8DpFB0fjSYOcP+Vn1cZz
         AZX6vYyn76S9YxlQcmS/kQshIDVCcP2TmnNZE=
Message-ID: <7c86c4470811111334r2562bb1m6e4ecb15848e3835@mail.gmail.com>
Date: Tue, 11 Nov 2008 22:34:04 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: arges@linux.vnet.ibm.com
Subject: Re: [PATCH] perfmon2 add support for ppc970 processors
Cc: perfmon2-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1226015978-19965-1-git-send-email-arges@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226015978-19965-1-git-send-email-arges@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

Patch applied to both perfmon2 and perfmon3 trees.

Thanks.


On Fri, Nov 7, 2008 at 12:59 AM,  <arges@linux.vnet.ibm.com> wrote:
> From: Chris J Arges <arges@linux.vnet.ibm.com>
>
> Allows ppc970(fx,mp,gx) to use the perfmon_power4 module.
> ---
>  arch/powerpc/perfmon/perfmon.c        |    2 +-
>  arch/powerpc/perfmon/perfmon_power4.c |    8 +++++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/perfmon/perfmon.c b/arch/powerpc/perfmon/perfmon.c
> index a14a1e3..f1d93ee 100644
> --- a/arch/powerpc/perfmon/perfmon.c
> +++ b/arch/powerpc/perfmon/perfmon.c
> @@ -284,7 +284,7 @@ char *pfm_arch_get_pmu_module_name(void)
>        case PV_970:
>        case PV_970FX:
>        case PV_970MP:
> -               return "perfmon_ppc970";
> +               return "perfmon_power4";
>        case PV_BE:
>                return "perfmon_cell";
>        }
> diff --git a/arch/powerpc/perfmon/perfmon_power4.c b/arch/powerpc/perfmon/perfmon_power4.c
> index eba9e8c..b262de3 100644
> --- a/arch/powerpc/perfmon/perfmon_power4.c
> +++ b/arch/powerpc/perfmon/perfmon_power4.c
> @@ -57,8 +57,15 @@ static int pfm_power4_probe_pmu(void)
>        unsigned long pvr = mfspr(SPRN_PVR);
>        int ver = PVR_VER(pvr);
>
> -       if ((ver == PV_POWER4) || (ver == PV_POWER4p))
> +       switch (ver) {
> +       case PV_POWER4:
> +       case PV_POWER4p:
> +       case PV_970:
> +       case PV_970FX:
> +       case PV_970MP:
> +       case PV_970GX:
>                return 0;
> +       }
>
>        return -1;
>  }
> --
> 1.5.4.5
>
> Signed-off-by: Chris J Arges <arges@linux.vnet.ibm.com>
>
>
