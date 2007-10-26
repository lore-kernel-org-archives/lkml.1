Return-Path: <linux-kernel-owner+w=401wt.eu-S1761548AbXJZPGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761548AbXJZPGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbXJZPGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:06:15 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:52010 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbXJZPGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:06:14 -0400
To: peterz@infradead.org
CC: kay.sievers@vrfy.org, nickpiggin@yahoo.com.au, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       fengguang.wu@gmail.com, greg@kroah.com, trond.myklebust@fys.uio.no,
       miklos@szeredi.hu
In-reply-to: <1193410087.6914.34.camel@twins> (message from Peter Zijlstra on
	Fri, 26 Oct 2007 16:48:07 +0200)
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <3ae72650710020421t711caaa8o13d2e685a98e5fe8@mail.gmail.com>
	 <1191325226.13204.63.camel@twins>
	 <200710022205.05295.nickpiggin@yahoo.com.au>
	 <1191406506.4093.35.camel@lov.localdomain>  <1191407872.5572.7.camel@lappy>
	 <1191418525.4093.87.camel@lov.localdomain> <1193410087.6914.34.camel@twins>
Message-Id: <E1IlQlP-0007W9-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 26 Oct 2007 17:06:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: bdi: debugfs interface
> 
> Expose the BDI stats (and readahead window) in /debug/bdi/
> 
> I'm still thinking it should go into /sys somewhere, however I just noticed
> not all block devices that have a queue have a /queue directory. Noticeably
> those that use make_request_fn() as opposed to request_fn(). And then of
> course there are the non-block/non-queue BDIs.
> 
> A BDI is basically the object that represents the 'thing' you dirty pages
> against. For block devices that is related to the block device (and is
> typically embedded in the queue object), for NFS mounts its the remote server
> object of the client. For FUSE, yet again something else.
> 
> I appreciate the sysfs people their opinion that /sys/bdi/ might not be the
> best from their POV, however I'm not seeing where to hook the BDI object from
> so that it all makes sense, a few of the things are currently not exposed in
> sysfs at all, like the NFS and FUSE things.
> 
> So, for now, I've exposed the thing in debugfs. Please suggest a better
> alternative.
> 
> Miklos, Trond: could you suggest a better fmt for the bdi_init_fmt() for your
> respective filesystems?

For fuse:

	err = bdi_init_fmt(&fc->bdi, "fuse-%llu", (unsigned long long) fc->id);

This would match the connection ID in /sys/fs/fuse/connections/*

Miklos
