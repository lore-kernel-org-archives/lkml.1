Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZK3WMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZK3WMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 17:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbZK3WMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 17:12:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752274AbZK3WMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 17:12:52 -0500
Date: Mon, 30 Nov 2009 14:11:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
In-Reply-To: <alpine.LFD.2.00.0911302300550.24119@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0911301409560.2872@localhost.localdomain>
References: <20091123145409.GA29627@wotan.suse.de>  <alpine.LFD.2.00.0911280927180.2561@localhost>  <20091130100041.GA29610@infradead.org>  <alpine.LFD.2.00.0911300722370.2872@localhost.localdomain>  <20091130174638.GA9782@elte.hu> 
 <alpine.LFD.2.00.0911302206370.24119@localhost.localdomain> <1259616429.26472.499.camel@laptop> <alpine.LFD.2.00.0911302300550.24119@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Nov 2009, Thomas Gleixner wrote:
> 
> Yeah, forgot to mention sched.c, but that's solvable

It should be fairly easy to add a few 'spin_lock(&tasklist_lock)' around 
stuff that really depended on exclusion from writers. That should 
_hopefully_ be the rare case.

The biggest problem is that there will almost inevitably be things that 
get missed, and any races exposed by lacking locking will be _very_ hard 
to debug and trigger. So what I'd be worried about is not getting to a 
"practically working" state, but any really subtle cases that nobody 
really hits in practice.

			Linus
