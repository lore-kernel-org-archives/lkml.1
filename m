Return-Path: <linux-kernel-owner+w=401wt.eu-S1765548AbYDORYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765548AbYDORYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 13:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764515AbYDORYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 13:24:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764611AbYDORYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 13:24:42 -0400
Date: Tue, 15 Apr 2008 10:23:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
In-Reply-To: <20080415161532.GA15088@elte.hu>
Message-ID: <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org>
References: <20080411074145.GA4944@elte.hu> <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com> <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com> <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com>
 <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com> <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com> <20080415062534.GA9172@elte.hu> <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org> <20080415161532.GA15088@elte.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Apr 2008, Ingo Molnar wrote:
> 
> btw., now with a second full day spent on this regression, i have 
> figured out a workaround the hard way: increasing SECTION_SIZE_BITS in 
> include/asm-x86/sparsemem.h from 26 to 27 makes it go away.

Interesting.

I wonder..

So since you don't have NUMA, you have NODES_SHIFT == 0.

That in turn means that NODE_NOT_IN_PAGE_FLAGS is _not_ set.

That, in turn, means that ZONEID_SHIFT does *not* contain SECTIONS_SHIFT.
Is that really what is supposed to happen?

Because then "page_is_buddy()" will not even test the section, as far as I 
can tell.

But I'm probably missing something. Why would we not need to test the 
section in page_zone_id() when the node ID is in the page flags (but has 
zero size)?

		Linus
