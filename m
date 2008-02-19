Return-Path: <linux-kernel-owner+w=401wt.eu-S1762378AbYBSXMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762378AbYBSXMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbYBSXL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:11:59 -0500
Received: from ns2.suse.de ([195.135.220.15]:47309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186AbYBSXL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:11:59 -0500
Date: Wed, 20 Feb 2008 00:11:57 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: akpm@linux-foundation.org, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch] my mmu notifiers
Message-ID: <20080219231157.GC18912@wotan.suse.de>
References: <20080219084357.GA22249@wotan.suse.de> <20080219135851.GI7128@v2.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219135851.GI7128@v2.random>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 02:58:51PM +0100, Andrea Arcangeli wrote:
> On Tue, Feb 19, 2008 at 09:43:57AM +0100, Nick Piggin wrote:
> > anything when changing the pte to be _more_ permissive, and I don't
> 
> Note that in my patch the invalidate_pages in mprotect can be
> trivially switched to a mprotect_pages with proper params. This will
> prevent page faults completely in the secondary MMU (there will only
> be tlb misses after the tlb flush just like for the core linux pte),
> and it'll allow all the secondary MMU pte blocks (512/1024 at time
> with my PT lock design) to be updated to have proper permissions
> matching the core linux pte.

Sorry, I realise I still didn't get this through my head yet (and also
have not seen your patch recently). So I don't know exactly what you
are doing...

But why does _anybody_ (why does Christoph's patches) need to invalidate
when they are going to be more permissive? This should be done lazily by
the driver, I would have thought.
