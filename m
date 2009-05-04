Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbZEDXhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbZEDXhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 19:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757976AbZEDXhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 19:37:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46374 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757969AbZEDXhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 19:37:21 -0400
Message-ID: <49FF7BEE.4050107@redhat.com>
Date: Mon, 04 May 2009 20:36:14 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/21] amd64_edac: add f10-and-later methods-p3
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <1241024107-14535-14-git-send-email-borislav.petkov@amd.com>
In-Reply-To: <1241024107-14535-14-git-send-email-borislav.petkov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov escreveu:
> From: Doug Thompson <dougthompson@xmission.com>
>
> Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  drivers/edac/amd64_edac.c |  318 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 318 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index fe2342c..84075c0 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -2726,4 +2726,322 @@ static int f10_lookup_addr_in_dct(u32 InputAddr, u32 NodeID, u32 ChannelSelect)
>  	return CSFound;
>  }
>  
> +/*
> + * f10_match_to_this_node
> + *
> + * For a given 'DramRange' value, check if 'SystemAddr' fall within this value
> + */
> +static int f10_match_to_this_node(struct amd64_pvt *pvt, int DramRange,
> +				u64 SystemAddr,
> +				int *node_id,
> +				int *channel_select)
> +{
> +	int CSFound = -1;
>   

As in the previous patch, please use a standard error code, instead of -1.

> +static int f10_translate_sysaddr_to_CS(struct amd64_pvt *pvt,
> +			u64 SysAddr,
> +			int *node,
> +			int *chanSel)
> +{
> +	int DramRange;
> +	int CSFound = -1;
>   
Same here.

Cheers,
Mauro
