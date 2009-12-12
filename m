Return-Path: <linux-kernel-owner+w=401wt.eu-S1761377AbZLLKHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377AbZLLKHG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 05:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZLLKHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 05:07:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50752 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbZLLKHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 05:07:03 -0500
Date: Sat, 12 Dec 2009 11:06:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Message-ID: <20091212100656.GA25286@elte.hu>
References: <20091211232805.GA10652@kroah.com>
 <20091212084611.GA28266@elte.hu>
 <20091212013927.58d386d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091212013927.58d386d1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> Have a trace.  I'm actually wondering if perhaps there's a missing 
> unlock_kernel() somewhere else, and the tty code is just the victim of 
> that.

Unlikely i'd say. I have 1000+ successful overnight tests on the latest 
tree Linus pushed out:

 3ef884b: Merge branch 'drm-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/d

So that's a guaranteed 'good' kernel.

The moment i merged 053fe57 into -tip the lockups started, so that's a 
guaranteed 'bad' kernel. There's only the TTY changes between those two 
points that look remotely related.

It's spurious though so quite hard to bisect. I tried one bisection 
today already and it got on the wrong track. I'll do a brute-force 
revert of the commits i quoted, lets see what happens.

	Ingo
