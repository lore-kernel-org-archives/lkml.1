Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbXLNOvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbXLNOvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 09:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbXLNOvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 09:51:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60737 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbXLNOvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 09:51:09 -0500
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Peter Zijlstra <peterz@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, greg@kroah.com,
       Miklos Szeredi <miklos@szeredi.hu>, Neil Brown <neilb@suse.de>
In-Reply-To: <1193416643.7486.8.camel@heimdal.trondhjem.org>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <3ae72650710020421t711caaa8o13d2e685a98e5fe8@mail.gmail.com>
	 <1191325226.13204.63.camel@twins>
	 <200710022205.05295.nickpiggin@yahoo.com.au>
	 <1191406506.4093.35.camel@lov.localdomain>  <1191407872.5572.7.camel@lappy>
	 <1191418525.4093.87.camel@lov.localdomain> <1193410087.6914.34.camel@twins>
	 <1193416643.7486.8.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 15:50:56 +0100
Message-Id: <1197643856.21927.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-26 at 12:37 -0400, Trond Myklebust wrote:
> On Fri, 2007-10-26 at 16:48 +0200, Peter Zijlstra wrote:
> 
> > Miklos, Trond: could you suggest a better fmt for the bdi_init_fmt() for your
> > respective filesystems?
> <snip>
> > Index: linux-2.6-2/fs/nfs/client.c
> > ===================================================================
> > --- linux-2.6-2.orig/fs/nfs/client.c
> > +++ linux-2.6-2/fs/nfs/client.c
> > @@ -678,7 +678,7 @@ static int nfs_probe_fsinfo(struct nfs_s
> >  		goto out_error;
> >  
> >  	nfs_server_set_fsinfo(server, &fsinfo);
> > -	error = bdi_init(&server->backing_dev_info);
> > +	error = bdi_init_fmt(&server->backing_dev_info, "nfs-%s-%p", clp->cl_hostname, server);
> 
> In our debugging printks, we usually use the superblock->s_id, but that
> only gets initialised later.
> 
> I'd suggest passing the 'dev_name' from *_get_sb() into
> *_create_server().

I just realised that such a name would contain '/' and I'm quite sure
that makes filesystems unhappy.

Neil suggested using device numbers which would work, however I think
those might not be human friendly. While its easy to find the device
number of a given path (eg.: stat -c %d /), its rather hard to find the
path belonging to a given device number.



