Return-Path: <linux-kernel-owner+w=401wt.eu-S936606AbXGMJyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936606AbXGMJyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763125AbXGMJyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:54:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47499 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762139AbXGMJya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:54:30 -0400
Date: Fri, 13 Jul 2007 10:54:13 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: Re: [PATCH 012 of 20] knfsd: nfsd4: make readonly access depend on pseudoflavor
Message-ID: <20070713095413.GC16304@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	NeilBrown <neilb@suse.de>, nfs@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@citi.umich.edu>
References: <20070710121949.12548.patches@notabene> <1070710022615.13375@suse.de> <20070713002704.2287f5a3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713002704.2287f5a3.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 12:27:04AM -0700, Andrew Morton wrote:
> On Tue, 10 Jul 2007 12:26:15 +1000 NeilBrown <neilb@suse.de> wrote:
> 
> > +static inline int EX_RDONLY(struct svc_export *exp, struct svc_rqst *rqstp)
> > +{
> > +	struct exp_flavor_info *f;
> > +	struct exp_flavor_info *end = exp->ex_flavors + exp->ex_nflavors;
> > +
> > +	for (f = exp->ex_flavors; f < end; f++) {
> > +		if (f->pseudoflavor == rqstp->rq_flavor)
> > +			return f->flags & NFSEXP_READONLY;
> > +	}
> > +	return exp->ex_flags & NFSEXP_READONLY;
> > +}
> 
> It is fortunate that this inlined monster has only one callsite.
> 
> otoh, given that it has only one callsite, perhaps it should be private
> to fs/nfsd/vfs.c.

Absolutely.  Pluse a sane lower-case name and removing the inline qualifier
please.
