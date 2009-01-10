Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbZAJPfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbZAJPfn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 10:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZAJPfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 10:35:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40636 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbZAJPfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 10:35:30 -0500
Date: Sat, 10 Jan 2009 16:34:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Snitzer <snitzer@gmail.com>
Cc: Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       jim owens <jowens@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, sam@ravnborg.org,
       Dave Anderson <anderson@redhat.com>
Subject: Re: source line numbers with x86_64 modules? [Was: Re: [patch]
	measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact]
Message-ID: <20090110153446.GA13976@elte.hu>
References: <170fa0d20901100621m74680e0ewd1916c70f1636c9b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170fa0d20901100621m74680e0ewd1916c70f1636c9b@mail.gmail.com>
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


* Mike Snitzer <snitzer@gmail.com> wrote:

> Yes, especially from someone who lacks the ability to properly configure 
> kdump.  I'm fairly surprised others are giving you a free pass when you 
> keep asserting how broken kdump is with such hollow criticism.  I rely 
> heavily on kdump and it works quite well (kvm integration was lacking 
> but has improved).

hm, you say you rely heavily on kdump ... for what exactly, and how does 
it help the upstream Linux kernel?

I see a single fix from you in the whole repository:

  ffc41cf: nbd: prevent sock_xmit from attempting to use a NULL socket

... and that single fix is a NULL pointer dereference that ought to have 
been quite debuggable from a plain oops alone.

In practice i rarely see bugfixes that were debugged via kdump. Normal 
oops based fixes outnumber kdump based fixes by a ratio of 1:100 or worse 
- and kdump is readily available these days - just nobody configures it.

For example, in the whole kernel repo there's just 45 commits that mention 
'kdump' [excluding those commits that develop kdump itself]:

  $ git log --pretty=format:"%h: %s" --no-merges -i --grep="kdump" |
        grep -viE 'kdump|kexec|dump|mem' | wc -l
  45

Contrast that to the 1954 commits that contain the string 'oops' or 
'crash':

  $ git log --pretty=format:"%h: %s" --no-merges -i -E --grep="oops|crash" |
            wc -l
  5900

That's a ratio of 1:131. (and probably optimistic in favor of kdump.)

Note, i dont have any negative feelings towards kdump - some people use it 
and enterprise folks with their frozen, immutable kernels love it - it 
just has not yet given me a reason to have particularly positive feelings 
towards it in the upstream kernel space.

	Ingo
