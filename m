Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbZAISlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbZAISlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:41:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbZAISkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:40:49 -0500
Received: from 8bytes.org ([88.198.83.132]:41035 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbZAISkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:40:49 -0500
Date: Fri, 9 Jan 2009 19:40:48 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Joerg Roedel <joerg.roedel@amd.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com
Subject: Re: [PATCH 03/16] dma-debug: add hash functions for dma_debug_entries
Message-ID: <20090109184048.GE14298@8bytes.org>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1231517970-20288-4-git-send-email-joerg.roedel@amd.com> <20090109175542.GB30168@ioremap.net> <20090109181446.GB9466@8bytes.org> <20090109182339.GA31661@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109182339.GA31661@ioremap.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 09:23:39PM +0300, Evgeniy Polyakov wrote:
> On Fri, Jan 09, 2009 at 07:14:46PM +0100, Joerg Roedel (joro@8bytes.org) wrote:
> > > > +static struct hash_bucket *get_hash_bucket(struct dma_debug_entry *entry,
> > > > +					   unsigned long *flags)
> > > > +{
> > > > +	int idx = hash_fn(entry);
> > > > +	unsigned long __flags;
> > > > +
> > > > +	spin_lock_irqsave(&dma_entry_hash[idx].lock, __flags);
> > > > +	*flags = __flags;
> > > > +	return &dma_entry_hash[idx];
> > > > +}
> > > > +
> > > > +/*
> > > > + * Give up exclusive access to the hash bucket
> > > > + */
> > > > +static void put_hash_bucket(struct hash_bucket *bucket,
> > > > +			    unsigned long *flags)
> > > > +{
> > > > +	unsigned long __flags = *flags;
> > > > +
> > > > +	spin_unlock_irqrestore(&bucket->lock, __flags);
> > > > +}
> > > 
> > > Why do you need such ugly helpers?
> > 
> > Because everything else I thought about here was even more ugly. But
> > maybe you have a better idea? I tried to lock directly in the debug_
> > functions. But this is ugly and unnecessary code duplication.
> 
> I believe that having direct locking in the debug_ functions is not a
> duplication, anyone will have a direct vision on the locking and hash
> array dereference, and this will be just one additional line compared to
> the get_* call and the same number of lines for the put :)

Even more additional lines because of the additional variables needed in
every function. Anyway, I try it and if it does not look good I will
keep that change ;)

Joerg
