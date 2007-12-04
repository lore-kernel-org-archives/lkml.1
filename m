Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbXLDJhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbXLDJhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 04:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbXLDJh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 04:37:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58717 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbXLDJh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 04:37:27 -0500
Date: Tue, 4 Dec 2007 10:37:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Neil Brown <neilb@suse.de>
Cc: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Regression - 2.6.24-rc3 - umem nvram card driver oops
Message-ID: <20071204093716.GB4541@elte.hu>
References: <20071203213558.GP115527101@sgi.com> <18260.39892.215075.795664@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18260.39892.215075.795664@notabene.brown>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Neil Brown <neilb@suse.de> wrote:

> ### Diffstat output
>  ./drivers/block/umem.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff .prev/drivers/block/umem.c ./drivers/block/umem.c
> --- .prev/drivers/block/umem.c	2007-12-04 11:11:30.000000000 +1100
> +++ ./drivers/block/umem.c	2007-12-04 11:11:42.000000000 +1100
> @@ -484,7 +484,8 @@ static void process_page(unsigned long d
>  		page->idx++;
>  		if (page->idx >= bio->bi_vcnt) {
>  			page->bio = bio->bi_next;
> -			page->idx = page->bio->bi_idx;
> +			if (page->bio)
> +				page->idx = page->bio->bi_idx;
>  		}
>  
>  		pci_unmap_page(card->dev, desc->data_dma_handle,

btw., if anyone feels so inclined, this file has quite a number of 
coding style issues, as per scripts/checkpatch.pl output:

 total: 28 errors, 54 warnings, 1221 lines checked

	Ingo
