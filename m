Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbYDBBgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbYDBBgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 21:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYDBBfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 21:35:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227AbYDBBfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 21:35:51 -0400
Subject: Re: [PATCH] x86: create array based interface to change page
	attribute
From: Dave Airlie <airlied@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, arjan@linux.intel.com,
       thomas@tungstengraphics.com
In-Reply-To: <20080331114646.GE29105@one.firstfloor.org>
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com>
	 <87myof8ief.fsf@basil.nowhere.org>
	 <21d7e9970803310421k67f1a697s8ffb5a4eef71c605@mail.gmail.com>
	 <20080331114646.GE29105@one.firstfloor.org>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 11:35:34 +1000
Message-Id: <1207100134.7250.21.camel@clockmaker.usersys.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-31 at 13:46 +0200, Andi Kleen wrote:
> On Mon, Mar 31, 2008 at 09:21:19PM +1000, Dave Airlie wrote:
> > On Mon, Mar 31, 2008 at 5:25 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > > Dave Airlie <airlied@redhat.com> writes:
> > >  >
> > >  > +#define CPA_FLUSHTLB 1
> > >  > +#define CPA_ARRAY 2
> > >
> > >  I don't think CPA_ARRAY should be a separate case. Rather single
> > >  page flushing should be an array with only a single entry. pageattr
> > >  is already very complex, no need to make add more special cases.
> > 
> > I thought about this but the current interface takes a start address
> > and number of pages from that point to cpa,
> > the array interface takes an array of page sized pages.
> > 
> > I don't really think we need to generate an array in the first case
> > with all the pages in it..
> 
> Just put the length into the array members too.

I can only think to do this by maybe stealing some bits, and having the
caller provide a pfn + length in one 64-bit dword.

As otherwise I'm going to end up with the largest use case for this
having to allocate a large array of 64-bit dwords all containing 1.

This isn't worth it IMHO and the array doesn't add that much more
complexity.

Dave.

