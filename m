Return-Path: <linux-kernel-owner+w=401wt.eu-S1757640AbYBJJSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640AbYBJJSL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 04:18:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYBJJRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 04:17:54 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:17177 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbYBJJRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 04:17:51 -0500
Subject: Re: CONFIG_HIGHPTE vs. sub-page page tables.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0802090956r2de999fap7f16e173858be240@mail.gmail.com>
References: <200802081902.m18J2nOm005840@hera.kernel.org>
	 <20080208230433.GA8524@elte.hu> <20080208231506.GA13350@elte.hu>
	 <1202551589.8936.1.camel@localhost> <20080209103728.GA29375@elte.hu>
	 <1202554574.8936.15.camel@localhost>
	 <8bd0f97a0802090956r2de999fap7f16e173858be240@mail.gmail.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Sun, 10 Feb 2008 10:17:40 +0100
Message-Id: <1202635061.21652.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-02-09 at 12:56 -0500, Mike Frysinger wrote:
> On Feb 9, 2008 5:56 AM, Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> > On Sat, 2008-02-09 at 11:37 +0100, Ingo Molnar wrote:
> > > i think the worst is over already and i'm reasonably sure that there are
> > > no more bugs in it - this _is_ a 1:1 patch after all, so in theory the
> > > worst side-effect should be build breakages due to include file
> > > spaghetti. The window for this particular breakage was just 256 commits,
> > > that's OK i think.
> >
> > Except for the breakage of all nommu architectures .. they need the
> > pgtable_t as well due to the pte_fn_t type.
> 
> so why wasnt this in the original patch ?  why do no-mmu arches have
> to add the pgtable_t typedefs themselves ?

I do cross-compiles for some architectures but not all. None of the
nommu architectures are covered (I should change that). I actually did
cross compile m68knommu for the first versions of the patch, that didn't
went to well because of the standard m68k compiler. The pte_fn_t change
has been added after the test compile for m68knommu. This is how is
slipped through my fingers. The problem wasn't noticed either while the
patch has been aging in Andrews -mm tree.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


