Return-Path: <linux-kernel-owner+w=401wt.eu-S971432AbXEIAm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971432AbXEIAm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 20:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S971354AbXEIAml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 20:42:41 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S971348AbXEIAmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 20:42:39 -0400
Date: Tue, 8 May 2007 17:41:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Heinz Mauelshagen <hjm@redhat.com>
Subject: Re: [2.6.22 PATCH 22/26] dm: bio list helpers
Message-Id: <20070508174159.7d78a275.akpm@linux-foundation.org>
In-Reply-To: <20070508194845.GC24114@agk.fab.redhat.com>
References: <20070508194845.GC24114@agk.fab.redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 20:48:45 +0100
Alasdair G Kergon <agk@redhat.com> wrote:

> +#define BIO_LIST_INIT { .head = NULL, .tail = NULL }
> +
> +#define BIO_LIST(bl) \
> +	struct bio_list bl = BIO_LIST_INIT

BIO_LIST is a strange name for something which initialises storage.

>  static inline void bio_list_init(struct bio_list *bl)
>  {
>  	bl->head = bl->tail = NULL;
>  }
>  
> +#define bio_list_for_each(bio, bl) \
> +	for (bio = (bl)->head; bio && ({ prefetch(bio->bi_next); 1; }); \
> +	     bio = bio->bi_next)
> +

I have this vague memory from a long time ago that one particular CPU type
wants to go oops when prefetching from an invalid address.

Maybe that went away for some reason - we'd have hit it again if it was
real.

