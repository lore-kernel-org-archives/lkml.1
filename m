Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZHMPFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZHMPFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbZHMPFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:05:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57784 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694AbZHMPFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:05:33 -0400
Date: Thu, 13 Aug 2009 18:03:44 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: virtualization@lists.linux-foundation.org,
       "Ira W. Snyder" <iws@ovro.caltech.edu>, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost_net: a kernel-level virtio server
Message-ID: <20090813150344.GC5080@redhat.com>
References: <cover.1249930169.git.mst@redhat.com> <200908131538.44465.arnd@arndb.de> <20090813143922.GA5080@redhat.com> <200908131658.06522.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908131658.06522.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 04:58:06PM +0200, Arnd Bergmann wrote:
> On Thursday 13 August 2009, Michael S. Tsirkin wrote:
> > > Right now, the number of copy operations in your code is the same.
> > > You are doing the copy a little bit later in skb_copy_datagram_iovec(),
> > > which is indeed a very nice hack. Changing to a virtqueue based method
> > > would imply that the host needs to add each skb_frag_t to its outbound
> > > virtqueue, which then gets copied into the guests inbound virtqueue.
> > 
> > Which is a lot more code than just calling skb_copy_datagram_iovec.
> 
> Well, I don't see this part as much of a problem, because the code
> already exists in virtio_net.

I am talking about the copying done in low level transport, here.

> If we really wanted to go down that road,
> just using virtio_net would solve the problem of frame handling
> entirely, but create new problems elsewhere, as we have mentioned.
> 
> 	Arnd <><
