Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbYE3HgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbYE3HgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 03:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYE3HgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 03:36:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41405 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbYE3HgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 03:36:11 -0400
Date: Fri, 30 May 2008 03:36:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, neilb@suse.de
Subject: Re: [patch 4/8] nfsd: rename MAY_ flags
Message-ID: <20080530073607.GB7758@infradead.org>
References: <20080529113245.450308367@szeredi.hu> <20080529113312.288347247@szeredi.hu> <20080529124701.GA13147@infradead.org> <E1K1iiF-00086t-Ve@pomaz-ex.szeredi.hu> <20080529204002.GC24018@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529204002.GC24018@fieldses.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 04:40:02PM -0400, J. Bruce Fields wrote:
> > don't think it does, but I'm interested in the nfsd maintainers'
> > opinions.
> 
> This isn't something I've ever had a reason to care about.  What are you
> trying to fix exactly?

The NFS MAY_ flags operate in the same name and number space and we'd
easily get collisions when someone adds new MAY_ flags which miklos
as well as at least two other independent efforts want to do.  To sort
this out we'd either defined the nfsd MAY_ flags in fs.h to make it
obvious we should not double-allocates bits or names, or use a different
name and number space for the nfsd flags.  The first would be rather
trivial but also ugly, the seconds sound much better but is a little
more effort.  Just defined NFSD_MAY_ and use it everywhere and do a
little translation inside nfsd_permission before passing it on to
permission().


> 
> --b.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
---end quoted text---
