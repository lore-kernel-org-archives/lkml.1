Return-Path: <linux-kernel-owner+w=401wt.eu-S1762708AbYDOTjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762708AbYDOTjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbYDOTj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:39:28 -0400
Received: from relay2.sgi.com ([192.48.171.30]:60978 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755556AbYDOTj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:39:27 -0400
Date: Tue, 15 Apr 2008 12:39:26 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
In-Reply-To: <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com>
References: <20080411074145.GA4944@elte.hu> <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com>
 <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com>
 <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com>
 <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com>
 <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com>
 <20080415062534.GA9172@elte.hu> <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org>
 <20080415161532.GA15088@elte.hu> <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008, Linus Torvalds wrote:

> On Tue, 15 Apr 2008, Ingo Molnar wrote:
> > 
> > btw., now with a second full day spent on this regression, i have 
> > figured out a workaround the hard way: increasing SECTION_SIZE_BITS in 
> > include/asm-x86/sparsemem.h from 26 to 27 makes it go away.
> 
> Interesting.

Hmmmm. SECTION_SIZE_BITS == 26 means SECTIONS_SHIFT == 6. 
Increasing SECTION_SIZE_BITS to 27 reduces SECTION_SHIFT to 5. Thereby 
the number of sparsemem sections (NR_MEM_SECTIONS) is reduced to half (64 
to 32).
