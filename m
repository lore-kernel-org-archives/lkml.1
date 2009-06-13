Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbZFMKJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbZFMKJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 06:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbZFMKJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 06:09:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60627 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbZFMKJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 06:09:20 -0400
Date: Sat, 13 Jun 2009 12:09:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: perf_counters: page fault trace record
Message-ID: <20090613100916.GA9959@elte.hu>
References: <4A330022.3070105@linux.vnet.ibm.com> <18995.8319.322002.917595@cargo.ozlabs.ibm.com> <4A336700.3060309@linux.vnet.ibm.com> <18995.28357.164575.925080@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18995.28357.164575.925080@cargo.ozlabs.ibm.com>
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
> > Paul Mackerras wrote:
> > > Can't you do what you need just using a page fault software 
> > > counter with sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_ADDR 
> > > and sample_period = 1?
> > 
> > I thought about that, but I was under the (incorrect?) 
> > impression that on Power, the PERF_SAMPLE_ADDR would be set by 
> > the value of the SDAR register, which wouldn't be correct for 
> > the case of a page fault.
> 
> No, the PERF_SAMPLE_ADDR value only comes from SDAR for a hardware 
> counter overflow event.  For the page-fault software counter the 
> PERF_SAMPLE_ADDR value will always be the faulting address.

Corey, could you please add support for it in 'perf'? We dont want 
such sw-counter features to be in the kernel code without matching 
support in tools/perf/.

While user data symbols wont be resolved, if we have a 
--target-address switch in perf record we could see the faulting 
frequency (and the fault coverage - and ordering as well) of shared 
libraries, in perf report and perf annotate.

This would be a very useful facility.

Thanks,

	Ingo
