Return-Path: <linux-kernel-owner+w=401wt.eu-S1759825AbZDBPxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825AbZDBPxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763055AbZDBPw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:52:56 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:52238 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763025AbZDBPwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:52:55 -0400
Date: Thu, 2 Apr 2009 17:52:49 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       akpm@osdl.org, frankeh@watson.ibm.com, riel@redhat.com,
       hugh@veritas.com
Subject: Re: [patch 0/6] Guest page hinting version 7.
Message-ID: <20090402175249.3c4a6d59@skybase>
In-Reply-To: <200904022232.02185.nickpiggin@yahoo.com.au>
References: <20090327150905.819861420@de.ibm.com>
	<200903281705.29798.rusty@rustcorp.com.au>
	<20090329162336.7c0700e9@skybase>
	<200904022232.02185.nickpiggin@yahoo.com.au>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009 22:32:00 +1100
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Monday 30 March 2009 01:23:36 Martin Schwidefsky wrote:
> > On Sat, 28 Mar 2009 17:05:28 +1030
> >
> > Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > On Saturday 28 March 2009 01:39:05 Martin Schwidefsky wrote:
> > > > Greetings,
> > > > the circus is back in town -- another version of the guest page hinting
> > > > patches. The patches differ from version 6 only in the kernel version,
> > > > they apply against 2.6.29. My short sniff test showed that the code
> > > > is still working as expected.
> > > >
> > > > To recap (you can skip this if you read the boiler plate of the last
> > > > version of the patches):
> > > > The main benefit for guest page hinting vs. the ballooner is that there
> > > > is no need for a monitor that keeps track of the memory usage of all
> > > > the guests, a complex algorithm that calculates the working set sizes
> > > > and for the calls into the guest kernel to control the size of the
> > > > balloons.
> > >
> > > I thought you weren't convinced of the concrete benefits over ballooning,
> > > or am I misremembering?
> >
> > The performance test I have seen so far show that the benefits of
> > ballooning vs. guest page hinting are about the same. I am still
> > convinced that the guest page hinting is the way to go because you do
> > not need an external monitor. Calculating the working set size for a
> > guest is a challenge. With guest page hinting there is no need for a
> > working set size calculation.
> 
> Sounds backwards to me. If the benefits are the same, then having
> complexity in an external monitor (which, by the way, shares many
> problems and goals of single-kernel resource/workload management),
> rather than putting a huge chunk of crap in the guest kernel's core
> mm code.

The benefits are the same but the algorithmic complexity is reduced.
The patch to the memory management has complexity in itself but from a
1000 feet standpoint guest page hinting is simpler, no? The question
how much memory each guest has to release does not exist. With the
balloner I have seen a few problematic cases where the size of
the balloon in principle killed the guest. My favorite is the "clever"
monitor script that queried the guests free memory and put all free
memory into the balloon. Now gues what happened with a guest that just
booted..

And could you please explain with a few more words >what< you consider
to be "crap"? I can't do anything with a general statement "this is
crap". Which translates to me: leave me alone..

> I still think this needs much more justification.
 
Ok, I can understand that. We probably need a KVM based version to show
that benefits exist on non-s390 hardware as well.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

