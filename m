Return-Path: <linux-kernel-owner+w=401wt.eu-S1759680AbXGDIt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680AbXGDIt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 04:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756350AbXGDItq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 04:49:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33898 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326AbXGDIto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 04:49:44 -0400
Date: Wed, 4 Jul 2007 09:49:38 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] net: make net and forcedeth to use kmalloc_node
Message-ID: <20070704084938.GA19515@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yinghai Lu <Yinghai.Lu@Sun.COM>, Andi Kleen <ak@suse.de>,
	Greg KH <greg@kroah.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	netdev@vger.kernel.org
References: <200706291330.37070.yinghai.lu@sun.com> <20070703115840.e05a0f47.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070703115840.e05a0f47.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 11:58:40AM -0700, Andrew Morton wrote:
> >  
> >  	while (np->put_rx.orig != less_rx) {
> > -		struct sk_buff *skb = dev_alloc_skb(np->rx_buf_sz + NV_RX_ALLOC_PAD);
> > +		struct sk_buff *skb = dev_alloc_skb_node(np->rx_buf_sz + NV_RX_ALLOC_PAD, dev_to_node(&dev->dev));
> 
> If we're going to do this then it would probably make sense to change
> dev_alloc_skb_node() so that it takes a `struct net_device *' rather than a
> bare node-id.  That's a call which the net guys will need to make, which is
> why we cc them on our emails.

That thing is called netdev_alloc_skb and already exists.  And it's indeed
what they should be using in the rx path.

