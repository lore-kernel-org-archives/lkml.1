Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYLRWdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYLRWdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYLRWdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:33:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbYLRWdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:33:09 -0500
Date: Thu, 18 Dec 2008 23:33:03 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "jeremy@goop.org" <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 1/7] x86 PAT: store vm_pgoff for all linear_over_vma_region mappings - v3
Message-ID: <20081218223303.GK10681@wotan.suse.de>
References: <20081218194126.963894000@intel.com> <20081218194617.091839000@intel.com> <20081218212728.GD10681@wotan.suse.de> <20081218221057.GA3331@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081218221057.GA3331@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 02:10:57PM -0800, Pallipadi, Venkatesh wrote:
> On Thu, Dec 18, 2008 at 01:27:28PM -0800, Nick Piggin wrote:
> > 
> > This is fine by me, however:
> > 1. Can you add some comments to say "this is not for core vm but for pat,
> >    oh and a pgoff of zero is not going to work".
> 
> OK. Will add comments about both the points.
> 
> > 2. Can you please justify to me (or the changelog) roughly why PAT wants
> >    to know if the mapping is linear or not? Presumably it has to handle
> >    both types? If performance wasn't an issue, then you could manually scan
> >    the ptes to verify (which would solve your zero-offset bug). etc.
> 
> The main reason is performance. If we know it is linear, we can track the entire
> region as one block and do the reserve free for entire region. But, if it is
> not linear, then we have to reserve memtype of physical addresses page by page.
> This will not be optimal as it will result in reserve and free becoming
> slower. Almost all users that we find in kernel today (atleast in x86)  are
> all linear.

OK, so it is not a bug to miss the zero pgoff case then. That's good
to know and should be added to comments.

