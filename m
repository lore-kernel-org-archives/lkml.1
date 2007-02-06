Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbXBFKzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbXBFKzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 05:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbXBFKzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 05:55:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbXBFKzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 05:55:10 -0500
From: Andi Kleen <ak@suse.de>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [discuss] [patch] mtrr: fix issues with large addresses
Date: Tue, 6 Feb 2007 11:54:57 +0100
User-Agent: KMail/1.9.5
Cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       "Suresh B Siddha" <suresh.b.siddha@intel.com>,
       "Richard Gooch" <rgooch@safe-mbox.com>, linux-kernel@vger.kernel.org,
       discuss@x86-64.org
References: <20070205171959.GF8665@alberich.amd.com> <200702061045.22966.ak@suse.de> <45C85E41.76E4.0078.0@novell.com>
In-Reply-To: <45C85E41.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702061154.57621.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 February 2007 10:53, Jan Beulich wrote:
> >> I don't think I remember a restriction here, at least not below 44 bits
> >> (that's where pfn-s would need to become 64-bit wide).
> >
> >The i386 mm code only supports 4 entries in the PGD, so more than 36bit cannot 
> >be mapped right now.
> 
> That has nothing to do with the number of physical address bits.

You couldn't use the memory in any ways.

Anyways I give up -- the check is probably not needed, unless Andreas
comes up with a good reason.

> 
> >Also even 64MB barely works (many boxes don't boot), you would likely
> >need at least the 4:4 patch to go >64GB. Also we know there are tons
> >of possible deadlocks in various subsystems when the lowmem:highmem ratio 
> >gets so out of hand.
> >
> >Ok it could be probably all fixed with some work (at least the mm part,
> >the deadlocks would be more tricky), but would seem fairly 
> >pointless to me because all machines with >36bits support are 64bit capable.
> 
> That's a different story, and certainly a limiting factor. But this shouldn't
> e.g. disallow (hypothetical?) systems that have a very sparse memory map
> extending beyond 64G.

They would need a discontig kernel to boot most likely, otherwise
mem_map would fill up their memory. 

And I was told Windows doesn't like that, so it's unlikely there will ever be such
x86 machines.

-Andi
