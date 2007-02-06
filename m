Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbXBFJwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbXBFJwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXBFJwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:52:32 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:9197
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbXBFJwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:52:31 -0500
Message-Id: <45C85E41.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Tue, 06 Feb 2007 09:53:53 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       "Suresh B Siddha" <suresh.b.siddha@intel.com>,
       "Richard Gooch" <rgooch@safe-mbox.com>, <linux-kernel@vger.kernel.org>,
       <discuss@x86-64.org>
Subject: Re: [discuss] [patch] mtrr: fix issues with large addresses
References: <20070205171959.GF8665@alberich.amd.com>
 <200702060853.30812.ak@suse.de> <45C85911.76E4.0078.0@novell.com>
 <200702061045.22966.ak@suse.de>
In-Reply-To: <200702061045.22966.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> I don't think I remember a restriction here, at least not below 44 bits
>> (that's where pfn-s would need to become 64-bit wide).
>
>The i386 mm code only supports 4 entries in the PGD, so more than 36bit cannot 
>be mapped right now.

That has nothing to do with the number of physical address bits.

>Also even 64MB barely works (many boxes don't boot), you would likely
>need at least the 4:4 patch to go >64GB. Also we know there are tons
>of possible deadlocks in various subsystems when the lowmem:highmem ratio 
>gets so out of hand.
>
>Ok it could be probably all fixed with some work (at least the mm part,
>the deadlocks would be more tricky), but would seem fairly 
>pointless to me because all machines with >36bits support are 64bit capable.

That's a different story, and certainly a limiting factor. But this shouldn't
e.g. disallow (hypothetical?) systems that have a very sparse memory map
extending beyond 64G.

Jan
