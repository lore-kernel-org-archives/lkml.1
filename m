Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYFBSy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYFBSy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 14:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbYFBSyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 14:54:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40753 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbYFBSys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 14:54:48 -0400
Date: Mon, 2 Jun 2008 20:54:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mtk.manpages@gmail.com
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
Message-ID: <20080602185433.GB4081@elte.hu>
References: <200805310127.m4V1RLR4013808@devserv.devel.redhat.com> <alpine.LFD.1.10.0805301846530.3141@woody.linux-foundation.org> <4840C29B.6030507@redhat.com> <alpine.LFD.1.10.0805302044310.3141@woody.linux-foundation.org> <4840CE51.9060109@redhat.com> <alpine.LFD.1.10.0805302109370.3141@woody.linux-foundation.org> <alpine.LFD.1.10.0805302116440.3141@woody.linux-foundation.org> <4840D63F.2090407@redhat.com> <alpine.LFD.1.10.0805311438080.3141@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805311438080.3141@woody.linux-foundation.org>
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

> IOW, I'm faking it, but I'm making a point. Namely that you can 
> efficiently do read-write lock using *only* 32-bit ops, and without 
> any real kind of limitations on the number of readers and writers.
> 
> So here goes the explanation and the pseudo-code.
> 
>  - have two levels of locking: the contended case, and the uncontended
>    case

i suspect _any_ abstract locking functionality around a data structure 
can be implemented via atomic control over just a single user-space bit.

That bit can be used as a lock and if all access to the state of that 
atomic variable uses it, arbitrary higher-order atomic state transitions 
can be derived from it. The cost would be a bit more instructions in the 
fastpath, but there would still only be a single atomic op (the acquire 
op), as the unlock would be a natural barrier (on x86 at least).

Concurrency (and scheduling) of that lock would still be exactly the 
same as with genuine 64-bit (or even larger) atomic ops, and the 
fastpath would be very close as well.

	Ingo
