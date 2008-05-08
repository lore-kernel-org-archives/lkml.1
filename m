Return-Path: <linux-kernel-owner+w=401wt.eu-S1762081AbYEHUQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762081AbYEHUQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYEHUQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:16:33 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:42899 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbYEHUQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:16:32 -0400
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Hugh Dickins <hugh@veritas.com>, Nishanth Aravamudan <nacc@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20080508200239.GJ12654@escobedo.amd.com>
References: <1210106579.4747.51.camel@nimitz.home.sr71.net>
	 <20080508143453.GE12654@escobedo.amd.com>
	 <1210258350.7905.45.camel@nimitz.home.sr71.net>
	 <20080508151145.GG12654@escobedo.amd.com>
	 <1210261882.7905.49.camel@nimitz.home.sr71.net>
	 <20080508161925  <20080508200239.GJ12654@escobedo.amd.com>
Content-Type: text/plain
Date: Thu, 08 May 2008 13:16:27 -0700
Message-Id: <1210277787.7905.81.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-08 at 22:02 +0200, Hans Rosenfeld wrote:
> > A pmd_huge(*pmd) test is tempting, but it only ever says "yes" on x86:
> > we've carefully left it undefined what happens to the pgd/pud/pmd/pte
> > hierarchy in the general arch case, once you're amongst hugepages.
> 
> AFAIK the reason for this is that pmd_huge() and pud_huge() are
> completely x86-specific. When I looked at the huge page support for
> other archs in Linux the last time, all of them marked hugepages with
> some page size bits in the PTE, using several PTEs for a single huge
> page. So for anything but x86, the pgd/pud/pmd/pte hierarchy should work
> for hugepages, too.

powerpc kinda puts them in pmds, although Adam calls them ptes in his
diagram.  See Adam's very nice pictures here:

	http://linux-mm.org/PageTableStructure

In the arch code, they have a concept of "slices" for each mm that you
can look up the page size for.  That's what they use when the mm/vmas
aren't around.  Their pmd_ts really are just pointers.  I don't think
they have any flags in them at all like _PAGE_PSE.

They just do a special pagetable walk instead of looking *at* the
pagetables.

-- Dave

