Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbZIIQvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbZIIQvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 12:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZIIQvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 12:51:08 -0400
Received: from fifo99.com ([67.223.236.141]:48956 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbZIIQvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 12:51:07 -0400
Subject: Re: [PATCH] aoe: end barrier bios with EOPNOTSUPP
From: Daniel Walker <dwalker@fifo99.com>
To: Ed Cashin <ecashin@coraid.com>
Cc: jens.axboe@oracle.com, akpm@linux-foundation.org, apw@canonical.com,
       bonbons@linux-vserver.org, linux-kernel@vger.kernel.org
In-Reply-To: <60772f633c524ba873f569966fccd6ce@coraid.com>
References: <200909021955.n82JtkrI032267@imap1.linux-foundation.org>
	 <20090903063539.GH12579@kernel.dk>
	 <2339aa04a4e8fb440a52624273728352@coraid.com>
	 <20090904183525.GB18599@kernel.dk>
	 <f48e25c99e41e375f2ddd85989cd39e1@coraid.com>
	 <20090905051735.GH18599@kernel.dk>
	 <366469f19c41e0150028b886f6859019@coraid.com>
	 <20090908193540.GB18599@kernel.dk>
	 <60772f633c524ba873f569966fccd6ce@coraid.com>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 09:51:29 -0700
Message-Id: <1252515089.14793.126.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 12:45 -0400, Ed Cashin wrote:
> --- a/drivers/block/aoe/aoeblk.c
> +++ b/drivers/block/aoe/aoeblk.c
> @@ -172,6 +172,9 @@ aoeblk_make_request(struct request_queue *q,
> struct bio *bio)
>                 BUG();
>                 bio_endio(bio, -ENXIO);
>                 return 0;
> +       } else if (bio_barrier(bio)) {
> +                bio_endio(bio, -EOPNOTSUPP);
> +                return 0;
>         } else if (bio->bi_io_vec == NULL) {
>                 printk(KERN_ERR "aoe: bi_io_vec is NULL\n");
>                 BUG();

Could you run this through script/checkpatch.pl and fix any errors you
find.. It looks like your not indenting properly ..

Daniel

