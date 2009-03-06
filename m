Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbZCFTQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbZCFTQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbZCFTQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:16:44 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:62908 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbZCFTQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:16:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fHvQaR4w18gmYd7klDYx6KSg+bT/47CyhAXDcxx8A8QUbbJryunpzOpxBaDe8zHWye
         a7jguDV5FKRgRJHuawRN1vKQQln0+zUqe+q02LxGDM2fJipk0vckcM3HcSnH//i0kNc5
         xLLvbM417XcLL+6fHrE4q3QO95mzADOONcHiY=
Date: Fri, 6 Mar 2009 22:16:41 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 03/18] dma-debug: add hash functions for
	dma_debug_entries
Message-ID: <20090306191641.GF7420@localhost>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com> <1236346229-6618-4-git-send-email-joerg.roedel@amd.com> <20090306135052.GE5988@nowhere> <20090306184514.GE7420@localhost> <20090306191059.GE7329@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306191059.GE7329@nowhere>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Frederic Weisbecker - Fri, Mar 06, 2009 at 08:11:00PM +0100]
| On Fri, Mar 06, 2009 at 09:45:14PM +0300, Cyrill Gorcunov wrote:
| > [Frederic Weisbecker - Fri, Mar 06, 2009 at 02:50:52PM +0100]
| > ...
| > | > +/*
| > | > + * Add an entry to a hash bucket
| > | > + */
| > | > +static void hash_bucket_add(struct hash_bucket *bucket,
| > | > +			    struct dma_debug_entry *entry)
| > | > +{
| > | > +	list_add_tail(&entry->list, &bucket->list);
| > | > +}
| > | > +
| > | > +/*
| > | > + * Remove entry from a hash bucket list
| > | > + */
| > | > +static void hash_bucket_del(struct dma_debug_entry *entry)
| > | > +{
| > | > +	list_del(&entry->list);
| > | > +}
| > | 
| > | 
| > | Perhaps the two wrappers above are unnecessary, since they are actually
| > | used once and only wrap a single list operation. No?
| > | 
| > | Frederic.
| > 
| > Hi Frederic,
| > 
| > I think it would be better to make them 'inline' only but remain
| > the wrappers as is, since it show logic flow and hides internal data
| > details. But it's my personal opinion.
| 
| 
| Yeah, I guess it's only a matter of taste :-)
| Anyway, as you said, it should be inlined.

Nod :) The only problem could be (it depends) -- is that
if one day some locking would be needed instead of fixing
one function you would need to grep all list_add/del entries :)

| 
|  
	- Cyrill -
