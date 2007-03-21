Return-Path: <linux-kernel-owner+w=401wt.eu-S965138AbXCUWV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965138AbXCUWV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965268AbXCUWV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:21:56 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56446 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965138AbXCUWVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:21:54 -0400
Date: Wed, 21 Mar 2007 15:19:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Delete obsolete RAW driver feature.
Message-Id: <20070321151952.02b5612d.akpm@linux-foundation.org>
In-Reply-To: <20070320181442.1ae73295@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.64.0703180754060.6605@CPE00045a9c397f-CM001225dbafb6>
	<p73y7lu5yt6.fsf@bingen.suse.de>
	<20070320165736.GA19781@redhat.com>
	<20070320181442.1ae73295@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007 18:14:42 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Tue, 20 Mar 2007 12:57:36 -0400
> Dave Jones <davej@redhat.com> wrote:
> 
> > On Sun, Mar 18, 2007 at 04:57:57PM +0100, Andi Kleen wrote:
> >  > "Robert P. J. Day" <rpjday@mindspring.com> writes:
> >  > 
> >  > > Delete the allegedly obsolete raw driver feature, which has been
> >  > > marked for death since 2005.
> >  > 
> >  > I think it would be better to replace it with a wrapper
> >  > that forces O_DIRECT and opens the underlying block device.  I suspect 
> >  > just dropping it will break many people's database setups, which is not
> >  > nice.  Widely used admin interfaces should be only broken when 
> >  > there is a very good reason and just "there is a better way now" 
> >  > doesn't seem quite strong enough.
> > 
> > Agreed.  Given how this keeps coming up every few months, lets just
> > remove that from the list..  It's not that a 306 line driver is
> > particularly invasive anyways..
> > 
> > Signed-off-by: Dave Jones <davej@redhat.com>
> 
> Acked-by: Alan Cox <alan@redhat.com>
> 
> This is a user visible API it is therefore not elligable for removal
> anyway

mutter.

We've given people years of notice and _some_ applications have converted
over to open("/dev/sda1", O_DIRECT), as they should.

Sure, it's a small and simple driver (now), so the cost of maintaining it
is low.

But otoh, there's no reason for it to exist, except for userspace
sluggishness.

So we can either give up, or we can push on: put a rude printk in there
somewhere and who knows, maybe in five years time we can finally be rid of
the thing.

