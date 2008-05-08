Return-Path: <linux-kernel-owner+w=401wt.eu-S1763609AbYEHQeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763609AbYEHQeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 12:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYEHQeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 12:34:00 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51266 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591AbYEHQd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 12:33:59 -0400
Date: Thu, 8 May 2008 09:33:52 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Hugh Dickins <hugh@veritas.com>,
       Ingo Molnar <mingo@elte.hu>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
Message-ID: <20080508163352.GN23990@us.ibm.com>
References: <Pine.LNX.4.64.0805061435510.32567@blonde.site> <alpine.LFD.1.10.0805061138580.32269@woody.linux-foundation.org> <Pine.LNX.4.64.0805062043580.11647@blonde.site> <20080506202201.GB12654@escobedo.amd.com> <1210106579.4747.51.camel@nimitz.home.sr71.net> <20080508143453.GE12654@escobedo.amd.com> <1210258350.7905.45.camel@nimitz.home.sr71.net> <20080508151145.GG12654@escobedo.amd.com> <1210261882.7905.49.camel@nimitz.home.sr71.net> <20080508161925.GH12654@escobedo.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508161925.GH12654@escobedo.amd.com>
X-Operating-System: Linux 2.6.25-mm1-00024-g164d446 (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.05.2008 [18:19:25 +0200], Hans Rosenfeld wrote:
> On Thu, May 08, 2008 at 08:51:22AM -0700, Dave Hansen wrote:
> > Is there anything in your dmesg?
> 
> mm/memory.c:127: bad pmd ffff810076801040(80000000720000e7).
> 
> > There was a discussion on LKML in the last couple of days about
> > pmd_bad() triggering on huge pages.  Perhaps we're clearing the mapping
> > with the pmd_none_or_clear_bad(), and *THAT* is leaking the page.
> 
> That makes sense. I remember that explicitly munmapping the huge page
> would still work, but it doesn't. I don't quite remember what I did back
> then to test this, but I probably made some mistake there that led me to
> some false conclusions.

So this seems to lend credence to Dave's hypothesis. Without, as you
were trying before, teaching pagemap all about hugepages, what are our
options?

Can we just skip over the current iteration of the PMD loop (would we
need something similar for the PTE loop for power?) if pmd_huge(pmd)?

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
