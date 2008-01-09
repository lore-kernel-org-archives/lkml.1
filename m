Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbYAII6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbYAII6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 03:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYAII6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 03:58:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:65065 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYAII6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 03:58:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=S7t0uQ5jxhdmtavZsNeD/ohfF52RNjGJevQzMEUpuRO00Ie7u+bI3+pmRJdUL6eBZ/ULtxiV+sP76V7AhLYiRF7yMwTsrtz9KtIHdNXHxTpzCC90T3KBCLpAFZSoukK9QD77qlwENGH1PvsMnR2xtcsOYkJIZ/mPa0w7WVfws1s=
Date: Wed, 9 Jan 2008 10:04:42 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mingo@elte.hu, akpm@linux-foundation.org, just.for.lkml@googlemail.com,
       tomof@acm.org, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org, neilb@suse.de, bfields@fieldses.org,
       netdev@vger.kernel.org, tom@opengridcomputing.com
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20080109090442.GA1746@ff.dom.local>
References: <64bb37e0801061203l503f29f0hd922a1347f8169ac@mail.gmail.com> <20080107151639P.fujita.tomonori@lab.ntt.co.jp> <20080108155948.GC26114@elte.hu> <20080109085753O.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109085753O.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 08:57:53AM +0900, FUJITA Tomonori wrote:
...
> diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
> new file mode 100644
> index 0000000..495575a
> --- /dev/null
> +++ b/lib/iommu-helper.c
> @@ -0,0 +1,80 @@
> +/*
> + * IOMMU helper functions for the free area management
> + */
> +
> +#include <linux/module.h>
> +#include <linux/bitops.h>
> +
> +static unsigned long find_next_zero_area(unsigned long *map,
> +					 unsigned long size,
> +					 unsigned long start,
> +					 unsigned int nr,
> +					 unsigned long align_mask)
> +{
> +	unsigned long index, end, i;
> +again:
> +	index = find_next_zero_bit(map, size, start);
> +
> +	/* Align allocation */
> +	index = (index + align_mask) & ~align_mask;
> +
> +	end = index + nr;
> +	if (end >= size)
> +		return -1;

This '>=' looks doubtful to me, e.g.:
map points to 0s only,  size = 64, nr = 64,
we get: index = 0; end = 64;
and: return -1 ?!

Regards,
Jarek P.
