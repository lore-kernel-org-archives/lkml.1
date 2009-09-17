Return-Path: <linux-kernel-owner+w=401wt.eu-S1751394AbZIQTrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbZIQTrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 15:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbZIQTrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 15:47:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:34617 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZIQTrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:47:17 -0400
Subject: Re: [PATCH] nfs: fix bdi_unregister() before sb kill
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, trond.myklebust@fys.uio.no
In-Reply-To: <20090917194027.GS23126@kernel.dk>
References: <20090917124233.GJ23126@kernel.dk>
	 <20090917194027.GS23126@kernel.dk>
Content-Type: text/plain
Date: Thu, 17 Sep 2009 21:47:14 +0200
Message-Id: <1253216834.14935.30.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 21:40 +0200, Jens Axboe wrote:
> On Thu, Sep 17 2009, Jens Axboe wrote:
> > Hi,
> > 
> > This can cause a hang on NFS umount, since the bdi gets pruned before we
> > flush any pending dirty IO. Peter, can you check whether it fixes your
> > issue?
> 
> There's another problem with NFS && backing devices. NFS may call
> bdi_destroy() on a bdi without ever called bdi_init(). This was always a
> bad idea, now it's an issue.
> 
> So, Trond, can I safely add a server->flags private flag to indicate
> that we have called bdi_init()? Then nfs_free_server() knows when to
> call bdi_destroy(). Seems like the safest fix, since error handling is
> currently 'just call nfs_free_server()'.

For the record, this makes my NULL pointer deref go away.. :-)


