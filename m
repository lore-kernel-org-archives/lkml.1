Return-Path: <linux-kernel-owner+w=401wt.eu-S1765076AbYETM76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765076AbYETM76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 08:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbYETM7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 08:59:50 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:59444 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbYETM7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 08:59:50 -0400
Date: Tue, 20 May 2008 13:57:20 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Gabriel C <nix.or.die@googlemail.com>,
       Keith Packard <keithp@keithp.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 0 of 8] x86: use PTE_MASK consistently
In-Reply-To: <patchbomb.1211268376@localhost>
Message-ID: <Pine.LNX.4.64.0805201346120.24102@blonde.site>
References: <patchbomb.1211268376@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008, Jeremy Fitzhardinge wrote:
> 
> Here's a series to rationalize the use of PTE_MASK and remove some
> amount of ad-hocery.
> 
> This gist of the series is:
>  1. Fix the definition of PTE_MASK so that its equally applicable in
>     all pagetable modes
>  2. Use it consistently
> 
> I haven't tried to address the *_bad() stuff, other than to convert
> pmd_bad_* to use PTE_MASK.
> 
> This series has had some testing in the x86.git tree, and hasn't shown
> any problems.  Each patch is more or less absolutely trivial and the
> series is very bisectable, to help track down any problems which might
> arise (this area has always been a source of subtle problems).

Yes, thanks Jeremy: I've checked that each stage builds and runs X on my
boxes here, x86_32 and x86_32+PAE and x86_64.  (So even 1/8 is enough to
fix the PAT pte_modify issue, though 2/8 then fixes compiler warnings.)

I'll leave it to you and Linus whether your way of defining PTE_MASK is
satisfactory as is, or needs to be improved to his way.  I've not tried
his suggestion of doing the _PAGE_BIT definitions: certainly it's
seemed odd to me that they were defined with L, but I've little
appetite to mess around with them now myself.

One thing I did do a few days ago, but not got around to posting,
was the *_bad() stuff.  I've retested and will post that now...

Hugh
