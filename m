Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbYIJTcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbYIJTcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYIJTb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:31:56 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37252 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbYIJTb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:31:56 -0400
Subject: Re: [RFC v4][PATCH 5/9] Memory managemnet (restore)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <1220946154-15174-6-git-send-email-orenl@cs.columbia.edu>
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>
	 <1220946154-15174-6-git-send-email-orenl@cs.columbia.edu>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 12:31:23 -0700
Message-Id: <1221075083.6781.34.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-09 at 03:42 -0400, Oren Laadan wrote:
> +/**
> + * cr_vma_read_pages_vaddrs - read addresses of pages to page-array chain
> + * @ctx - restart context
> + * @npages - number of pages
> + */
> +static int cr_vma_read_pages_vaddrs(struct cr_ctx *ctx, int npages)
> +{
> +	struct cr_pgarr *pgarr;
> +	int nr, ret;
> +
> +	while (npages) {
> +		pgarr = cr_pgarr_prep(ctx);
> +		if (!pgarr)
> +			return -ENOMEM;
> +		nr = min(npages, (int) pgarr->nr_free);
> +		ret = cr_kread(ctx, pgarr->vaddrs, nr * sizeof(unsigned long));
> +		if (ret < 0)
> +			return ret;
> +		pgarr->nr_free -= nr;
> +		pgarr->nr_used += nr;
> +		npages -= nr;
> +	}
> +	return 0;
> +}

cr_pgarr_prep() can return a partially full pgarr, right?  Won't the
cr_kread() always start at the beginning of the pgarr->vaddrs[] array?
Seems to me like it will clobber things from the last call.

-- Dave

