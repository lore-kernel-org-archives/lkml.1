Return-Path: <linux-kernel-owner+w=401wt.eu-S1760201AbXKAPSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201AbXKAPSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbXKAPSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:18:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39373 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbXKAPSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:18:13 -0400
Date: Thu, 1 Nov 2007 16:17:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch] PID namespace design bug, workaround
Message-ID: <20071101151753.GA6181@elte.hu>
References: <20071101144307.GA29566@elte.hu> <4729E7E4.8070208@openvz.org> <1193928977.27652.289.camel@twins> <4729EB88.6080408@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4729EB88.6080408@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Emelyanov <xemul@openvz.org> wrote:

> The "fix" I mention is just returning -EINVAL in case user orders 
> CLONE_NEWPIDS and compiling out all the namespace cloning code. This 
> is just a more elegant way to get rid of pid namespaces rather than 
> Ingo proposed.

unfortunately i have to NACK that approach. We never allowed broken 
user-space visible APIs into the kernel like that because it just gives 
a vector for that breakage to become de-facto used and forced upon the 
core kernel. Even if they can be .config turned off. That's just a lame 
excuse that delays the fixing of it. We may mark features that have a 
good expectation to be fixed as CONFIG_EXPERIMENTAL, and we may mark 
drivers that nobody maintains anymore as CONFIG_BROKEN, but we dont 
introduce new core syscall features with CONFIG_BROKEN! We never did and 
i hope we never will.

The _only_ way to force the fixing of such type of breakages is to not 
offer them _at all_. Really, you are proposing a major new extension to 
lots of important core Linux APIs so please try to solve this problem 
cleanly, it's really severe. Right now as things stand this containers 
sub-feature is "a little bit pregnant". This is one of the few cases 
where we really _must_ say no.

	Ingo
