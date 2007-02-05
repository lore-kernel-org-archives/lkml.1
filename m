Return-Path: <linux-kernel-owner+w=401wt.eu-S933378AbXBETCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933378AbXBETCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 14:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933372AbXBETCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 14:02:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42804 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933366AbXBETCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 14:02:31 -0500
Date: Mon, 5 Feb 2007 19:02:30 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Christoph Hellwig <hch@infradead.org>, Tony Jones <tonyj@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
       agruen@suse.de, viro@zeniv.linux.org.uk
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Message-ID: <20070205190230.GA23104@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
	linux-security-module@vger.kernel.org, agruen@suse.de,
	viro@zeniv.linux.org.uk
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <20070205184410.GA20672@infradead.org> <1170701906.5934.41.camel@lade.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170701906.5934.41.camel@lade.trondhjem.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 10:58:26AM -0800, Trond Myklebust wrote:
> On Mon, 2007-02-05 at 18:44 +0000, Christoph Hellwig wrote:
> > Just FYI:  Al was very opposed to the idea of passing the vfsmount to
> > the vfs_ helpers, so you should discuss this with him.
> > 
> > Looking at the actual patches I see you're lazy in a lot of places.
> > Please make sure that when you introduce a vfsmount argument somewhere
> > that it is _always_ passed and not just when it's conveniant.  Yes, that's
> > more work, but then again if you're not consistant anyone half-serious
> > will laught at a security model using this infrasturcture.
> 
> nfsd in particular tends to be a bit lazy about passing around vfsmount
> info. Forcing it to do so should not be hard since the vfsmount is
> already cached in the "struct export" (which can be found using the
> filehandle). It will take a bit of re-engineering in order to pass that
> information around inside the nfsd code, though.

I actually have a patch to fix that.  It's part of a bigger series
that's not quite ready, but I hope to finish all of it this month.

> Note also that it might be nice to enforce the vfsmount argument by
> replacing the existing dentry parameters with a struct path instead of
> adding an extra reference to the vfsmount to existing functions.

That definitly sounds like a good idea, independent of whether we want
to pass the vfsmount in more places or not.
