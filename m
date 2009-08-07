Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbZHGNGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbZHGNGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 09:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbZHGNGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 09:06:16 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:48774 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbZHGNGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 09:06:15 -0400
X-SourceIP: 213.93.53.227
Subject: RE: [patch] x86, perf_counter, bts: add bts to perf_counter
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC1BFF0A0@irsmsx504.ger.corp.intel.com>
References: <20090721155648.A17047@sedona.ch.intel.com>
	 <1249381489.7924.186.camel@twins> <20090804111412.GA20942@elte.hu>
	 <20090804113555.GA28198@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFEEE3@irsmsx504.ger.corp.intel.com>
	 <1249633282.32113.613.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com>
	 <1249640949.32113.647.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF0A0@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 15:05:58 +0200
Message-Id: <1249650358.32113.710.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 13:18 +0100, Metzger, Markus T wrote:

> >Right, what I'm worried about though is the BTS overload scenario.
> >Normally when we'd create more counters than we'd have hardware for we'd
> >simply time share the stuff.
> >
> >However BTS now has a second class fallback for period==1 which
> >complicates all this because it will likely not generate consistent
> >results.
> >
> >So I was thinking that _if_ the hardware supports BTS we'd not do the
> >fallback to generic bits if event == HW_BRANCH_INST && period == 1.
> >
> >I agree on the period > 1 using the generic counters.
> 
> 
> OK, that makes sense.
> 
> So I'll still check for sample_period=1 but when I fail to acquire BTS, I don't
> fall back to the generic counter and return an error instead.
> 
> Is that it?

Yeah, something like that, simply return -EBUSY/-EAGAIN or so.

However I'd look into adding something to intel_pmu_init() which would
set intel_bts_available to 1 when the CPU should support BTS, that'll
ease the reserve_bts_hardware() error case and help with allowing this
fallback as well.



