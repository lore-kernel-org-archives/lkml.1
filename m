Return-Path: <linux-kernel-owner+w=401wt.eu-S933965AbYB2WrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965AbYB2WrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761165AbYB2Wq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:46:57 -0500
Received: from waste.org ([66.93.16.53]:57794 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761131AbYB2Wqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:46:55 -0500
Subject: Re: [RFC][PATCH] make /proc/pid/pagemap work with huge pages and
	return page size
From: Matt Mackall <mpm@selenic.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, linux-kernel@vger.kernel.org,
       Adam Litke <aglitke@gmail.com>, nacc <nacc@linux.vnet.ibm.com>,
       Jon Tollefson <kniht@linux.vnet.ibm.com>,
       Adam Litke <agl@linux.vnet.ibm.com>
In-Reply-To: <1204324234.2086.14.camel@nimitz.home.sr71.net>
References: <20080220135743.GA10127@escobedo.amd.com>
	 <1203733096.14838.154.camel@cinder.waste.org>
	 <1203791461.11305.135.camel@nimitz.home.sr71.net>
	 <20080225120951.GA5963@escobedo.amd.com>
	 <1203964750.28196.7.camel@nimitz.home.sr71.net>
	 <20080226202533.GD5963@escobedo.amd.com>
	 <1204134244.5207.28.camel@nimitz.home.sr71.net>
	 <20080228120055.GF5963@escobedo.amd.com>
	 <1204246151.23269.3.camel@nimitz.home.sr71.net>
	 <1204247745.4021.41.camel@cinder.waste.org>
	 <1204324234.2086.14.camel@nimitz.home.sr71.net>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 16:46:12 -0600
Message-Id: <1204325172.4175.31.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 14:30 -0800, Dave Hansen wrote:
> On Thu, 2008-02-28 at 17:15 -0800, Matt Mackall wrote:
> > > The only issue is that this is *after* the code has decided that a
> > > particular virtual area is for huge pages.  The best arch-generic
> > > interface I know for that is: is_vm_hugetlb_page(), but that is
> > > VMA-based.  Perhaps we should change the pagemap walk to pass the VMA
> > > around. 
> > 
> > I'd rather avoid that. Requiring a VMA to poke at these things shouldn't
> > -really- be necessary.
> 
> Yeah, this is strictly true.  But, it also assumes that we have all of
> the data about where large pages are based on the contents of the
> pagetables alone.  It's possible that we can derive this, or code up a
> bunch of arch-specific functions to do this, but it certainly doesn't
> exist today.  I'm just not keen on going and learning about how each and
> every architecture encodes hugetlb information in their pagetables. :(
> 
> The fact is that we treat pagetables in hugetlb areas completely
> differently than normal pages.  All of the generic functions that deal
> with pagetables magically punt over to the hugetlb code when they see a
> hugetlb VMA.
> 
> I think although it isn't strictly necessary, it is going to save a ton
> of work to just pass the VMAs around.

Well in any case, step 1 should be to finalize the interface. Let's
start with a single patch that does nothing but move the exported bits
around and makes room for the page shift bits. Are we agreed on what
that should look like now?

ps: my laptop died on Tuesday, so I'll be struggling to even read email
until its replacement arrives.

-- 
Mathematics is the supreme nostalgia of our time.

