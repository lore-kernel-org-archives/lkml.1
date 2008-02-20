Return-Path: <linux-kernel-owner+w=401wt.eu-S932152AbYBTRQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbYBTRQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbYBTRQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:16:41 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:56007 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbYBTRQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:16:40 -0500
Message-ID: <47BC6073.8080705@garzik.org>
Date: Wed, 20 Feb 2008 12:16:35 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ata: replace macro with static inline in libata.h
References: <1203350873.5757.23.camel@brick>
In-Reply-To: <1203350873.5757.23.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Avoid ~70 sparse warnings like:
> drivers/ata/pata_ali.c:176:14: warning: symbol '__x' shadows an earlier one
> drivers/ata/pata_ali.c:176:14: originally declared here
> 
> Due to nesting min_t macro inside max_t macro which both use a __x
> identifier internally.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Andrew, here is a patch that drastically reduces the number of sparse
> warnings in libata.  Alan Cox has suggested a clamp_t macro be added
> to kernel.h instead to avoid this issue.  I don't believe Jeff Garzik
> has given an opinion yet (other than not applying it when originally
> sent this was 5/11 of the libata sparse warnings)
> 
>  include/linux/libata.h |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index bc5a8d0..b5590fb 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -764,7 +764,14 @@ struct ata_timing {
>  	unsigned short udma;		/* t2CYCTYP/2 */
>  };
>  
> -#define FIT(v, vmin, vmax)	max_t(short, min_t(short, v, vmax), vmin)
> +static inline short FIT(short v, short vmin, short vmax)
> +{
> +	if (v >= vmax)
> +		return vmax;
> +	if (v <= vmin)
> +		return vmin;
> +	return v;
> +}

I agree with Alan...


