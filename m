Return-Path: <linux-kernel-owner+w=401wt.eu-S1759586AbXIXNWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586AbXIXNWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757338AbXIXNW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:22:28 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:50090 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbXIXNW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:22:27 -0400
To: matthew@wil.cx
CC: miklos@szeredi.hu, hch@infradead.org, trond.myklebust@fys.uio.no,
       adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20070924131615.GN10625@parisc-linux.org> (message from Matthew
	Wilcox on Mon, 24 Sep 2007 07:16:15 -0600)
Subject: Re: [patch 1/2] VFS: new fgetattr() file operation
References: <E1IZmze-0003q9-00@dorka.pomaz.szeredi.hu> <20070924123640.GA17409@infradead.org> <E1IZnM8-0003sG-00@dorka.pomaz.szeredi.hu> <20070924125948.GM10625@parisc-linux.org> <E1IZndW-0003uI-00@dorka.pomaz.szeredi.hu> <20070924131615.GN10625@parisc-linux.org>
Message-Id: <E1IZnsm-0003vx-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Sep 2007 15:21:52 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Sep 24, 2007 at 03:06:06PM +0200, Miklos Szeredi wrote:
> > A file isn't deleted while there are still links or open files
> > refering to it.  So getting the attributes for a file with nlink==0 is
> > perfectly valid while the file is still open.
> 
> Is it?  Why not just pretend that the attributes are wiped when the file
> is deleted.

You mean "when finally unlinked"?  Delete happens when the file is
closed.

> Effectively, they are, since they can't affect anything.

Sure it can.  It may be open on the server as well.

> > If a network filesystem protocol can't handle operations (be it data
> > or metadata) on an unlinked file, we must do sillirenaming, so that
> > the file is not actually unlinked.
> 
> Or you could call getattr right before you unlink and cache the result
> in the client.

The file can still be modified after being unlinked.

And even if we did this caching thing and modify the attributes when
the file is modified, it would not deal with access on the remote end,
and would be much more complex than the other alternatives.

Miklos
