Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbXIXNi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbXIXNi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbXIXNit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:38:49 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:41080 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbXIXNis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:38:48 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, hch@infradead.org, matthew@wil.cx,
       trond.myklebust@fys.uio.no, adilger@clusterfs.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20070924132725.GA20116@infradead.org> (message from Christoph
	Hellwig on Mon, 24 Sep 2007 14:27:25 +0100)
Subject: Re: [patch 1/2] VFS: new fgetattr() file operation
References: <E1IZmze-0003q9-00@dorka.pomaz.szeredi.hu> <20070924123640.GA17409@infradead.org> <E1IZnM8-0003sG-00@dorka.pomaz.szeredi.hu> <20070924125948.GM10625@parisc-linux.org> <E1IZndW-0003uI-00@dorka.pomaz.szeredi.hu> <20070924131047.GA19017@infradead.org> <E1IZnpC-0003vk-00@dorka.pomaz.szeredi.hu> <20070924132725.GA20116@infradead.org>
Message-Id: <E1IZo8U-0003xW-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Sep 2007 15:38:06 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Sep 24, 2007 at 03:18:10PM +0200, Miklos Szeredi wrote:
> > > Or not support such a broken protocol at all.
> > 
> > Wonder what people would say if we removed support for NFSv[23].
> > 
> > Just because a protocol does not support "perfect" UNIX semantics, it
> > doesn't mean it's broken.  By that standard almost all network
> > filesystem protocols are severely broken.
> 
> Well, they are broken by these and other standards.  At least nfs and
> cifs maintainers do the workarounds for this brokeness where they belong.

And my patch is not working around a problem, rather solving a problem
in a correct way.

Let me summarise it:

There are valid reasons we have fstat() in addition to stat/lstat.
For example we want to protect agains races involving unlink/rename on
an open file.

Say I want to implement a network filesystem with a pure unprivileged
userspace sever (this is basically what sshfs does).

I want my filesystem client implementation to keep all these
advantages of fstat().  So how can I do that?  There's a simple way:
implement this operation with fstat() on the server.  I get all the
advantages on the remote system automatically.

But for that the filesystem needs to have the open file that the
fstat() on the client was performed on.

It's that simple.  There's really no ugly hacks going on behind the
scenes.  It's just that we do want to delegate some properties of this
operation onto the server, and the simplest and best implementation is
to just let the filesystem have the information it needs.

Why is that such a big problem?

Miklos
