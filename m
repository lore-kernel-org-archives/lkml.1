Return-Path: <linux-kernel-owner+w=401wt.eu-S1758732AbZKJX7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbZKJX7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 18:59:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758707AbZKJX7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 18:59:13 -0500
Received: from ozlabs.org ([203.10.76.45]:36772 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758656AbZKJX7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 18:59:12 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [Qemu-devel] Re: virtio: Add memory statistics reporting to the balloon driver
Date: Wed, 11 Nov 2009 10:29:13 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Adam Litke <agl@us.ibm.com>, linux-kernel@vger.kernel.org,
       Anthony Liguori <aliguori@us.ibm.com>,
       virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
       Avi Kivity <avi@redhat.com>
References: <1257782838.2835.5.camel@aglitke> <200911101312.02650.rusty@rustcorp.com.au> <4AF97A5E.1070801@codemonkey.ws>
In-Reply-To: <4AF97A5E.1070801@codemonkey.ws>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911111029.13791.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 01:06:14 am Anthony Liguori wrote:
> Rusty Russell wrote:
> > On Tue, 10 Nov 2009 03:02:06 am Adam Litke wrote:
> >   
> >> A simpler approach is to collect memory statistics in the virtio
> >> balloon driver and communicate them to the host via the device config space.
> >>     
> >
> > There are two issues I see with this.  First, there's an atomicity problem
> > since you can't tell when the stats are consistent.
> 
> Actually, config writes always require notification from the guest to 
> the host.  This means the host knows when they config space is changed 
> so atomicity isn't a problem.

I think you missed my point: the stats are inter-related, so they should be
served together.

> In fact, if it were a problem, then the balloon driver would be 
> fundamentally broken because target and actual are stored in the config 
> space.

No, one is written by the host, the other the guest.  Still works.

> If you recall, we had this discussion originally wrt the balloon driver :-)

And I never did get around to the lguest implementation, which would have
seen if this really is an issue.

> >   Second, polling is ugly.
> 
> As opposed to?

As opposed to giving the stats whenever asked by the host.

> > A stats vq might solve this more cleanly?
> >   
> 
> actual and target are both really just stats.  Had we implemented those 
> with a vq, I'd be inclined to agree with you but since they're 
> implemented in the config space, it seems natural to extend the config 
> space with other stats.

It does, *if* we don't need accuracy.  Otherwise, it seems like we need
something else.

Cheers,
Rusty.
