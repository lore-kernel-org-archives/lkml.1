Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbXBFJpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbXBFJpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXBFJpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:45:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:59323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbXBFJpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:45:34 -0500
From: Andi Kleen <ak@suse.de>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [discuss] [patch] mtrr: fix issues with large addresses
Date: Tue, 6 Feb 2007 10:45:22 +0100
User-Agent: KMail/1.9.5
Cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       "Suresh B Siddha" <suresh.b.siddha@intel.com>,
       "Richard Gooch" <rgooch@safe-mbox.com>, linux-kernel@vger.kernel.org,
       discuss@x86-64.org
References: <20070205171959.GF8665@alberich.amd.com> <200702060853.30812.ak@suse.de> <45C85911.76E4.0078.0@novell.com>
In-Reply-To: <45C85911.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702061045.22966.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 February 2007 10:31, Jan Beulich wrote:
> >>> Andi Kleen <ak@suse.de> 06.02.07 08:53 >>>
> >On Monday 05 February 2007 23:50, Siddha, Suresh B wrote:
> >> On Mon, Feb 05, 2007 at 06:19:59PM +0100, Andreas Herrmann wrote:
> >> > o added check to restrict base address to 36 bit on i386
> >> 
> >> Why is this? It can go upto implemented physical bits, right?
> >
> >In theory it can, but Linux doesn't support it.
> 
> I don't think I remember a restriction here, at least not below 44 bits
> (that's where pfn-s would need to become 64-bit wide).

The i386 mm code only supports 4 entries in the PGD, so more than 36bit cannot 
be mapped right now.

Also even 64MB barely works (many boxes don't boot), you would likely
need at least the 4:4 patch to go >64GB. Also we know there are tons
of possible deadlocks in various subsystems when the lowmem:highmem ratio 
gets so out of hand.

Ok it could be probably all fixed with some work (at least the mm part,
the deadlocks would be more tricky), but would seem fairly 
pointless to me because all machines with >36bits support are 64bit capable.

-Andi
