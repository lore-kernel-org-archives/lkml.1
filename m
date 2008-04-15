Return-Path: <linux-kernel-owner+w=401wt.eu-S1752303AbYDOUYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbYDOUYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757889AbYDOUXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:23:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39209 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765384AbYDOUXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:23:46 -0400
Date: Tue, 15 Apr 2008 22:23:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Message-ID: <20080415202324.GA26710@elte.hu>
References: <20080411074145.GA4944@elte.hu> <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com> <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com> <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com> <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com> <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com> <20080415062534.GA9172@elte.hu> <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org> <20080415161532.GA15088@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415161532.GA15088@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> [...] increasing SECTION_SIZE_BITS in include/asm-x86/sparsemem.h from 
> 26 to 27 makes it go away. (i.e. we use section chunks of 128 MB 
> instead of 64 MB before) [...]

btw., here's the 'good' versus 'bad' bootup log (vanilla kernel spiced 
with a few extra stats printed out [*]):

 http://redhat.com/~mingo/misc/boot.26.log         # bad
 http://redhat.com/~mingo/misc/boot.27.log         # good

the only difference is SECTION_SIZE_BITS == 26 versus 27.

looking at the dmesg diff, there's just minimal (and expected) offset 
difference in some structure sizes. (more sparse maps use a bit more 
memory)

	Ingo

[*] in case you wonder why memory_section->map is twice its size - i 
    doubled it just to eliminate any doubts about off-by-one errors. 
    Their natural size, as returned by bootmem, was 512KB plus 16 bytes 
    (!), which seemed a bit weird. Probably a section entry came between 
    two memory map allocations?
