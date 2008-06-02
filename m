Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYFBXED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYFBXED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 19:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYFBXDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 19:03:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59922 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbYFBXDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 19:03:51 -0400
Date: Tue, 3 Jun 2008 01:03:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, David Howells <dhowells@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
Message-ID: <20080602230316.GA24159@elte.hu>
References: <alpine.LFD.1.10.0805301846530.3141@woody.linux-foundation.org> <4840C29B.6030507@redhat.com> <alpine.LFD.1.10.0805302044310.3141@woody.linux-foundation.org> <4840CE51.9060109@redhat.com> <alpine.LFD.1.10.0805302109370.3141@woody.linux-foundation.org> <alpine.LFD.1.10.0805302116440.3141@woody.linux-foundation.org> <4840D63F.2090407@redhat.com> <alpine.LFD.1.10.0805311438080.3141@woody.linux-foundation.org> <20080602185433.GB4081@elte.hu> <alpine.LFD.1.10.0806021246060.3141@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806021246060.3141@woody.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > That bit can be used as a lock and if all access to the state of 
> > that atomic variable uses it, arbitrary higher-order atomic state 
> > transitions can be derived from it. The cost would be a bit more 
> > instructions in the fastpath, but there would still only be a single 
> > atomic op (the acquire op), as the unlock would be a natural barrier 
> > (on x86 at least).
> 
> No, "unlocks as a natural barrier" only works for exclusive kernel 
> locks (spin_unlock and write_unlock). There we can just do a write to 
> unlock. But for anything that wants to handle contention differently 
> than just spinning, the unlock path needs to be able to do an atomic 
> "unlock and test if I need to do something else", because it may need 
> to wake things up.

yeah, indeed. Compared to all the other costs that have to be dealt with 
here, having a second atomic op isnt all that much of an issue either, 
especially on latest hw. An atomic op will probably never be as cheap as 
a non-atomic op, but ~20 cycles is still plenty fast for most practical 
purposes.

	Ingo
