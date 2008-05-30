Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbYE3UMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbYE3UMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 16:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYE3UM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 16:12:27 -0400
Received: from mail.fieldses.org ([66.93.2.214]:40469 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbYE3UM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 16:12:27 -0400
Date: Fri, 30 May 2008 16:12:17 -0400
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, neilb@suse.de
Subject: Re: [patch 4/8] nfsd: rename MAY_ flags
Message-ID: <20080530201217.GD18154@fieldses.org>
References: <20080529113245.450308367@szeredi.hu> <20080529113312.288347247@szeredi.hu> <20080529124701.GA13147@infradead.org> <E1K1iiF-00086t-Ve@pomaz-ex.szeredi.hu> <20080529204002.GC24018@fieldses.org> <20080530073607.GB7758@infradead.org> <E1K20aX-0001NV-Vu@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K20aX-0001NV-Vu@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 11:07:53AM +0200, Miklos Szeredi wrote:
> > > > don't think it does, but I'm interested in the nfsd maintainers'
> > > > opinions.
> > > 
> > > This isn't something I've ever had a reason to care about.  What are you
> > > trying to fix exactly?
> > 
> > The NFS MAY_ flags operate in the same name and number space and we'd
> > easily get collisions when someone adds new MAY_ flags which miklos
> > as well as at least two other independent efforts want to do.  To sort
> > this out we'd either defined the nfsd MAY_ flags in fs.h to make it
> > obvious we should not double-allocates bits or names, or use a different
> > name and number space for the nfsd flags.  The first would be rather
> > trivial but also ugly, the seconds sound much better but is a little
> > more effort.  Just defined NFSD_MAY_ and use it everywhere and do a
> > little translation inside nfsd_permission before passing it on to
> > permission().
> 
> Yeah, I wouldn't mind that.  Although I'd still define NFSD_MAY_EXEC,
> NFSD_MAY_READ and NFSD_MAY_WRITE to be exactly the same as MAY_EXEC,
> etc..., and have the translation actually just mask off the rest of
> the bits (as it does currently).

OK by me.

--b.
