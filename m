Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbZFXI6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbZFXI6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 04:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbZFXI6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 04:58:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41798 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbZFXI6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 04:58:37 -0400
Date: Wed, 24 Jun 2009 10:58:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf stat: fix hardcoded nr_counter
Message-ID: <20090624085812.GD18713@elte.hu>
References: <1245810296.3434.3.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245810296.3434.3.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> nr_counter should be based on number of default_attrs entries.

The problem is, this will cause a _lot_ of counters to be used by 
default, overloading the PMU quite significantly and reducing 
precision. The number of hw counters is chosen intentionally the way 
it is now, so that on common hardware there's no over-commit.

As i suggested before, your change does make sense if introduced as 
extended event specifications to 'perf stat':

 -e all
 -e all-sw-counters
 -e all-hw-counters

with regex wildcard support too.

Instead, you chose to ignore my feedback and wasted my time by 
re-sending the same broken patch. If you do such things i'll have to 
start ignoring you - it is very ineffective for me to repeat every 
argument and suggestion two or more times and no other contributor 
does this ...

> Remove dead code and some code alignment.

Could you please send this separately?

	Ingo
