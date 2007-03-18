Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbXCRSNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbXCRSNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 14:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbXCRSNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 14:13:20 -0400
Received: from smtp.osdl.org ([65.172.181.24]:48161 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbXCRSNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 14:13:19 -0400
Date: Sun, 18 Mar 2007 10:12:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andy Whitcroft <apw@shadowen.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Bias the location of pages freed for min_free_kbytes in
 the same MAX_ORDER_NR_PAGES blocks
Message-Id: <20070318101259.f6e524f2.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703181104140.29429@skynet.skynet.ie>
References: <20070307201839.6f45735b.akpm@linux-foundation.org>
	<200703142006.04547.m.kozlowski@tuxland.pl>
	<20070314170738.d5d35c06.akpm@linux-foundation.org>
	<20070317182641.GA19447@skynet.ie>
	<20070318002244.606cfe08.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703181104140.29429@skynet.skynet.ie>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Mar 2007 11:35:36 +0000 (GMT) Mel Gorman <mel@csn.ul.ie> wrote:

> > But let me leap ahead of myself.
> >
> >> CONFIG_PAGE_GROUP_BY_MOBILITY
> >
> > Why does this config item exist?  It's not good to have some mysterious
> > knob which affects mm behaviour at compile time.  We need to make up our
> > minds and stick with it.
> >
> 
> The configuration item exists because there were concerns over the memory 
> footprint and cache line footprint. It was introduced to address that 
> concern and also so that it would be possible to compare the performance 
> behavior of anti-fragmentation. Your comment rang a bell though so I 
> searched the archives to see this comment from Andi Kleen;
> 
> ===
> If anything this should be a boot time option or perhaps sysctl, not a 
> config. In general CONFIGs that change runtime behaviour are evil - just 
> makes changing the option more painful, causes problems for distribution 
> users, doesn't make much sense, etc.etc.
> 
> Also #ifdef as a documentation device is a really really scary concept.
> Yuck.
> ===
> 
> A sysctl would avoid any cache line footprint but not the memory overhead 
> because the freelists in struct zone as those freelists would still exist. 
> I could make the option depend on CONFIG_EMBEDDED for the zone overhead. 
> Would that make sense or would it be preferable to ditch the option 
> altogether?
> 
> I'll start looking at doing a sysctl so it can be disabled at runtime if 
> necessary. I strongly suspect that it cannot be enabled again once 
> disabled but I don't see that as a problem as such.

How much additional memory consumption are we expecting here?

Whether it's runtime or compile-time, the optionality is not good.
