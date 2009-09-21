Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbZIUHcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbZIUHcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZIUHcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:32:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47477 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbZIUHcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:32:48 -0400
Date: Mon, 21 Sep 2009 09:32:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:perfcounters/core] x86, perf_counter, bts: Optimize BTS
	overflow handling
Message-ID: <20090921073232.GC24467@elte.hu>
References: <20090915130023.A16204@sedona.ch.intel.com> <tip-5622f295b53fb60dbf9bed3e2c89d182490a8b7f@git.kernel.org> <928CFBE8E7CB0040959E56B4EA41A77EC69BA609@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC69BA609@irsmsx504.ger.corp.intel.com>
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


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> >-----Original Message-----
> >From: tip tree robot [mailto:bounces.tip@hpa.at.zytor.com] On Behalf Of tip-bot for Markus Metzger
> >Sent: Friday, September 18, 2009 9:19 PM
> >To: linux-tip-commits@vger.kernel.org
> >Cc: linux-kernel@vger.kernel.org; hpa@zytor.com; mingo@redhat.com; a.p.zijlstra@chello.nl; Metzger,
> >Markus T; tglx@linutronix.de; mingo@elte.hu
> >Subject: [tip:perfcounters/core] x86, perf_counter, bts: Optimize BTS overflow handling
> >
> >Commit-ID:  5622f295b53fb60dbf9bed3e2c89d182490a8b7f
> >Gitweb:     http://git.kernel.org/tip/5622f295b53fb60dbf9bed3e2c89d182490a8b7f
> >Author:     Markus Metzger <markus.t.metzger@intel.com>
> >AuthorDate: Tue, 15 Sep 2009 13:00:23 +0200
> >Committer:  Ingo Molnar <mingo@elte.hu>
> >CommitDate: Fri, 18 Sep 2009 20:43:20 +0200
> >
> >x86, perf_counter, bts: Optimize BTS overflow handling
> >
> >Draining the BTS buffer on a buffer overflow interrupt takes too
> >long resulting in a kernel lockup when tracing the kernel.
> >
> >Restructure perf_counter sampling into sample creation and sample
> >output.
> >
> >Prepare a single reference sample for BTS sampling and update the
> >from and to address fields when draining the BTS buffer. Drain the
> >entire BTS buffer between a single perf_output_begin() /
> >perf_output_end() pair.
> >
> >Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
> >Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >LKML-Reference: <20090915130023.A16204@sedona.ch.intel.com>
> >Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> Ingo,
> 
> This change should speed up BTS overflow handling enough to support
> branch tracing the kernel.
> Would you please drop 1653192f510bd8114b7b133d7289e6e5c3e95046
> that disabled kernel tracing to work around the issue.

Please send a proper patch that re-enables the (previously unreliable) 
aspect of BTS tracing, with a changelog that explains that the feature 
now works and with an indication that you've tested it.

	Ingo
