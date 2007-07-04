Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbXGDRAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbXGDRAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 13:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbXGDRAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 13:00:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:8923 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbXGDRAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 13:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CkE5LtnuuP/ij83hqm8sEPipaVUOnccHzk9N6lIahes1H5qtXST+lv7oxN0Xe7B9qzGOWlGt2v0vYmOCnDpjs8JmRYF2XSSJ0XrX6gblpvTU0UWsST8026s7KZso+40i99V7abStDANEOCsa/2aYSXctIrzUZmh6hrzx/y8W0QA=
Message-ID: <86802c440707041000m1378823dwff25ace3e93e54fe@mail.gmail.com>
Date: Wed, 4 Jul 2007 10:00:29 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Yinghai Lu" <Yinghai.Lu@sun.com>, "Andi Kleen" <ak@suse.de>,
       "Greg KH" <greg@kroah.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] net: make net and forcedeth to use kmalloc_node
In-Reply-To: <20070704084938.GA19515@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706291330.37070.yinghai.lu@sun.com>
	 <20070703115840.e05a0f47.akpm@linux-foundation.org>
	 <20070704084938.GA19515@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/4/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Jul 03, 2007 at 11:58:40AM -0700, Andrew Morton wrote:
> > >
> > >     while (np->put_rx.orig != less_rx) {
> > > -           struct sk_buff *skb = dev_alloc_skb(np->rx_buf_sz + NV_RX_ALLOC_PAD);
> > > +           struct sk_buff *skb = dev_alloc_skb_node(np->rx_buf_sz + NV_RX_ALLOC_PAD, dev_to_node(&dev->dev));
> >
> > If we're going to do this then it would probably make sense to change
> > dev_alloc_skb_node() so that it takes a `struct net_device *' rather than a
> > bare node-id.  That's a call which the net guys will need to make, which is
> > why we cc them on our emails.
>
> That thing is called netdev_alloc_skb and already exists.  And it's indeed
> what they should be using in the rx path.
>
> -
please check
http://lkml.org/lkml/2007/7/3/418

[PATCH 3/4] net: make forcedeth to use kmalloc_node and
__netdev_alloc_skb for skb allocation

but need to replace __netdev_alloc_skb to netdev_alloc_skb.

YH
