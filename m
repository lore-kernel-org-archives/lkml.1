Return-Path: <linux-kernel-owner+w=401wt.eu-S1422714AbXBUS3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422714AbXBUS3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422774AbXBUS3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:29:39 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:40890 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422714AbXBUS3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:29:38 -0500
To: trond.myklebust@fys.uio.no
CC: akpm@linux-foundation.org, staubach@redhat.com, hugh@veritas.com,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-reply-to: <1172081562.9108.1.camel@heimdal.trondhjem.org> (message from
	Trond Myklebust on Wed, 21 Feb 2007 13:12:42 -0500)
Subject: Re: [PATCH] update ctime and mtime for mmaped write
References: <E1HJvdA-0003Nj-00@dorka.pomaz.szeredi.hu> <1172081562.9108.1.camel@heimdal.trondhjem.org>
Message-Id: <E1HJwCl-0003V6-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 21 Feb 2007 19:28:39 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > This flag is checked in msync() and __fput(), and if set, the file
> > times are updated and the flag is cleared
> 
> Why not also check inside vfs_getattr?

This is the minimum, that the standard asks for.

Note, your porposal would touch the times in vfs_getattr(), which
means, that the modification times would depend on the time of the
last stat() call, which is not really right, though it would still be
conforming.

It is much saner, if the modification time is always the time of the
last write() or msync().

Miklos
