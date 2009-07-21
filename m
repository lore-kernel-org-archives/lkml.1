Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbZGUHGC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbZGUHGC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 03:06:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZGUHGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 03:06:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:60061 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbZGUHF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 03:05:59 -0400
Date: Tue, 21 Jul 2009 09:05:58 +0200
From: Nick Piggin <npiggin@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Memory Management <linux-mm@kvack.org>,
       Linux-Arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Hugh Dickins <hugh@tiscali.co.uk>
Subject: Re: [RFC/PATCH] mm: Pass virtual address to [__]p{te,ud,md}_free_tlb()
Message-ID: <20090721070558.GA7816@wotan.suse.de>
References: <20090715074952.A36C7DDDB2@ozlabs.org> <20090715135620.GD7298@wotan.suse.de> <1247709255.27937.5.camel@pasglop> <20090720081054.GH7298@wotan.suse.de> <1248084041.30899.7.camel@pasglop> <20090720103835.GB7070@wotan.suse.de> <1248134546.30899.27.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248134546.30899.27.camel@pasglop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 10:02:26AM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2009-07-20 at 12:38 +0200, Nick Piggin wrote:
> > On Mon, Jul 20, 2009 at 08:00:41PM +1000, Benjamin Herrenschmidt wrote:
> > > On Mon, 2009-07-20 at 10:10 +0200, Nick Piggin wrote:
> > > > 
> > > > Maybe I don't understand your description correctly. The TLB contains
> > > > PMDs, but you say the HW still logically performs another translation
> > > > step using entries in the PMD pages? If I understand that correctly,
> > > > then generic mm does not actually care and would logically fit better
> > > > if those entries were "linux ptes". 
> > > 
> > > They are :-)
> > > 
> > > > The pte invalidation routines
> > > > give the virtual address, which you could use to invalidate the TLB.
> > > 
> > > For PTEs, yes, but not for those PMD entries. IE. I need the virtual
> > > address when destroying PMDs so that I can invalidate those "indirect"
> > > pages. PTEs are already taken care of by existing mechanisms.
> > 
> > Hmm, so even after having invalidated all the pte translations
> > then you still need to invalidate the empty indirect page? (or
> > maybe you don't even invalidate the ptes if they're not cached
> > in a TLB).
> 
> The PTEs are cached in the TLB (ie, they turn into normal TLB entries). 
> 
> We need to invalidate the indirect entries when the PMD value change
> (ie, when the PTE page is freed) or the TLB would potentially continue
> loading PTEs from a stale PTE page :-)
> 
> Hence my patch adding the virtual address to pte_free_tlb() which is the
> freeing of a PTE page. I'm adding it to the pmd/pud variants too for
> consistency and because I believe there's no cost.

Yes I think we're on the same page now. So as I said, the
patch is quite OK with me.

