Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbZBLCvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbZBLCvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 21:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZBLCuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 21:50:54 -0500
Received: from ns1.suse.de ([195.135.220.2]:37175 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbZBLCux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 21:50:53 -0500
From: "NeilBrown" <neilb@suse.de>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Date: Thu, 12 Feb 2009 13:50:38 +1100 (EST)
Message-ID: <2540bee2375afb6f08eb92d19e7a1bf0.squirrel@neil.brown.name>
In-Reply-To: <1234401418.5566.19.camel@brick>
References: <1234401418.5566.19.camel@brick>
Subject: Re: [PATCH] nfs: replace uses of __constant_{endian}
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, February 12, 2009 12:16 pm, Harvey Harrison wrote:
> The base versions handle constant folding now, none of these headers
> are exported to userspace, so the __ prefixed versions are not
> necessary.

I assume you compile tested this?

I seem to recall that the reason we did it that way was that
some of the error codes are used in switch statements, and
the value for a 'case:' really has to look like a constant, not just
happen to evaluate to one.

However if it really does work with all supported compilers
this way, then its a nice improvement, thanks.

NeilBrown


>
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  include/linux/lockd/xdr.h  |   12 ++--
>  include/linux/lockd/xdr4.h |   10 ++--
>  include/linux/nfsd/nfsd.h  |  132
> ++++++++++++++++++++++----------------------
>  include/linux/sunrpc/xdr.h |   42 +++++++-------
>  4 files changed, 98 insertions(+), 98 deletions(-)
>
> diff --git a/include/linux/lockd/xdr.h b/include/linux/lockd/xdr.h
> index 7dc5b6c..d39ed1c 100644
> --- a/include/linux/lockd/xdr.h
> +++ b/include/linux/lockd/xdr.h
> @@ -25,13 +25,13 @@ struct svc_rqst;
>  #define NLM_MAXCOOKIELEN    	32
>  #define NLM_MAXSTRLEN		1024
>
> -#define	nlm_granted		__constant_htonl(NLM_LCK_GRANTED)
> -#define	nlm_lck_denied		__constant_htonl(NLM_LCK_DENIED)
> -#define	nlm_lck_denied_nolocks	__constant_htonl(NLM_LCK_DENIED_NOLOCKS)
> -#define	nlm_lck_blocked		__constant_htonl(NLM_LCK_BLOCKED)
> -#define	nlm_lck_denied_grace_period	__constant_htonl(NLM_LCK_DENIED_GRACE_PERIOD)
> +#define	nlm_granted		cpu_to_be32(NLM_LCK_GRANTED)
> +#define	nlm_lck_denied		cpu_to_be32(NLM_LCK_DENIED)
> +#define	nlm_lck_denied_nolocks	cpu_to_be32(NLM_LCK_DENIED_NOLOCKS)
> +#define	nlm_lck_blocked		cpu_to_be32(NLM_LCK_BLOCKED)
> +#define	nlm_lck_denied_grace_period	cpu_to_be32(NLM_LCK_DENIED_GRACE_PERIOD)
>
> -#define nlm_drop_reply		__constant_htonl(30000)
> +#define nlm_drop_reply		cpu_to_be32(30000)
>

