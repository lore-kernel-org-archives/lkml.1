Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbXIUOou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbXIUOou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbXIUOom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:44:42 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:45144 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbXIUOol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:44:41 -0400
To: trond.myklebust@fys.uio.no
CC: hch@infradead.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <1190385151.6680.35.camel@heimdal.trondhjem.org> (message from
	Trond Myklebust on Fri, 21 Sep 2007 10:32:31 -0400)
Subject: Re: [patch 3/5] VFS: pass open file to ->xattr()
References: <20070921122343.307289079@szeredi.hu>
	 <20070921123333.247493758@szeredi.hu> <20070921124323.GA8088@infradead.org>
	 <E1IYi74-0001dX-00@dorka.pomaz.szeredi.hu>
	 <20070921130642.GA9431@infradead.org>
	 <E1IYiN2-0001eq-00@dorka.pomaz.szeredi.hu> <1190385151.6680.35.camel@heimdal.trondhjem.org>
Message-Id: <E1IYjjU-0001kB-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Sep 2007 16:43:52 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > ftruncate is a special case due to O_TRUNC.
> > 
> > No, it's special, because it does not do permission checking, while
> > truncate() does.
> 
> So why not just add file->f_op->ftruncate() and file->f_op->fstat()?

Sure, we could add those.

I'm not sure it's worth adding new file operations, instead of just
adding a parameter to ->getattr(), and ->*xattr(), but if that's more
acceptable. it's fine for me.

> Most filesystems can trivially redirect these to do_truncate() and their
> existing getattr() method. Those, like FUSE, that care can use the hook.
> In fact, I think that NFSv4 could also benefit from an ftruncate():
> currently we have to hunt around for an open file context for that
> particular case.

For ftruncate you can already access the open file from iattr->ia_file.

Miklos
