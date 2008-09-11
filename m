Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYIKKV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYIKKV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 06:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYIKKVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 06:21:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbYIKKVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 06:21:18 -0400
Date: Thu, 11 Sep 2008 03:20:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Alex Nixon <alex.nixon@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Globally defining phys_addr_t
Message-Id: <20080911032058.538ceb7c.akpm@linux-foundation.org>
In-Reply-To: <20080911095311.GB7795@elte.hu>
References: <48C8D76B.10901@goop.org>
	<20080911095311.GB7795@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008 11:53:11 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Hi Ingo,
> > 
> > This is a repost of a little 3-patch series which Andrew has been 
> > carrying in -mm.  It cleans up the definition of phys_addr_t to make 
> > it kernel-wide rather than x86-specific, and fixes up PFN_PHYS() to 
> > use it to avoid address truncation.
> > 
> > We currently have a few workarounds for this problem in the tree, but 
> > Alex found another bug caused by PFN_PHYS(), so it's probably better 
> > if you bring these patches into tip.git for now.
> > 
> > PowerPC also defines a phys_addr_t with the same meaning as x86; the 
> > powerpc arch maintainers are happy with these patches.
> 
> Andrew, are you fine with that approach too?

spose so.  These patches are the same as those in -mm (I checked).

Still seems a bit odd to me that we're disallowing things like 32-bit
reosurces on >4G-memory-span machines.  A resource_size_t is a
different (and narrower) concept from a physical address.

> Also, i dont see Andrew's signoffs in the patches, and that's the true 
> path of these patches which should be preserved: you => -mm => -tip.

Not really.  These went

JF -> mm

and

JF -> you

but whatever.
