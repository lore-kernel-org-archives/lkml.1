Return-Path: <linux-kernel-owner+w=401wt.eu-S1759166AbXIXMtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166AbXIXMtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 08:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757532AbXIXMtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 08:49:13 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:45959 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314AbXIXMtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:49:11 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, hch@infradead.org, trond.myklebust@fys.uio.no,
       adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20070924123640.GA17409@infradead.org> (message from Christoph
	Hellwig on Mon, 24 Sep 2007 13:36:40 +0100)
Subject: Re: [patch 1/2] VFS: new fgetattr() file operation
References: <E1IZmze-0003q9-00@dorka.pomaz.szeredi.hu> <20070924123640.GA17409@infradead.org>
Message-Id: <E1IZnM8-0003sG-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Sep 2007 14:48:08 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Sep 24, 2007 at 02:24:54PM +0200, Miklos Szeredi wrote:
> > Thanks to everyone for the feedback.  Here's two of the VFS patches
> > reworked according to comments.  I also plan to rework the setattr()
> > patch accordingly and perhaps the xattr patch, altough that is the
> > lowest priority.
> > 
> > Christoph, are these OK with you in this form?
> 
> Not at all.  Attribute operations like this have no business at all
> looking at the struct file.  Please fix your dreaded filesystem to
> implement proper unix semantics intead,

It's a fixed protocol, with servers installed on millions of servers.
The protocol is called SFTP and the server is part of the OpenSSH
package.  There's nothing I can change there.

And even if I could change the protocol, it's impossible to implement
full UNIX semantics with a userspace server.  Please think a bit about
it.

> and if that means adding silly rename support so be it.

That's what is done currently.

But it's has various dawbacks, like rmdir doesn't work if there are
open files within an otherwise empty directory.

I'd happily accept suggestions on how to deal with this differenty.

Thanks,
Miklos
