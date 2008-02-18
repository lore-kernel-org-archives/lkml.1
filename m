Return-Path: <linux-kernel-owner+w=401wt.eu-S1759774AbYBRRMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774AbYBRRMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 12:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbYBRRME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 12:12:04 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:50096 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYBRRMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 12:12:03 -0500
Date: Mon, 18 Feb 2008 18:11:59 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Unable to continue testing of 2.6.25
Message-ID: <20080218171159.GA24090@basil.nowhere.org>
References: <200802171025.30590.elendil@planet.nl> <20080217124650.576990ce@laptopd505.fenrus.org> <p73mypyxx6z.fsf@bingen.suse.de> <20080218085018.05f3190a@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218085018.05f3190a@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 18 Feb 2008 17:05:35.0989 (UTC) FILETIME=[7A998250:01C87250]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 08:50:18AM -0800, Arjan van de Ven wrote:
> On Mon, 18 Feb 2008 13:31:48 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Arjan van de Ven <arjan@infradead.org> writes:
> > >
> > > the initial plan was for a depreciation period. Sadly it was
> > > untenable since the API was changing entirely to fix bugs and add a
> > > really important feature (the ability to clflush the exact range
> > > rather than wbinvd'ing the caches of all cpus in the system), 
> > 
> > Just for the record: I posted full patches to implement clflush
> > support some time ago without changing any exported API. So your
> > claims that changing the API was needed to implement CLFLUSH are not
> > correct.
> 
> yeah of course it is possible to make things "smart" by having hidden state.
> doesn't make it right.

Not sure how you can call global_flush_tlb() "hidden". It was a quite
exposed interface.

Anyways there was also no principle reason in the old interface why
the flush couldn't have been done immediately. The only reason
it wasn't done was that Linus long ago asked for separate
flushing to improve efficiency of large remaps.

> > Also I believe some assumptions behind the new API are faulty (in
> > particular that the caller doesn't fully own the to be changed pages)
> > and make it actually impossible to implement the cache attribute PTE
> > changing operation fully correct according to the Intel x86 manual
> > (which requires temporary unmap)
> 
> the Intel x86 manual explicitly only has a temporary unmap when going from a 
> cached state to a write-combining state. Any other transition does not require
> an unmap. Which makes this not impossible, all a cached->WC transition needs

True, that's a possible workaround for this deficiency of the new API.

> to do is go via an intermediate UC state and the really expensive process from
> the manual is not needed.

Ok then you're proposing to use a even more expensive operation just
to patch this over. I guess that will work as long as we assume
none of the callers cares too much about performance, but trying to describe
it as an improvement is quite a stretch.

-Andi

