Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbXIXNHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbXIXNHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbXIXNHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:07:11 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:57398 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbXIXNHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:07:09 -0400
To: matthew@wil.cx
CC: miklos@szeredi.hu, hch@infradead.org, trond.myklebust@fys.uio.no,
       adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20070924125948.GM10625@parisc-linux.org> (message from Matthew
	Wilcox on Mon, 24 Sep 2007 06:59:48 -0600)
Subject: Re: [patch 1/2] VFS: new fgetattr() file operation
References: <E1IZmze-0003q9-00@dorka.pomaz.szeredi.hu> <20070924123640.GA17409@infradead.org> <E1IZnM8-0003sG-00@dorka.pomaz.szeredi.hu> <20070924125948.GM10625@parisc-linux.org>
Message-Id: <E1IZndW-0003uI-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Sep 2007 15:06:06 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > and if that means adding silly rename support so be it.
> > 
> > That's what is done currently.
> > 
> > But it's has various dawbacks, like rmdir doesn't work if there are
> > open files within an otherwise empty directory.
> > 
> > I'd happily accept suggestions on how to deal with this differenty.
> 
> Only sillyrename files with nlink > 1?  I don't see how attributes can
> change anything for a deleted file.

I don't quite understand your suggestion.

A file isn't deleted while there are still links or open files
refering to it.  So getting the attributes for a file with nlink==0 is
perfectly valid while the file is still open.

If a network filesystem protocol can't handle operations (be it data
or metadata) on an unlinked file, we must do sillirenaming, so that
the file is not actually unlinked.

Miklos
