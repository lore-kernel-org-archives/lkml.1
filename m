Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbZCFSpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbZCFSpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbZCFSpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:45:22 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:3953 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781AbZCFSpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:45:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kMAVkmge/gDnX53J10+ywknCYIVlOG0RXfi7B2kC/HukqjRUKzRoZJj2vRKfSSAPtE
         tj6mzJpOn9jiLOqj0JCsDu/FQo7jPkveGbkhTj6YZe9Zv4dIJ8hwjopA4pEEgV9xe9UL
         KizvUtTYWv4WYiIt5AxcMKlTbSxLpNefDhsUw=
Date: Fri, 6 Mar 2009 21:45:14 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 03/18] dma-debug: add hash functions for
	dma_debug_entries
Message-ID: <20090306184514.GE7420@localhost>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com> <1236346229-6618-4-git-send-email-joerg.roedel@amd.com> <20090306135052.GE5988@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306135052.GE5988@nowhere>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Frederic Weisbecker - Fri, Mar 06, 2009 at 02:50:52PM +0100]
...
| > +/*
| > + * Add an entry to a hash bucket
| > + */
| > +static void hash_bucket_add(struct hash_bucket *bucket,
| > +			    struct dma_debug_entry *entry)
| > +{
| > +	list_add_tail(&entry->list, &bucket->list);
| > +}
| > +
| > +/*
| > + * Remove entry from a hash bucket list
| > + */
| > +static void hash_bucket_del(struct dma_debug_entry *entry)
| > +{
| > +	list_del(&entry->list);
| > +}
| 
| 
| Perhaps the two wrappers above are unnecessary, since they are actually
| used once and only wrap a single list operation. No?
| 
| Frederic.

Hi Frederic,

I think it would be better to make them 'inline' only but remain
the wrappers as is, since it show logic flow and hides internal data
details. But it's my personal opinion.

| 
...

	- Cyrill -
