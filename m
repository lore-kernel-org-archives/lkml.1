Return-Path: <linux-kernel-owner+w=401wt.eu-S1751558AbZG3Oxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbZG3Oxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZG3Oxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:53:41 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:41751 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbZG3Oxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:53:39 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 4/5] net/netlabel: Add kmalloc NULL tests
Date: Thu, 30 Jul 2009 10:53:37 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.30-gentoo-r1; KDE/4.2.4; i686; ; )
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0907301610230.8734@ask.diku.dk> <200907301032.20318.paul.moore@hp.com> <Pine.LNX.4.64.0907301637570.8734@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0907301637570.8734@ask.diku.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907301053.37416.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 July 2009 10:38:19 am Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
>
> The test on map4 should be a test on map6.
>
> The semantic match that finds this problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
>
> // <smpl>
> @@
> expression *x;
> identifier f;
> constant char *C;
> @@
>
> x = \(kmalloc\|kcalloc\|kzalloc\)(...);
> ... when != x == NULL
>     when != x != NULL
>     when != (x || ...)
> (
> kfree(x)
>
> f(...,C,...,x,...)
>
> *f(...,x,...)
>
> *x->f
> )
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>

Much better, thank you.

Acked-by: Paul Moore <paul.moore@hp.com>

> ---
>  net/netlabel/netlabel_kapi.c        |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
> index 3ff6f32..6ce0020 100644
> --- a/net/netlabel/netlabel_kapi.c
> +++ b/net/netlabel/netlabel_kapi.c
> @@ -151,7 +151,7 @@ int netlbl_cfg_unlbl_map_add(const char *domain,
>  			addr6 = addr;
>  			mask6 = mask;
>  			map6 = kzalloc(sizeof(*map6), GFP_ATOMIC);
> -			if (map4 == NULL)
> +			if (map6 == NULL)
>  				goto cfg_unlbl_map_add_failure;
>  			map6->type = NETLBL_NLTYPE_UNLABELED;
>  			ipv6_addr_copy(&map6->list.addr, addr6);

-- 
paul moore
linux @ hp

