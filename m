Return-Path: <linux-kernel-owner+w=401wt.eu-S1757470AbZBKQ0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbZBKQ0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 11:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756161AbZBKQ0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 11:26:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45746 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142AbZBKQ0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:26:43 -0500
Date: Wed, 11 Feb 2009 17:26:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -v3] futex: fix reference leak
Message-ID: <20090211162618.GC32301@elte.hu>
References: <1234197950.5951.132.camel@laptop> <1234198023.5951.133.camel@laptop> <1234200538.16083.52.camel@pc1117.cambridge.arm.com> <1234203975.5951.143.camel@laptop> <1234205595.4286.223.camel@localhost.localdomain> <1234205874.5951.151.camel@laptop> <20090211122849.GD16535@elte.hu> <1234366605.23438.179.camel@twins> <20090211154952.GB24408@elte.hu> <1234367802.23438.183.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234367802.23438.183.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2009-02-11 at 16:49 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > So you prefer this version?
> > 
> > yes, with s/out_unlock_put_key/err_unlock_put_key. That's the
> > only error path that goes via the tail of the function, correct?
> 
> Right, but I think one can argue that most of the out* jumps are errors.
> 
> The only non-error return is the !unqueue_me() case.
> 
> Also, since there's only one user of out_unlock_put_key, we might also
> do this:

yeah. Also mark it via unlikely().

	Ingo
