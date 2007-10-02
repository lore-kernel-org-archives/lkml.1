Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbXJBP2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbXJBP2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbXJBP2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:28:38 -0400
Received: from owa.c2.net ([207.235.78.2]:12446 "EHLO email.c2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbXJBP2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:28:37 -0400
Subject: Re: [discuss] [PATCH] Inconsistent mmap()/mremap() flags
From: Thayne Harbaugh <thayne@c2.net>
Reply-To: thayne@c2.net
To: Hugh Dickins <hugh@veritas.com>
Cc: Andi Kleen <ak@suse.de>, discuss@x86-64.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0710021505400.2156@blonde.wat.veritas.com>
References: <1190958393.5128.85.camel@phantasm.home.enterpriseandprosperity.com>
	 <1191308772.5200.66.camel@phantasm.home.enterpriseandprosperity.com>
	 <Pine.LNX.4.64.0710021304230.26719@blonde.wat.veritas.com>
	 <200710021545.32556.ak@suse.de>
	 <Pine.LNX.4.64.0710021505400.2156@blonde.wat.veritas.com>
Content-Type: text/plain
Organization: C2
Date: Tue, 02 Oct 2007 09:21:26 -0600
Message-Id: <1191338486.5200.71.camel@phantasm.home.enterpriseandprosperity.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Oct 2007 15:28:36.0434 (UTC) FILETIME=[E674A320:01C80508]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-02 at 15:16 +0100, Hugh Dickins wrote:
> On Tue, 2 Oct 2007, Andi Kleen wrote:
> > 
> > > First call mmap with a low hint address, the new size you'll be wanting
> > > from the mremap, PROT_NONE, MAP_ANONYMOUS, -1, 0.  Then call mremap with
> > > old address, old size, new size, MREMAP_MAYMOVE|MREMAP_FIXED, and new
> > > address as returned by the preparatory mmap.
> > 
> > That's racy unfortunately in a multithreaded process. They would need to loop.
> 
> Perhaps.  Though I don't see what your loop would be doing;
> and the mapping established by the first thread would only
> be vulnerable to another thread if that were really set on
> interfering (an un-FIXED mmap by another thread will keep
> away from the area assigned to the first).
> 
> Certainly a two-stage procedure has to be weaker than one stage,
> but it is just how MAP_FIXED is normally used (isn't it?): first
> stake out an arena for all that's needed without MAP_FIXED, then
> fit into it the actual mappings required using MAP_FIXED.  Blind
> use of MAP_FIXED is always in danger of unmapping something vital.
> 
> But whether the two-stage procedure is good enough for Thayne's
> purpose, he'll have to judge for himself.

I think my eyes have been opened enough so that I can get things to work
- it's certainly better in many respects than using MAP_32BIT with its
many limitations.

Thank you.

