Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbYETGdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbYETGdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 02:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbYETGdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 02:33:08 -0400
Received: from gw.goop.org ([64.81.55.164]:40338 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996AbYETGdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 02:33:05 -0400
Message-ID: <48327E92.4060201@goop.org>
Date: Tue, 20 May 2008 08:32:34 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Gabriel C <nix.or.die@googlemail.com>,
       Keith Packard <keithp@keithp.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       bugme-daemon@bugzilla.kernel.org, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug 10732] REGRESSION: 2.6.26-rc2-git4: X server failed start
 onX61s laptop
References: <E1JxGth-0001te-S4@closure.thunk.org> <924EFEDD5F540B4284297C4DC59F3DEE01119AFE@orsmsx423.amr.corp.intel.com> <20080517154131.GA7651@mit.edu> <924EFEDD5F540B4284297C4DC59F3DEE01119B07@orsmsx423.amr.corp.intel.com> <1211047916.27447.314.camel@koto.keithp.com> <482F24C6.2050705@frugalware.org> <20080517184626.GA16496@mit.edu> <Pine.LNX.4.64.0805192217430.15410@blonde.site> <alpine.LFD.1.10.0805191528550.32253@woody.linux-foundation.org> <Pine.LNX.4.64.0805200434590.14297@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0805200434590.14297@blonde.site>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
>> And can we agree to never EVER use that PAGE_MASK thing (which was only 
>> ever meant to work on *addresses*) for any pte operations (including the 
>> definition of PTE_MASK)? Because PAGE_MASK is very much the word-size, and 
>> in 32-bit PAE, the page table entry is bigger.
>>
>> IOE, PTE_MASK should be a "pteval_t". And it should have absolutely 
>> *nothing* to do with PAGE_MASK. EVER.
>>     
>
> Yes, Jeremy makes it a pteval_t.  (My builds and Ingo's builds succeed,
> but I've not worked out how that goes down in assembly: there was an
> _AT macro in there before, which you've kept too - Jeremy?)
>   

I got rid of a bunch of _AT() uses because the constants aren't used in 
.S files anywhere.  Also, I couldn't see how to represent a 64-bit 
constant in assembler, so I wasn't sure of their correctness (the as 
manual is irritatingly vague on the matter).

> Yes, I'm highly resistant to taking untested patches here.  The two-liner
> I sent last night was about my fifth attempt to get it working, and I did
> start off from a small PTE_MASK correction which didn't work at all.  It
> looked rather like yours, I guess I missed the  __PHYSICAL_LOW_BITS part.
> Jeremy's goes a lot further, he'll know the gotchas better.
>   

__PHYSICAL_LOW_BITS is a bit more elegant than what I did there (the 
problem is getting a physaddr_t-width PAGE_MASK).  But the formulation 
in my patch certainly works.

    J
