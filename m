Return-Path: <linux-kernel-owner+w=401wt.eu-S932980AbXHVSVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980AbXHVSVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762710AbXHVSUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:20:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47621 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759541AbXHVSUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:20:53 -0400
Date: Wed, 22 Aug 2007 11:20:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
cc: Chris Snook <csnook@redhat.com>, Hirokazu Takata <takata@linux-m32r.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, "Luck, Tony" <tony.luck@intel.com>,
       akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       Chris Friesen <cfriesen@nortel.com>
Subject: Re: [PATCH 11/23] make atomic_read() and atomic_set() behavior
 consistent on m32r
In-Reply-To: <8fc86c23579e12b012891d6e69b1b107@kernel.crashing.org>
Message-ID: <alpine.LFD.0.999.0708221116310.30176@woody.linux-foundation.org>
References: <46C03885.7000109@redhat.com> <20070813112452.GK24018@shell.boston.redhat.com>
 <swfhcmswcux.wl%takata.hirokazu@renesas.com> <swfejhww4cs.wl%takata.hirokazu@renesas.com>
 <46CC42EF.3030602@redhat.com>
 <8fc86c23579e12b012891d6e69b1b107@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 22 Aug 2007, Segher Boessenkool wrote:

> > > I also tried to rewrite it with inline asm code, but the kernel text size
> > > bacame roughly 2kB larger. So, I prefer C version.
> 
> Could you send me the source code diff between the two versions
> you tested?  2kB difference is way too much, the asm version should
> be smaller if anything.

Segher, can you please drop out of this discussion?

Your points are all wrong.

The inline asm version has the EXACT SAME PROBLEM as the "volatile" 
version has: it means that the compiler is unable to combine trivial 
instructions. There's no way that is acceptable.

So why the *hell* you'd expect the asm version to be smaller, I can't 
imagine. It's obvkously not going to be true.

So here's a clue to everybody in this thread:

   THE CURRENT x86 BEHAVIOUR IS THE CORRECT ONE

where we don't have any "volatile" and no inline asm and no barriers, and 
we let the compiler do the right thing. If the code needs barriers, the 
code should damn well add them.

It's worked for the past 8 months, on the most common platform there is.

Stop this *idiotic* thread already.

			Linus
