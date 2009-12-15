Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbZLOAha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbZLOAha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 19:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbZLOAh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 19:37:29 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:51865 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbZLOAh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 19:37:27 -0500
Subject: Re: PATCH v2 3/4] Defer skb allocation -- new recvbuf alloc &
 receive calls
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
       netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
In-Reply-To: <1260828518.8716.105.camel@localhost.localdomain>
References: <1258697359.7416.14.camel@localhost.localdomain>
	 <200911231123.18898.rusty@rustcorp.com.au>
	 <20091208122134.GA17286@redhat.com>
	 <1260534506.30371.6.camel@localhost.localdomain>
	 <1260535613.30371.24.camel@localhost.localdomain>
	 <20091213114320.GC7074@redhat.com>
	 <1260828518.8716.105.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 14 Dec 2009 16:37:15 -0800
Message-Id: <1260837435.4387.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michael,

On Mon, 2009-12-14 at 14:08 -0800, Shirley Ma wrote:
> > > +
> > > +     err = vi->rvq->vq_ops->add_buf(vi->rvq, sg, 0, 2, skb);
> > > +     if (err < 0)
> > > +             kfree_skb(skb);
> > > +     else
> > > +             skb_queue_head(&vi->recv, skb);
> > 
> > So why are we queueing this still?
> This is for small packet. I didn't change that code since it will
> involve extra copy by using page.

I think I can remove skb link for small packet as well by adding
kfree_skb() in virtio_net_free_bufs for small packet.

Thanks
Shirley

