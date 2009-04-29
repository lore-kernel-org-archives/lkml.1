Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZD2Fo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZD2Fo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZD2FoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 01:44:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32842 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbZD2FoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 01:44:16 -0400
Date: Wed, 29 Apr 2009 07:43:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/5] ring-buffer: fix printk output
Message-ID: <20090429054359.GA6148@elte.hu>
References: <20090429044814.138790038@goodmis.org> <20090429045908.394874083@goodmis.org> <20090428222024.8db50539.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428222024.8db50539.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 29 Apr 2009 00:48:19 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > -	printk_once(KERN_WARNING "Tracing recursion: depth[%d]:"
> > +	printk_once(KERN_WARNING "Tracing recursion: depth[%ld]:"
> 
> hrmph.  I didn't know that printk_once() existed, and I should 
> have known.  I wonder how many other people don't know.

Was posted to linux-next@vger.kernel.org.

> Should it use unlikely()?

Not really. Any printk_once() usage site is an 'unlikely' branch 
already in most cases. Double unlikely just spreads the instructions 
needlessly. The condition that _leads_ to a printk_once() should be 
an unlikely().

	Ingo
