Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbYDMHkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbYDMHkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 03:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYDMHkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 03:40:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49734 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbYDMHkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 03:40:31 -0400
Date: Sun, 13 Apr 2008 09:40:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Andrew <nick@nick-andrew.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, joe@perches.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] printk: Remember the message level for multi-line
	output
Message-ID: <20080413074007.GE20332@elte.hu>
References: <20080412161733.24882.30930.stgit@marcab.local.tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080412161733.24882.30930.stgit@marcab.local.tull.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Nick Andrew <nick@nick-andrew.net> wrote:

> Modify vprintk() to remember the message loglevel each time it is 
> specified and use it for subsequent lines of output which do not 
> specify one, within the same call to printk.
> 
> Restructure the logic so the processing of the leading 3 characters of 
> each input line is in one place, regardless whether printk_time is 
> enabled.

hm, i'm not sure about the change itself (printks are often random, so 
the output to the console would depend on printk ordering), but the 
combined effect seems to be a nice cleanup that reduces the linecount:

>  1 files changed, 27 insertions(+), 34 deletions(-)

so how about splitting it into two, first the code restructuring then a 
small add-on that does your feature? Does this make sense to you? This 
way, even if the feature ends up not being applied, we'll have your nice 
cleanup :-)

	Ingo
