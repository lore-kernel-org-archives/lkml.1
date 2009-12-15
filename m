Return-Path: <linux-kernel-owner+w=401wt.eu-S934092AbZLOWgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934092AbZLOWgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934064AbZLOWgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:36:18 -0500
Received: from ozlabs.org ([203.10.76.45]:40218 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934059AbZLOWgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:36:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 1/4] Defer skb allocation -- add destroy buffers function for virtio
Date: Wed, 16 Dec 2009 09:06:12 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: Shirley Ma <mashirle@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
References: <1258697359.7416.14.camel@localhost.localdomain> <1260821285.8716.7.camel@localhost.localdomain> <20091214202253.GG6150@redhat.com>
In-Reply-To: <20091214202253.GG6150@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912160906.12430.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 06:52:53 am Michael S. Tsirkin wrote:
> On Mon, Dec 14, 2009 at 12:08:05PM -0800, Shirley Ma wrote:
> > Hello Michael,
> > 
> > I agree with the comments (will have two patches instead of 4 based on
> > Rusty's comments) except below one.
> > 
> > On Sun, 2009-12-13 at 12:26 +0200, Michael S. Tsirkin wrote:
> > > That said - do we have to use a callback?
> > > I think destroy_buf which returns data pointer,
> > > and which we call repeatedly until we get NULL
> > > or error, would be an a better, more flexible API.
> > > This is not critical though.
> > 
> > The reason to use this is because in virtio_net remove, it has
> > BUG_ON(vi->num != 0), which will be consistent with small skb packet. If
> > we use NULL, error then we lose the track for vi->num, since we don't
> > know how many buffers have been passed to ULPs or still unused.
> > 
> > Thanks
> > Shirley
> 
> I dont insist, but my idea was
> 
> for (;;) {
> 	b = vq->destroy(vq);
> 	if (!b)
> 		break;
> 	--vi->num;
> 	put_page(b);
> }

In this case it should be called "get_unused_buf" or something.  But I like
Shirley's approach here; destroy (with callback) accurately reflects the only
time this can be validly used.

Cheers,
Rusty.
