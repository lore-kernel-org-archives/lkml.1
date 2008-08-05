Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbYHECnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbYHECnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 22:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756680AbYHECnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 22:43:45 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:34403 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449AbYHECno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 22:43:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18583.47633.987143.236236@stoffel.org>
Date: Mon, 4 Aug 2008 22:25:21 -0400
From: "John Stoffel" <john@stoffel.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Keith Packard <keithp@keithp.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
In-Reply-To: <Pine.LNX.4.64.0808042055240.17041@blonde.site>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	<200808041902.23970.nickpiggin@yahoo.com.au>
	<1217845590.24714.45.camel@koto.keithp.com>
	<200808042043.46710.nickpiggin@yahoo.com.au>
	<1217850352.24714.66.camel@koto.keithp.com>
	<Pine.LNX.4.64.0808041720500.25617@blonde.site>
	<1217870748.24714.79.camel@koto.keithp.com>
	<Pine.LNX.4.64.0808041855050.5717@blonde.site>
	<1217877645.24714.87.camel@koto.keithp.com>
	<Pine.LNX.4.64.0808042055240.17041@blonde.site>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Hugh" == Hugh Dickins <hugh@veritas.com> writes:

Hugh> On Mon, 4 Aug 2008, Keith Packard wrote:
>> On Mon, 2008-08-04 at 19:39 +0100, Hugh Dickins wrote:
>> > For how long are these objects' pages pinned in memory like this?
>> 
>> Forever? The only reason an object would get unpinned would be on
>> eviction from the GTT, and objects will only be evicted if we fill the
>> aperture with other stuff. When we add a register_shrinker callback,
>> we'll also unpin pages at that point.
>> 
>> A busy system should have the GTT entirely full, and that will be
>> somewhere between 256MB and 1GB.

Hugh> Okay, thanks for the warning.  It sounds like the shrinker will
Hugh> be important, but we'll also need to mark those pages as
Hugh> unevictable while they're unshrunk.  

What about the onboard memory of graphics cards?  Isn't that where
Textures and such are stored as well?  So once something is loaded to
the card, shouldn't you be able to free it in system memory?  Or swap
it out ahead of time?  

Hugh> (Usually when drivers grab a large number of pages, they're not
Hugh> on any LRU to begin with: you're being nice by choosing
Hugh> swappable LRU pages - in the tmpfs case - but enough to upset
Hugh> the balance while they're not swappable.)  Offhand I can't say
Hugh> what will be the appropriate way to do that, it's something we
Hugh> need to revisit later (from your point of view it should amount
Hugh> to one function call or flag set somewhere, not any grand
Hugh> redesign).

I just wonder here, since GPUs are different from other drivers in
that (I assume) they are written too much more often than they are
read to, that they should hopefully be much more amenable to drop
behind semantics for pages they've been sent, to free system
resources.

Now I admit I am most probably smoking something which is clouding my
understanding, so feel free to ingore my comments.  

John
