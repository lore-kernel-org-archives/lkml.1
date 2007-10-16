Return-Path: <linux-kernel-owner+w=401wt.eu-S936034AbXJPVZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936034AbXJPVZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 17:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933703AbXJPVZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 17:25:26 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:56152 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933688AbXJPVZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 17:25:24 -0400
Date: Tue, 16 Oct 2007 23:25:23 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Arjan van de Ven <arjan@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LFENCE instruction
In-Reply-To: <4714DBD7.7080706@zytor.com>
Message-ID: <Pine.LNX.4.64.0710162313240.5747@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0710152204060.30307@artax.karlin.mff.cuni.cz>
 <20071015143732.01d99af8@laptopd505.fenrus.org>
 <Pine.LNX.4.64.0710160004500.2604@artax.karlin.mff.cuni.cz> <471401AF.4090802@zytor.com>
 <Pine.LNX.4.64.0710161205160.1315@artax.karlin.mff.cuni.cz> <4714DBD7.7080706@zytor.com>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007, H. Peter Anvin wrote:

> Mikulas Patocka wrote:
> > 
> > PREFETCH* doesn't change program semantics. The processor is allowed to
> > ignore prefetch instruction if it doesn't have resources needed for
> > prefetch. It not ordered wrt. fences.
> > 
> > PREFETCHNTA was implemented as prefetch into L1 cache and omitting L2 cache
> > on Pentium 3 and M --- and it is implemented as prefetch into L2 cache on
> > other --- do it doesn't really use any special buffers.
> > 
> 
> It's semantics allows it to, though.  It's not clear to me whether it is
> actually necessary on existing chips.
> 
> It does, I believe, way-restricted prefetch on existing silicon.

It is allowed to use special buffers for prefetch, but --- because 
prefetch doesn't change program semantics, these special buffers must be 
kept consistent just like caches --- they must be snooped for bus 
transactions and they must be checked each time something writes to cache.

So I doubt anyone will ever implement it this way --- it's too much 
silicon for too little effect.

Mikulas

> 	-hpa
