Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbXKGS4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbXKGS4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbXKGS4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:56:09 -0500
Received: from lazybastard.de ([212.112.238.170]:33562 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbXKGS4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:56:08 -0500
Date: Wed, 7 Nov 2007 19:51:14 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>, akpm@linux-foundatin.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 14/23] inodes: Support generic defragmentation
Message-ID: <20071107185113.GC8918@lazybastard.org>
References: <20071107011130.382244340@sgi.com> <20071107011229.893091119@sgi.com> <20071107101748.GC7374@lazybastard.org> <Pine.LNX.4.64.0711071035490.9857@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0711071035490.9857@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 November 2007 10:40:55 -0800, Christoph Lameter wrote:
> On Wed, 7 Nov 2007, Jörn Engel wrote:
> > On Tue, 6 November 2007 17:11:44 -0800, Christoph Lameter wrote:
> > >  
> > > +void *get_inodes(struct kmem_cache *s, int nr, void **v)
> > > +{
> > > +	int i;
> > > +
> > > +	spin_lock(&inode_lock);
> > > +	for (i = 0; i < nr; i++) {
> > > +		struct inode *inode = v[i];
> > > +
> > > +		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE))
> > > +			v[i] = NULL;
> > > +		else
> > > +			__iget(inode);
> > > +	}
> > > +	spin_unlock(&inode_lock);
> > > +	return NULL;
> > > +}
> > > +EXPORT_SYMBOL(get_inodes);
> > 
> > What purpose does the return type have?
> 
> The pointer is for communication between the get and kick methods. get() 
> can  modify kick() behavior by returning a pointer to a data structure or 
> using the pointer to set a flag. F.e. get() may discover that there is an 
> unreclaimable object and set a flag that causes kick to simply undo the 
> refcount increment. get() may build a map for the objects and indicate in 
> the map special treatment. 

Is there a get/kick pair that actually does this?  So far I haven't
found anything like it.

Also, something vaguely matching that paragraph might make sense in a
kerneldoc header to the function. ;)

Jörn

-- 
There is no worse hell than that provided by the regrets
for wasted opportunities.
-- Andre-Louis Moreau in Scarabouche
