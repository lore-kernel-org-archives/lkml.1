Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbYDMHJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbYDMHJR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 03:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbYDMHJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 03:09:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58211 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbYDMHJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 03:09:03 -0400
Date: Sun, 13 Apr 2008 09:08:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Roland Dreier <rdreier@cisco.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Oeser <ioe-lkml@rameria.de>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080413070833.GC19773@elte.hu>
References: <20080411210022.GJ11962@parisc-linux.org> <1208003081.7427.7.camel@twins> <20080412172606.GL11962@parisc-linux.org> <adaskxqrgsl.fsf@cisco.com> <20080412204748.GN11962@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080412204748.GN11962@parisc-linux.org>
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


* Matthew Wilcox <matthew@wil.cx> wrote:

> Yes, that text appears in the URL I provided in the mail that started 
> this thread ;-)
> 
> The semaphore rewrite I did does not have this problem (it's less 
> efficient than the hand-optimised assembler, but much more 
> maintainable). You're supposed to be using mutexes if you want 
> efficiency anyway.

but semaphores will be _removed_, _completely_. Rewriting them in 
generic C code is just the first step towards that - it consolidates all 
the myriads of semaphore implementations that Linux has spread out.

your proposed change to change completions to semaphores is totally 
backwards and prolongs an API we want to get rid of. Did you miss this 
aspect of the mutex rewrite, of the semaphore-to-mutex, 
semaphore-to-completions and semaphore-to-rwsem conversions?

	Ingo
