Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbZEVO0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbZEVO0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 10:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbZEVO0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 10:26:30 -0400
Received: from sh.osrg.net ([192.16.179.4]:54402 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654AbZEVO03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 10:26:29 -0400
Date: Fri, 22 May 2009 23:24:59 +0900
To: Ian.Campbell@eu.citrix.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, jeremy@goop.org,
       beckyb@kernel.crashing.org, okir@suse.de, gregkh@suse.de,
       xendevel@lists.xensource.com, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: swiotlb: remove __weak hooks in favour of
	architecture-specific functions
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1243000924.25553.2112.camel@localhost.localdomain>
References: <1242992596.22654.273.camel@zakaz.uk.xensource.com>
	<20090522205533P.fujita.tomonori@lab.ntt.co.jp>
	<1243000924.25553.2112.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090522232449X.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 22 May 2009 23:25:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009 15:02:04 +0100
Ian Campbell <Ian.Campbell@eu.citrix.com> wrote:

> On Fri, 2009-05-22 at 07:55 -0400, FUJITA Tomonori wrote:
> > On Fri, 22 May 2009 12:43:16 +0100
> > Ian Campbell <Ian.Campbell@eu.citrix.com> wrote:
> > 
> > > On Fri, 2009-05-22 at 07:13 -0400, FUJITA Tomonori wrote:
> > > > On Thu, 21 May 2009 17:15:21 +0100
> > > > Ian Campbell <ian.campbell@citrix.com> wrote:
> > > > Please go with the following way (that I posted yesterday):
> > > > 
> > > > http://marc.info/?l=xen-devel&m=124292666214380&w=2
> > > > 
> > > > 
> > > > Export the core feature of swiotlb, managing iotlb buffer and
> > > > implement the Xen mapping functions.
> > > 
> > > I feel that should be a last resort, before we go down that path we
> > > should try and find a way for us to use the generic code in a clean way
> > > which makes everyone happy.
> > >
> > > We have had several attempts at this and admittedly have not yet come up
> > > with something that satisfies everyone but I don't really think we have
> > > gotten to the point of admitting defeat and just duplicating the code.
> > 
> > There should not be much duplication.
> > 
> > 
> > > I think the proposal to use a dma_map_range-like function which I sent a
> > > few minutes ago I think gets us closer to something which satisfies
> > > everyone's requirements, including yours for a clean abstraction.
> > 
> > Seems you don't understand the point; with dom0, we can't cleanly use
> > arch/*/include/asm/.
> 
> I understand precisely what you are saying, I just fundamentally
> disagree with you. It is perfectly possible for an arch/*/include/asm
> interface for this stuff to be defined which is completely abstracted
> from the POV of the swiotlb code (and any other arch-external code).
> 
> > You need to insert Xen's hook like this:
> 
> As I said in the email this snippet was contained in:
> >       * The Xen specific stuff in arch/x86/include/asm/dma-mapping.h
> >         clearly needs to be properly abstracted away (I just stuck it
> >         there for testing).
> 
> So obviously I am well aware that it is unacceptable as it stands.

I don't think that you can't clean up the above much.

After all, you need a hook for Xen in
arch/x86/include/asm/dma-mapping.h and define it in Xen's land.

That will not be much different from:

http://marc.info/?l=linux-kernel&m=124299344606890&w=2


And adding 'if xen' hook in common header files in arch/x86/include/ is a
wrong design to me. Do you add a similar 'if xen' hook in other x86's
common headers files?


> I think we can find a way to implement this functionality which is
k> contained entirely within the arch/x86 code and is also acceptable to
> the x86 maintainers. There are plenty of cases where we define similar

I'm not sure about it (hopefully, not). But if the x86 maintainers ACK
the above code, I have no complaint.


> interfaces where arch code implements an API with different backends for
> different configurations, hardware configurations etc etc.
