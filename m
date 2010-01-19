Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645Ab0ASQzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0ASQzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 11:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564Ab0ASQzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 11:55:43 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:42904 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab0ASQzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 11:55:42 -0500
Date: Tue, 19 Jan 2010 10:54:29 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 01/37] x86: move range related operation to one file
In-Reply-To: <1263611228-6751-2-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.00.1001191048480.22304@router.home>
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org> <1263611228-6751-2-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 15 Jan 2010, Yinghai Lu wrote:

<need more text here describing f.e. how you changed the API and merged
some functions doing similar work>

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

> -
> -static int __init cmp_range(const void *x1, const void *x2)
> -{
> -	const struct res_range *r1 = x1;
> -	const struct res_range *r2 = x2;
> -	long start1, start2;
> -
> -	start1 = r1->start;
> -	start2 = r2->start;
> -
> -	return start1 - start2;
> -}


Function is passed to sort() should not be used directly. Maybe add
comments.

> -	static struct res_range range_new[RANGE_NUM];
> +	static struct range range_new[RANGE_NUM];

Renaming res_range -> range. Good but explain.

> -	nr_range = add_range_with_merge(range, nr_range, 0,
> +	nr_range = add_range_with_merge(range, RANGE_NUM, nr_range, 0,
>  					(1ULL<<(20 - PAGE_SHIFT)) - 1);

add_range_with_merge semantics changed. Explain.

>  		update_res(info, start, end, IORESOURCE_IO, 1);
> -		update_range(range, start, end);
> +		subtract_range(range, RANGE_NUM, start, end);

Two functions merged?

> +void subtract_range(struct range *range, int az, u64 start, u64 end)

Subtract range can now do what update_range did? How so?

Looks quite good. Just add some ornaments describing things to make it
clearer.

