Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbYDBWkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbYDBWkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbYDBWjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:39:55 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:42952 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbYDBWjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:39:55 -0400
Date: Thu, 3 Apr 2008 00:39:54 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Fix SMP-reordering race in mark_buffer_dirty
In-Reply-To: <alpine.LFD.1.00.0804021433300.14670@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0804030035550.15850@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0804022058530.13737@artax.karlin.mff.cuni.cz>
 <alpine.LFD.1.00.0804021237031.14670@woody.linux-foundation.org>
 <Pine.LNX.4.64.0804022238460.25023@artax.karlin.mff.cuni.cz>
 <alpine.LFD.1.00.0804021422570.14670@woody.linux-foundation.org>
 <alpine.LFD.1.00.0804021433300.14670@woody.linux-foundation.org>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Linus Torvalds wrote:

> On Wed, 2 Apr 2008, Linus Torvalds wrote:
> > 
> > Core 2 is the outlier in having a noticeably faster "mfence" than atomic 
> > instructions
> 
> Side note: mfence is probably faster than 6 cycles on Core 2. I've seen it 
> be basically zero-cost. Try adding a few memory ops around it - the timing 
> will probably change. Core 2 has this odd behaviour that it sometimes does 
> worse on the *really* trivial things that don't happen in real life.
> 
> 			Linus

When I added memory reads around mfence, the combined result was worse 
than the sum of reads and mfence --- mfence alone 8 ticks, mfence+4reads 
18 ticks.

mfence+writes scales linearly, i.e. mfence + 4 writes does 12 ticks.

mfence can fully overlap with register operations.

Mikulas
