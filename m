Return-Path: <linux-kernel-owner+w=401wt.eu-S1762919AbYFEB7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762919AbYFEB7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 21:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbYFEB66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 21:58:58 -0400
Received: from mail.suse.de ([195.135.220.2]:53998 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbYFEB66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 21:58:58 -0400
Date: Thu, 5 Jun 2008 03:58:57 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
Message-ID: <20080605015857.GD4327@wotan.suse.de>
References: <alpine.LFD.1.10.0805302116440.3141@woody.linux-foundation.org> <4840D63F.2090407@redhat.com> <alpine.LFD.1.10.0805311438080.3141@woody.linux-foundation.org> <20080602185433.GB4081@elte.hu> <alpine.LFD.1.10.0806021246060.3141@woody.linux-foundation.org> <20080602230316.GA24159@elte.hu> <20080603032403.GA17089@wotan.suse.de> <alpine.LFD.1.10.0806041249470.3473@woody.linux-foundation.org> <alpine.LFD.1.10.0806041320020.3473@woody.linux-foundation.org> <20080605015634.GC4327@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605015634.GC4327@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 03:56:34AM +0200, Nick Piggin wrote:
> 
> The other thing that could be possible, and I'd imagine maybe more likely
> to be implemented in a real CPU because it should give more imrpovement
> (and which does break my algorithm) is just that the load to the cacheline
> may get to execute first, then if the cacheline gets evicted and
> modified by another CPU before our store completes, we effectively see
> store/load reordering again.

Well, I should qualify that: it doesn't actually break my algorithm
because you can still implement the unlock without atomic RMWs.
This may require you to have an mfence there, but we can still get
away without atomics (whether that's much cheaper or not, I haven't
measured recently!)
