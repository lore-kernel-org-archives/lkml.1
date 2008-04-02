Return-Path: <linux-kernel-owner+w=401wt.eu-S1761363AbYDBVgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761363AbYDBVgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbYDBVgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:36:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755078AbYDBVgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:36:06 -0400
Date: Wed, 2 Apr 2008 14:35:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Fix SMP-reordering race in mark_buffer_dirty
In-Reply-To: <alpine.LFD.1.00.0804021422570.14670@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0804021433300.14670@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0804022058530.13737@artax.karlin.mff.cuni.cz> <alpine.LFD.1.00.0804021237031.14670@woody.linux-foundation.org> <Pine.LNX.4.64.0804022238460.25023@artax.karlin.mff.cuni.cz>
 <alpine.LFD.1.00.0804021422570.14670@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Apr 2008, Linus Torvalds wrote:
> 
> Core 2 is the outlier in having a noticeably faster "mfence" than atomic 
> instructions

Side note: mfence is probably faster than 6 cycles on Core 2. I've seen it 
be basically zero-cost. Try adding a few memory ops around it - the timing 
will probably change. Core 2 has this odd behaviour that it sometimes does 
worse on the *really* trivial things that don't happen in real life.

			Linus
