Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404Ab0ATDMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab0ATDMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 22:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065Ab0ATDMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 22:12:30 -0500
Received: from mail.solarflare.com ([216.237.3.220]:7879 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab0ATDM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 22:12:29 -0500
Subject: Re: [PATCH] sfc: EFX_ETHTOOL_STAT calculates the offset of the
 efx##source_name's field in both cases
From: Ben Hutchings <bhutchings@solarflare.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
       Steve Hodgson <shodgson@solarflare.com>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <4B56659E.3040001@gmail.com>
References: <4B56659E.3040001@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 20 Jan 2010 03:12:19 +0000
Message-ID: <1263957139.6090.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2010 03:13:21.0565 (UTC) FILETIME=[855994D0:01CA997E]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17140.005
X-TM-AS-Result: No--13.678400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 03:08 +0100, Roel Kluin wrote:
> EFX_ETHTOOL_STAT calculated the offset of the efx##source_name's field
> Regardless of whether that field was NULL.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> This looks like a bug, but I am not sure whether I understood this correctly,
> nor was it tested, was this intended?

The condition is really a type check.  The result should be the same
regardless of whether it is true.

Ben.

> diff --git a/drivers/net/sfc/ethtool.c b/drivers/net/sfc/ethtool.c
> index 6c0bbed..722bac7 100644
> --- a/drivers/net/sfc/ethtool.c
> +++ b/drivers/net/sfc/ethtool.c
> @@ -41,7 +41,7 @@ struct efx_ethtool_stat {
>  	.source = EFX_ETHTOOL_STAT_SOURCE_##source_name,		\
>  	.offset = ((((field_type *) 0) ==				\
>  		      &((struct efx_##source_name *)0)->field) ?	\
> -		    offsetof(struct efx_##source_name, field) :		\
> +		    offsetof(struct efx_##stat_name, field) :		\
>  		    offsetof(struct efx_##source_name, field)),		\
>  	.get_stat = get_stat_function,					\
>  }

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

