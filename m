Return-Path: <linux-kernel-owner+w=401wt.eu-S932833AbYEFUH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833AbYEFUH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764391AbYEFUH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:07:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763656AbYEFUH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:07:26 -0400
Date: Tue, 6 May 2008 13:06:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
cc: Ingo Molnar <mingo@elte.hu>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Hans Rosenfeld <hans.rosenfeld@amd.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
In-Reply-To: <Pine.LNX.4.64.0805062043580.11647@blonde.site>
Message-ID: <alpine.LFD.1.10.0805061302080.32269@woody.linux-foundation.org>
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com> <20080506124946.GA2146@elte.hu> <Pine.LNX.4.64.0805061435510.32567@blonde.site> <alpine.LFD.1.10.0805061138580.32269@woody.linux-foundation.org>
 <Pine.LNX.4.64.0805062043580.11647@blonde.site>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 May 2008, Hugh Dickins wrote:
>
> Fix Hans' good observation that follow_page() will never find pmd_huge()
> because that would have already failed the pmd_bad test: test pmd_huge in
> between the pmd_none and pmd_bad tests.  Tighten x86's pmd_huge() check?
> No, once it's a hugepage entry, it can get quite far from a good pmd: for
> example, PROT_NONE leaves it with only ACCESSED of the KERN_PGTABLE bits.

I'd much rather have pdm_bad() etc fixed up instead, so that they do a 
more proper test (not thinking that a PSE page is bad, since it clearly 
isn't). And then, make them dependent on DEBUG_VM, because doing the 
proper test will be more expensive.

Hmm?

		Linus
