Return-Path: <linux-kernel-owner+w=401wt.eu-S1759824AbXFUUSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824AbXFUUSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbXFUUSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:18:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48619 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbXFUUSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:18:30 -0400
Date: Thu, 21 Jun 2007 22:18:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Jarek Poplawski <jarkao2@o2.pl>,
       Miklos Szeredi <miklos@szeredi.hu>, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070621201816.GE22303@elte.hu>
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org> <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org> <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> No, the cache line arbitration doesn't know anything about "locked" vs 
> "unlocked" instructions (it could, but there really is no point).
> 
> The real issue is that locked instructions on x86 are serializing, 
> which makes them extremely slow (compared to just a write), and then 
> by being slow they effectively just make the window for another core 
> bigger.
> 
> IOW, it doesn't "fix" anything, it just hides the bug with timing.

yeah. I think Linux is i think the only OS on the planet that is using 
the movb trick for unlock, it even triggered a hardware erratum ;) So it 
might surprise some hw makers who might rely on the heuristics that each 
critical section lock and unlock is a LOCK-ed instruction.

	Ingo
