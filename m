Return-Path: <linux-kernel-owner+w=401wt.eu-S933932AbXDBGgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933932AbXDBGgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 02:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933936AbXDBGgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 02:36:01 -0400
Received: from ozlabs.org ([203.10.76.45]:45222 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933932AbXDBGgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 02:36:00 -0400
Subject: Re: [patch 04/17] Add pagetable accessors to pack and unpack
	pagetable entries
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200704020812.18320.ak@suse.de>
References: <20070402055652.610711908@goop.org>
	 <20070402055704.278590661@goop.org>  <200704020812.18320.ak@suse.de>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 16:35:24 +1000
Message-Id: <1175495724.12230.442.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 08:12 +0200, Andi Kleen wrote:
> On Monday 02 April 2007 07:56, Jeremy Fitzhardinge wrote:
> > Add a set of accessors to pack, unpack and modify page table entries
> > (at all levels).  This allows a paravirt implementation to control the
> > contents of pgd/pmd/pte entries.  For example, Xen uses this to
> > convert the (pseudo-)physical address into a machine address when
> > populating a pagetable entry, and converting back to pphys address
> > when an entry is read.
> 
> What do the benchmarks say with CONFIG_PARAVIRT on native hardware
> compared to !CONFIG_PARAVIRT. e.g. does lmbench suffer? 

This patch by itself, definitely: I gathered stats previously simply
measuring the number of calls, and it's comparable to the other calls we
had to patch.

So it's clear that the patch infrastructure needs to cover them.  We can
debate whether we should extend patching to everything as 1/17 does, or
just to mkpte and pteval.

I'd still like to see new microbench stats tho.

Cheers!
Rusty.

