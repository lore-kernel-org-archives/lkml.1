Return-Path: <linux-kernel-owner+w=401wt.eu-S1761245AbZFMHEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761245AbZFMHEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 03:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbZFMHER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 03:04:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54056 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbZFMHEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 03:04:16 -0400
Date: Sat, 13 Jun 2009 09:04:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: perf_counters: page fault trace record
Message-ID: <20090613070411.GA6682@elte.hu>
References: <4A330022.3070105@linux.vnet.ibm.com> <18995.8319.322002.917595@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18995.8319.322002.917595@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Corey Ashford writes:
> 
> > One of the tools we are working on needs to be able to look not only at counts 
> > of page faults, but where they are occurring (ip and faulting page address).
> > 
> > What would you think about adding a new bit to the config record, something like:
> 
> Can't you do what you need just using a page fault software 
> counter with sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_ADDR and 
> sample_period = 1?

Yes, we should use a generic 'data address' field. A whole lot of 
interesting events can live with that - only full-blown generic 
tracepoints have more complex sample record formats.

Also, if this feature is added to pagefaults, please also add 
support for it into tools/perf/, so that it gets tested/used.

Thanks,

	Ingo
