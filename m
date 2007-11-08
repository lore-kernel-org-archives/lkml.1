Return-Path: <linux-kernel-owner+w=401wt.eu-S1762436AbXKHTDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762436AbXKHTDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 14:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760839AbXKHTDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 14:03:30 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44465 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760340AbXKHTD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 14:03:29 -0500
Date: Thu, 8 Nov 2007 11:03:29 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch 20/23] dentries: Add constructor
In-Reply-To: <20071108152324.GF2591@skynet.ie>
Message-ID: <Pine.LNX.4.64.0711081101000.8954@schroedinger.engr.sgi.com>
References: <20071107011130.382244340@sgi.com> <20071107011231.453090374@sgi.com>
 <20071108152324.GF2591@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007, Mel Gorman wrote:

> > Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> Seems to be some garbling on there in the signed-off lines.

Yes that needs to be fixed.

> > +void dcache_ctor(struct kmem_cache *s, void *p)
> > +{
> > +	struct dentry *dentry = p;
> > +
> > +	spin_lock_init(&dentry->d_lock);
> > +	dentry->d_inode = NULL;
> > +	INIT_LIST_HEAD(&dentry->d_lru);
> > +	INIT_LIST_HEAD(&dentry->d_alias);
> > +}
> > +
> 
> Is there any noticable overhead to the constructor?

Its a minor performance win since we can avoid reinitializing these
values and zeroing the object on alloc if there are already allocated 
objects.
