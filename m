Return-Path: <linux-kernel-owner+w=401wt.eu-S932150AbZGORtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbZGORtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 13:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867AbZGORtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 13:49:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55793 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882AbZGORtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 13:49:14 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: jens.axboe@oracle.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] bio: sizeof pointer instead of size of the pointed-to type?
References: <4A5DE10E.7010005@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 15 Jul 2009 13:49:05 -0400
In-Reply-To: <4A5DE10E.7010005@gmail.com> (Roel Kluin's message of "Wed, 15
	Jul 2009 16:00:46 +0200")
Message-ID: <x49r5whu99q.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin <roel.kluin@gmail.com> writes:

> Do not take the size of a pointer to determine the size of the pointed-to type
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> This is not yet tested. Is it correct?
>
> diff --git a/fs/bio.c b/fs/bio.c
> index 7673800..e65c35d 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -96,7 +96,7 @@ static struct kmem_cache *bio_find_or_create_slab(unsigned int extra_size)
>  	if (bio_slab_nr == bio_slab_max && entry == -1) {
>  		bio_slab_max <<= 1;
>  		bio_slabs = krealloc(bio_slabs,
> -				     bio_slab_max * sizeof(struct bio_slab),
> +				     bio_slab_max * sizeof(struct bio_slab *),
>  				     GFP_KERNEL);
>  		if (!bio_slabs)
>  			goto out_unlock;

NAK.  The code is correct as-is.

Cheers,
Jeff
