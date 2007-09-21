Return-Path: <linux-kernel-owner+w=401wt.eu-S1760305AbXIUOem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbXIUOem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758466AbXIUOec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:34:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57118 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252AbXIUOeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:34:31 -0400
Date: Fri, 21 Sep 2007 15:34:27 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 3/5] VFS: pass open file to ->xattr()
Message-ID: <20070921143427.GB14577@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070921122343.307289079@szeredi.hu> <20070921123333.247493758@szeredi.hu> <20070921124323.GA8088@infradead.org> <E1IYi74-0001dX-00@dorka.pomaz.szeredi.hu> <20070921130642.GA9431@infradead.org> <E1IYiN2-0001eq-00@dorka.pomaz.szeredi.hu> <1190385151.6680.35.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190385151.6680.35.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 10:32:31AM -0400, Trond Myklebust wrote:
> On Fri, 2007-09-21 at 15:16 +0200, Miklos Szeredi wrote:
> 
> > > ftruncate is a special case due to O_TRUNC.
> > 
> > No, it's special, because it does not do permission checking, while
> > truncate() does.
> 
> So why not just add file->f_op->ftruncate() and file->f_op->fstat()?
> Most filesystems can trivially redirect these to do_truncate() and their
> existing getattr() method. Those, like FUSE, that care can use the hook.
> In fact, I think that NFSv4 could also benefit from an ftruncate():
> currently we have to hunt around for an open file context for that
> particular case.

Havin the file for fruncate is fine and I'm planning to do something
along those lines.  Having it for (f)stat is dumb because the operation
is in no way related to the open file descriptor.
