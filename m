Return-Path: <linux-kernel-owner+w=401wt.eu-S1764492AbXGaOWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764492AbXGaOWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762257AbXGaOWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:22:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51814 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761775AbXGaOWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:22:42 -0400
Date: Tue, 31 Jul 2007 16:22:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 1/2] RT: Preemptible Function-Call-IPI Support
Message-ID: <20070731142235.GB22209@elte.hu>
References: <46AEEEA50200005A00028665@mcclure.wal.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AEEEA50200005A00028665@mcclure.wal.novell.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5003]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <ghaskins@novell.com> wrote:

> > as far as the prioritization of function calls goes, _that_ makes 
> > sense, but it should not be a separate API but should be done to our 
> > normal workqueue APIs. That not only extends the effects of 
> > priorities to all current workqueue using kernel subsystems, but 
> > also keeps the API more unified. We really dont want to have too 
> > many -rt specific APIs.
> 
> I agree with you that having some kind of priority and cpu-binding 
> specifiers for work-queues would be very cool indeed.  However, note 
> that I didn't actually introduce a new API(*), per se.  I simply 
> worked under the existing smp_call_function[_single]() API.
> 
> Using the smp_call_functions is critical design factor, however.  I 
> really want clients of this function to seamlessly transition to 
> threaded mode. [...]

well, 'clients' of this function are low-level architectural bits like 
the scheduler and the TLB flush code which stays atomic nevertheless. 
smp_call_function() is _not_ a true generic framework and to 'thread' it 
is wrong and misplaced and leads to the kind of over-complification that 
your patch shows. Please work based on the workqueue APIs.

	Ingo
