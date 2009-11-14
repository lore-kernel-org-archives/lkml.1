Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZKNJ2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZKNJ2l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 04:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbZKNJ2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 04:28:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34867 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217AbZKNJ2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 04:28:38 -0500
Date: Sat, 14 Nov 2009 10:28:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: d451564 breakage
Message-ID: <20091114092826.GB10969@elte.hu>
References: <20091113151119.GA27752@flint.arm.linux.org.uk>
 <20091113224820.GB29657@elte.hu>
 <20091113230223.GF27752@flint.arm.linux.org.uk>
 <20091113231714.GA21666@elte.hu>
 <20091113233734.GG27752@flint.arm.linux.org.uk>
 <20091114002138.GA9421@elte.hu>
 <20091114081919.GA29752@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091114081919.GA29752@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> On Sat, Nov 14, 2009 at 01:21:38AM +0100, Ingo Molnar wrote:
> > What i was thinking of was a really simple thing in highmem.c (or 
> > rather, in include/linux/highmem.h, after kmap_types.h gets included):
> > 
> > #ifndef KM_NMI
> > # define KM_NMI			-1
> > #endif
> > #ifndef KM_NMI_PTE
> > # define KM_NMI_PTE		-1
> > #endif
> > 
> > etc.
> 
> That means we need to ensure that kmap_atomic() fails when these are 
> used, to avoid kmap_atomic corrupting virtual mappings below the kmap 
> area should one of these be used.  That means additional run-time code 
> in all those implementations - I'd much rather leave that to someone 
> else to do.
> 
> Alternatively, they could be wrapped with CONFIG_DEBUG_HIGHMEM so they 
> aren't normally visible.
> 
> In any case, as I've already pointed out, we still need to add 
> definitions to all places which define these constants.  Having them 
> exist as enum constants does not make them visible to the 
> preprocessor.
> 
> I don't think it's as simple as you're trying to make it.  However, 
> since you seem to have a solid idea which you're trying to get me to 
> implement, maybe it'd just be much simpler and faster if you provided 
> that patch.

Since we are going to remove the generic code (the patch for that has 
been posted) it doesnt really matter and i'd suggest for you to commit 
the ARM patch.

	Ingo
