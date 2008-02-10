Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbYBJJZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbYBJJZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 04:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYBJJZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 04:25:19 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:10695 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYBJJZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 04:25:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PPtVJ9PEVGODLaBb3rZahJHdLnBcujG/ThlYm0ge7AGPNdFZa+NfT1WdOluB16lTkbJ13c0QXOpmXoKMK59/9Cec43LKargskiY/h52t9ZofCW14qWNe+v4RgE+vkKWcQqWfX+8BOf2rlIqUvcYXxyknlKiFCea6Ws7cEOe109c=
Message-ID: <8bd0f97a0802100125va445d5ci81122da279b80d5f@mail.gmail.com>
Date: Sun, 10 Feb 2008 04:25:13 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: schwidefsky@de.ibm.com
Subject: Re: CONFIG_HIGHPTE vs. sub-page page tables.
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1202635061.21652.8.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802081902.m18J2nOm005840@hera.kernel.org>
	 <20080208230433.GA8524@elte.hu> <20080208231506.GA13350@elte.hu>
	 <1202551589.8936.1.camel@localhost> <20080209103728.GA29375@elte.hu>
	 <1202554574.8936.15.camel@localhost>
	 <8bd0f97a0802090956r2de999fap7f16e173858be240@mail.gmail.com>
	 <1202635061.21652.8.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2008 4:17 AM, Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> On Sat, 2008-02-09 at 12:56 -0500, Mike Frysinger wrote:
> > On Feb 9, 2008 5:56 AM, Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> > > On Sat, 2008-02-09 at 11:37 +0100, Ingo Molnar wrote:
> > > > i think the worst is over already and i'm reasonably sure that there are
> > > > no more bugs in it - this _is_ a 1:1 patch after all, so in theory the
> > > > worst side-effect should be build breakages due to include file
> > > > spaghetti. The window for this particular breakage was just 256 commits,
> > > > that's OK i think.
> > >
> > > Except for the breakage of all nommu architectures .. they need the
> > > pgtable_t as well due to the pte_fn_t type.
> >
> > so why wasnt this in the original patch ?  why do no-mmu arches have
> > to add the pgtable_t typedefs themselves ?
>
> I do cross-compiles for some architectures but not all. None of the
> nommu architectures are covered (I should change that). I actually did
> cross compile m68knommu for the first versions of the patch, that didn't
> went to well because of the standard m68k compiler. The pte_fn_t change
> has been added after the test compile for m68knommu. This is how is
> slipped through my fingers. The problem wasn't noticed either while the
> patch has been aging in Andrews -mm tree.

i guess my point was more: the pgtable_t typdef is new therefore it
must be defined for every architecture.  your ability to directly
cross-compile and/or test a subset is great, but posting a change that
is know for a fact to break arches you didnt update seems like a bad
idea.  even if you just included the obvious-but-not-compile-tested
changes and included the linux-arch@vger alias instead would have been
better than nothing
-mike
