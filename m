Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0CDC7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 21:59:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41386 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab0CDC7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 21:59:38 -0500
Date: Thu, 4 Mar 2010 03:59:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: eranian@google.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
       paulus@samba.org, robert.richter@amd.com, fweisbec@gmail.com
Subject: Re: [RFC][PATCH 07/11] perf: Provide PERF_SAMPLE_REGS
Message-ID: <20100304025908.GC23633@elte.hu>
References: <bd4cb8901003030930q4050d074k11a45c3583b96502@mail.gmail.com>
 <1267637995.25158.96.camel@laptop>
 <bd4cb8901003030949v3db2db41o9cc1a65d53c370@mail.gmail.com>
 <20100303.095553.105186917.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100303.095553.105186917.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> And more generally aren't we supposed to be able to eventually analyze perf 
> dumps on any platform not just the one 'perf' was built under?

A aidenote: in this cycle Arnaldo improved this aspect of perf (and those 
changes are now upstream). In theory you should be able to do a 'perf record' 
+ 'perf archive' on your Sparc box and then analyze it via 'perf report' on an 
x86 box - and vice versa.

( Note, it was not tested in that specific combination - another combination
  was tested by Arnaldo: 32-bit PA-RISC profile interpreted on 64-bit x86. )

So yes, i agree that at minimum perf should be able to tell apart the nature 
of any recording and flag combinations it cannot handle (yet).

Btw, i think the most popular use of PEBS is its precise nature, not the 
register dumping aspect per se. If the kernel can provide that transparently 
then that's a usecase that does not need a register dump (in user-space that 
is). It's borderline doable on x86 ...

Thanks,

	Ingo
