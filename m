Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbYHTOvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbYHTOvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbYHTOvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:51:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34807 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245AbYHTOvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:51:21 -0400
Date: Wed, 20 Aug 2008 16:51:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: handle weak symbol functions
Message-ID: <20080820145105.GB829@elte.hu>
References: <alpine.DEB.1.10.0808200049140.13132@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808200049140.13132@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> During tests and checks, I've discovered that there were failures to 
> convert mcount callers into nops. Looking deeper into these failures, 
> code that was attempted to be changed was not an mcount caller. The 
> current code only updates if the code being changed is what it 
> expects, but I still investigate any time there is a failure.
> 
> What was happening is that a weak symbol was being used as a reference 
> for other mcount callers. That weak symbol was also referenced 
> elsewhere so the offsets were using the strong symbol and not the 
> function symbol that it was referenced from.
> 
> This patch changes the setting up of the mcount_loc section to search 
> for a global function that is not weak. It will pick a local over a 
> weak but if only a weak is found in a section, a warning is printed 
> and the mcount location is not recorded (just to be safe).
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

applied to tip/tracing/ftrace, thanks Steve!

	Ingo
