Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbZCCTE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbZCCTE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 14:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZCCTEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 14:04:47 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:58649 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753144AbZCCTEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 14:04:47 -0500
Date: Tue, 3 Mar 2009 13:53:47 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, penberg@cs.helsinki.fi, riel@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org,
       linux-kernel@vger.kernel.org, ming.m.lin@intel.com,
       yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 20/20] Get rid of the concept of hot/cold page freeing
In-Reply-To: <20090303135254.GE10577@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903031350020.18013@qirst.com>
References: <20090224115126.GB25151@csn.ul.ie> <20090224160103.df238662.akpm@linux-foundation.org> <20090225160124.GA31915@csn.ul.ie> <20090225081954.8776ba9b.akpm@linux-foundation.org> <20090226163751.GG32756@csn.ul.ie> <alpine.DEB.1.10.0902261157100.7472@qirst.com>
 <20090226171549.GH32756@csn.ul.ie> <alpine.DEB.1.10.0902261226370.26440@qirst.com> <20090227113333.GA21296@wotan.suse.de> <alpine.DEB.1.10.0902271039440.31801@qirst.com> <20090303135254.GE10577@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009, Mel Gorman wrote:

> > And only if the page allocator gets fast enough to be usable for
> > allocs instead of quicklists.
> It appears the x86 doesn't even use the quicklists. I know patches for
> i386 support used to exist, what happened with them?

The x86 patches were not applied because of an issue with early NUMA
freeing. The problem has been fixed but the x86 patches were left
unmerged. There was also an issue with the quicklists growing too large.

> That aside, I think we could win slightly by just knowing when a page is
> zeroed and being freed back to the allocator such as when the quicklists
> are being drained. I wrote a patch along those lines but it started
> getting really messy on x86 so I'm postponing it for the moment.

quicklist tied into the tlb freeing logic. The tlb freeing logic could
itself keep a list of zeroed pages which may be cleaner.

