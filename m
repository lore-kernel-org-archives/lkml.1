Return-Path: <linux-kernel-owner+w=401wt.eu-S1762261AbXJDXPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762261AbXJDXPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 19:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbXJDXPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 19:15:22 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:45310 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbXJDXPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 19:15:21 -0400
To: akpm@linux-foundation.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org
In-reply-to: <20071004155505.251fc64c.akpm@linux-foundation.org> (message from
	Andrew Morton on Thu, 4 Oct 2007 15:55:05 -0700)
Subject: Re: [patch 12/12] fuse: add blksize field to fuse_attr
References: <20071002155026.650555479@szeredi.hu>
	<20071002155225.855733621@szeredi.hu> <20071004155505.251fc64c.akpm@linux-foundation.org>
Message-Id: <E1IdZuL-0002ZH-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 05 Oct 2007 01:15:05 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Allow the userspace filesystem to supply a blksize value to be
> > returned by stat() and friends.  If the field is zero, it defaults to
> > the old PAGE_CACHE_SIZE value.
> > 
> 
> Why does fuse need this feature?

There are cases, when the filesystem will be passed the buffer from a
single read or write call, namely:

 1) in 'direct-io' mode (not O_DIRECT), read/write requests don't go
    through the page cache, but go directly to the userspace fs

 2) currently buffered writes are done with single page requests, but
    if Nick's ->perform_write() patch goes it, it will be possible to
    do larger write requests.  But only if the original write() was
    also bigger than a page.


In these cases the filesystem might want to give a hint to the app
about the optimal I/O size.

Miklos
