Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbYKDTRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbYKDTRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbYKDTRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:17:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751636AbYKDTRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:17:35 -0500
Date: Tue, 4 Nov 2008 11:16:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu,
       fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, osd-dev@open-osd.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sami.Iren@seagate.com, pw@padd.com
Subject: Re: [PATCH 04/18] libosd: OSDv1 preliminary implementation
Message-Id: <20081104111631.5eb9aaf6.akpm@linux-foundation.org>
In-Reply-To: <1225817069-5969-1-git-send-email-bharrosh@panasas.com>
References: <491073BB.4000900@panasas.com>
	<1225817069-5969-1-git-send-email-bharrosh@panasas.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Nov 2008 18:44:29 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> Implementation of the most basic OSD functionality and
> infrastructure. Mainly Format, Create/Remove Partition,
> Create/Remove Object, and read/write.
> 
>
> ...
>
> +struct osd_request *_osd_request_alloc(gfp_t gfp)
> +{
> +	struct osd_request *or;
> +
> +	/* TODO: Use mempool with one saved request */
> +	or = kzalloc(sizeof(*or), gfp);
> +	return or;
> +}
> +
> +void _osd_request_free(struct osd_request *or)
> +{
> +	kfree(or);
> +}

These two functions can/should be made static.  Please generally check
for this.

Also it'd probably make sense to declare both these inline.  The
compiler _shoudl_ get it right, but stranger things have happened...

>
> ...
>
> +/*
> + * If osd_finalize_request() was called but the request was not executed through
> + * the block layer, then we must release BIOs.
> + */
> +static void _abort_unexecuted_bios(struct request *rq)
> +{
> +	struct bio *bio;
> +
> +	while ((bio = rq->bio) != NULL) {
> +		rq->bio = bio->bi_next;
> +		bio_endio(bio, 0);
> +	}
> +}

Boy, that's a scary function.  bye-bye data.


