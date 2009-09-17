Return-Path: <linux-kernel-owner+w=401wt.eu-S1751653AbZIQTsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbZIQTsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 15:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbZIQTsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 15:48:00 -0400
Received: from brick.kernel.dk ([93.163.65.50]:58296 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbZIQTr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:47:59 -0400
Date: Thu, 17 Sep 2009 21:48:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, trond.myklebust@fys.uio.no
Subject: Re: [PATCH] nfs: fix bdi_unregister() before sb kill
Message-ID: <20090917194802.GT23126@kernel.dk>
References: <20090917124233.GJ23126@kernel.dk> <20090917194027.GS23126@kernel.dk> <1253216834.14935.30.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253216834.14935.30.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17 2009, Peter Zijlstra wrote:
> On Thu, 2009-09-17 at 21:40 +0200, Jens Axboe wrote:
> > On Thu, Sep 17 2009, Jens Axboe wrote:
> > > Hi,
> > > 
> > > This can cause a hang on NFS umount, since the bdi gets pruned before we
> > > flush any pending dirty IO. Peter, can you check whether it fixes your
> > > issue?
> > 
> > There's another problem with NFS && backing devices. NFS may call
> > bdi_destroy() on a bdi without ever called bdi_init(). This was always a
> > bad idea, now it's an issue.
> > 
> > So, Trond, can I safely add a server->flags private flag to indicate
> > that we have called bdi_init()? Then nfs_free_server() knows when to
> > call bdi_destroy(). Seems like the safest fix, since error handling is
> > currently 'just call nfs_free_server()'.
> 
> For the record, this makes my NULL pointer deref go away.. :-)

Good, now I just need Trond to either barf (and suggest an alternative),
or sign-off on the patch...

-- 
Jens Axboe

