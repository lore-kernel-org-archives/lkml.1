Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbZHXRwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbZHXRwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 13:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZHXRwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 13:52:08 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42137 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbZHXRwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 13:52:07 -0400
Subject: Re: [RFC] defer skb allocation in virtio_net -- mergable buff part
From: Shirley Ma <mashirle@us.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4A880DFE.2040507@redhat.com>
References: <1250145231.6653.29.camel@localhost.localdomain>
	 <4A880DFE.2040507@redhat.com>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 10:51:50 -0700
Message-Id: <1251136310.588.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Avi,

Thanks for you review. I was on vacation last week.

On Sun, 2009-08-16 at 16:47 +0300, Avi Kivity wrote:
> Alternatives include:
> - store the link in the page itself
> - have an array of pages per list element instead of just one pointer
> - combine the two, store an array of page pointers in one of the free
> pages
> - use the struct page::lru member
> 
> The last is the most traditional and easiest so I'd recommend it
> (though 
> it still takes the cacheline hit).

I prefer the combine of the two. But I will compare the performance
differences if no much difference, we can use the easiest one.

> > +static struct page_list *get_a_free_page(struct virtnet_info *vi,
> gfp_t gfp_mask)
> > +{
> > +     struct page_list *plist;
> > +
> > +     if (list_empty(&vi->freed_pages)) {
> > +             plist = kmalloc(sizeof(struct page_list), gfp_mask);
> > +             if (!plist)
> > +                     return NULL;
> > +             list_add_tail(&plist->list,&vi->freed_pages);
> > +             plist->page = alloc_page(gfp_mask);
> >    
> 
> What if the allocation fails here?

It is handled by the caller.

Thanks
Shirley

