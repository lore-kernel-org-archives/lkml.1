Return-Path: <linux-kernel-owner+w=401wt.eu-S1760272AbYDBWw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272AbYDBWw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbYDBWwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:52:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755995AbYDBWwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:52:49 -0400
Date: Wed, 2 Apr 2008 15:51:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Fix SMP-reordering race in mark_buffer_dirty
In-Reply-To: <Pine.LNX.4.64.0804030035550.15850@artax.karlin.mff.cuni.cz>
Message-ID: <alpine.LFD.1.00.0804021548440.14670@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0804022058530.13737@artax.karlin.mff.cuni.cz> <alpine.LFD.1.00.0804021237031.14670@woody.linux-foundation.org> <Pine.LNX.4.64.0804022238460.25023@artax.karlin.mff.cuni.cz> <alpine.LFD.1.00.0804021422570.14670@woody.linux-foundation.org>
 <alpine.LFD.1.00.0804021433300.14670@woody.linux-foundation.org> <Pine.LNX.4.64.0804030035550.15850@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Apr 2008, Mikulas Patocka wrote:
> 
> When I added memory reads around mfence, the combined result was worse 
> than the sum of reads and mfence --- mfence alone 8 ticks, mfence+4reads 
> 18 ticks.

Sorry, my test-program was buggy.

> mfence+writes scales linearly, i.e. mfence + 4 writes does 12 ticks.

I get different results now that I fixed my memop test. I get a loop with 
reads and writes taking 3 cycles without mfence, and 21 cycles with (read 
after, write before). 

			Linus
