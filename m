Return-Path: <linux-kernel-owner+w=401wt.eu-S932428AbZLNUZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbZLNUZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 15:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758236AbZLNUZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 15:25:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbZLNUZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 15:25:41 -0500
Date: Mon, 14 Dec 2009 22:22:53 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
       netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [PATCH v2 1/4] Defer skb allocation -- add destroy buffers
	function for virtio
Message-ID: <20091214202253.GG6150@redhat.com>
References: <1258697359.7416.14.camel@localhost.localdomain> <200911231123.18898.rusty@rustcorp.com.au> <20091208122134.GA17286@redhat.com> <1260534506.30371.6.camel@localhost.localdomain> <1260534805.30371.10.camel@localhost.localdomain> <20091213102632.GB6789@redhat.com> <1260821285.8716.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260821285.8716.7.camel@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 12:08:05PM -0800, Shirley Ma wrote:
> Hello Michael,
> 
> I agree with the comments (will have two patches instead of 4 based on
> Rusty's comments) except below one.
> 
> On Sun, 2009-12-13 at 12:26 +0200, Michael S. Tsirkin wrote:
> > That said - do we have to use a callback?
> > I think destroy_buf which returns data pointer,
> > and which we call repeatedly until we get NULL
> > or error, would be an a better, more flexible API.
> > This is not critical though.
> 
> The reason to use this is because in virtio_net remove, it has
> BUG_ON(vi->num != 0), which will be consistent with small skb packet. If
> we use NULL, error then we lose the track for vi->num, since we don't
> know how many buffers have been passed to ULPs or still unused.
> 
> Thanks
> Shirley

I dont insist, but my idea was

for (;;) {
	b = vq->destroy(vq);
	if (!b)
		break;
	--vi->num;
	put_page(b);
}

so we do not have to lose track of the counter.

-- 
MST
