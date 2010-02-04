Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab0BDHIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 02:08:53 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:47693 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab0BDHIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 02:08:52 -0500
Date: Wed, 3 Feb 2010 23:08:47 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: [2.6.33-rc6-git regression] idr fix breaks Xorg
Message-ID: <20100204070847.GM15124@hexapodia.org>
References: <20100204012837.GC538@hexapodia.org> <4B6A3AED.1000102@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6A3AED.1000102@kernel.org>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 12:11:41PM +0900, Tejun Heo wrote:
> On 02/04/2010 10:28 AM, Andy Isaacson wrote:
> > On my Dell Latitude e4300 commit 859ddf0974 ("idr: fix a critical
> > misallocation bug") causes Xorg to segfault with the following
> > backtrace:
> 
> Does the following patch make any difference?
> 
> diff --git a/lib/idr.c b/lib/idr.c
> index ba7d37c..a96c604 100644
> --- a/lib/idr.c
> +++ b/lib/idr.c
> @@ -140,7 +140,8 @@ static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
>  	id = *starting_id;
>   restart:
>  	p = idp->top;
> -	l = p->layer;
> +	l = idp->layers;
> +	pa[l--] = NULL;
>  	while (1) {
>  		/*
>  		 * We run around this while until we reach the leaf node...

Alas, no -- with that patch applied Xorg still segfaults in the same
place.

-andy
