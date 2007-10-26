Return-Path: <linux-kernel-owner+w=401wt.eu-S1765178AbXJZQlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765178AbXJZQlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763971AbXJZQgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:36:46 -0400
Received: from pat.uio.no ([129.240.10.15]:47876 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763626AbXJZQgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:36:41 -0400
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, greg@kroah.com,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <1193410087.6914.34.camel@twins>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <3ae72650710020421t711caaa8o13d2e685a98e5fe8@mail.gmail.com>
	 <1191325226.13204.63.camel@twins>
	 <200710022205.05295.nickpiggin@yahoo.com.au>
	 <1191406506.4093.35.camel@lov.localdomain>  <1191407872.5572.7.camel@lappy>
	 <1191418525.4093.87.camel@lov.localdomain> <1193410087.6914.34.camel@twins>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 12:37:23 -0400
Message-Id: <1193416643.7486.8.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.092)
X-UiO-Scanned: 274FDB621CD868683F5A979EEFA82EB84FFBEBB6
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 433 total 4744925 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-26 at 16:48 +0200, Peter Zijlstra wrote:

> Miklos, Trond: could you suggest a better fmt for the bdi_init_fmt() for your
> respective filesystems?
<snip>
> Index: linux-2.6-2/fs/nfs/client.c
> ===================================================================
> --- linux-2.6-2.orig/fs/nfs/client.c
> +++ linux-2.6-2/fs/nfs/client.c
> @@ -678,7 +678,7 @@ static int nfs_probe_fsinfo(struct nfs_s
>  		goto out_error;
>  
>  	nfs_server_set_fsinfo(server, &fsinfo);
> -	error = bdi_init(&server->backing_dev_info);
> +	error = bdi_init_fmt(&server->backing_dev_info, "nfs-%s-%p", clp->cl_hostname, server);

In our debugging printks, we usually use the superblock->s_id, but that
only gets initialised later.

I'd suggest passing the 'dev_name' from *_get_sb() into
*_create_server().

Cheers
  Trond

