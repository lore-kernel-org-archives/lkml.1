Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbXFNWvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbXFNWvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757502AbXFNWvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:51:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756892AbXFNWvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:51:37 -0400
Subject: Re: libertas (private) ioctls vs. nl80211
From: Dan Williams <dcbw@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, johannes@sipsolutions.net,
       linux-wireless@vger.kernel.org, hs4233@mail.mn-solutions.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070614223125.GA28235@infradead.org>
References: <1181757483.29767.99.camel@johannes.berg>
	 <20070614170901.GA13384@infradead.org>
	 <20070614103836.23b07a72.akpm@linux-foundation.org>
	 <20070614181307.GA16856@infradead.org>
	 <alpine.LFD.0.98.0706141121080.14121@woody.linux-foundation.org>
	 <46718D81.9080402@garzik.org>
	 <1181859755.23567.3.camel@xo-28-0B-88.localdomain>
	 <20070614223125.GA28235@infradead.org>
Content-Type: text/plain
Date: Thu, 14 Jun 2007 18:55:58 -0400
Message-Id: <1181861758.23567.26.camel@xo-28-0B-88.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-14 at 23:31 +0100, Christoph Hellwig wrote:
> On Thu, Jun 14, 2007 at 06:22:35PM -0400, Dan Williams wrote:
> > And that's what I did in the last pull you got from John; all pointless
> > and duplicated ioctls were removed.  The only ones left are mesh
> > tweakables, an LED GPIO control ioctl, and a regulatory region/domain
> > thing.  I agree the interface is somewhat ugly (like the
> > char-128/char-128 ones that return information from the mesh forwarding
> > table), and I also agree that we need to move to using netlink for this
> > sort of stuff in the future.  There are _no_ ioctls that duplicate WEXT
> > functionality.
> 
> The problem is not any kind of duplication.  The problem is that the
> interface is plain and simply bad.  If anyone else would come in with
> an ioctl interface using pointer indirections and subfunctions which
> is horribly complex and not 32on64 clean they would get beaten up.

I agree that it's suboptimal; I tried to clean it up and bashed my head
against the current iwpriv system for about 2 days before concluding
that the iwpriv stuff is just too insane to actually use.  We both want
a well-defined, clean, generic 802.11s-type interface, make no mistake.
Unfortunately, we don't have any framework which that interface could
use (ie, nl80211 or cfg80211).  That's unlikely to land until 2.6.23 or
even later.  And the regulatory stuff is still probably 6 months away
from agreement.

So if everybody is objecting to _any_ new private ioctls, even if they
don't duplicate WEXT functionality, whatever; rip them out and we'll
maintain them out-of-kernel or something until there's a nicer framework
to piggy-back the mesh tune-ables on.

Dan

> So even if the interface is not going to be generic it needs to be
> done properly and document.  And once it's documented you've actually
> layed down the first building block have it generic.  If no other
> driver actually implements the same kind of non-standardized mesh
> interface it'll stay that way, if other pop up they can implement
> the same interface and eventually we'll grow a generic layer helping
> out with it.

