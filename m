Return-Path: <linux-kernel-owner+w=401wt.eu-S1751829AbZH0Inl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbZH0Inl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 04:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZH0Ink
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 04:43:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52707 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbZH0Inj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 04:43:39 -0400
Date: Thu, 27 Aug 2009 10:43:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: remove PERF_SAMPLE_RAW
Message-ID: <20090827084321.GD2131@elte.hu>
References: <1251361073.18584.46.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251361073.18584.46.camel@twins>
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

* Peter Zijlstra <peterz@infradead.org> wrote:

> Apparently people think trace-events became an ABI the moment perf 
> exported them, regardless what the text surrounding 
> PERF_SAMPLE_RAW said about the opaqueness of the data provided.

Well it's still opaque and the descriptor of what it means is in 
debugfs so it's not an ABI as the comment says.

> I'm not willing to make anything trace related into an ABI, hence 
> remove this.

This removes quite a bit of nice functionality we already have, so i 
think it's (way) too heavy handed.

I think what we want is the golden middle: a per tracepoint 
property. I.e. we would provide:

    TRACE_EVENT_STABLE()

or TRACE_EVENT_CORE() or TRACE_EVENT_ABI() - which carries a 'will 
maintain this as an ABI' promise from the maintainer who adds it.

Also, tracepoints are a unidirectional channel of information - in 
practice those are way easier to handle as an ABI than other ABIs 
such as behavior, semantics, etc. So i'd expect there to be a 
healthy set of 'stable' tracepoints.

	Ingo
