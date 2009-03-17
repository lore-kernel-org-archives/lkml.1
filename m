Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbZCQPQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbZCQPQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 11:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbZCQPPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 11:15:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34142 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbZCQPPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 11:15:49 -0400
Date: Tue, 17 Mar 2009 16:15:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Subject: Re: [patch 1/5] x86, bts: detect size of DS fields
Message-ID: <20090317151536.GA13895@elte.hu>
References: <20090313104218.A30096@sedona.ch.intel.com> <20090313110357.GC31094@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77E4A663C47@irsmsx504.ger.corp.intel.com> <20090317105558.GK6477@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77E4A664285@irsmsx504.ger.corp.intel.com> <20090317123442.GB22759@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77E4A6642C7@irsmsx504.ger.corp.intel.com> <928CFBE8E7CB0040959E56B4EA41A77E4A6643E0@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E4A6643E0@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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
> >From: Metzger, Markus T
> >Sent: Tuesday, March 17, 2009 1:58 PM
> >To: Ingo Molnar
> 
> 
> >>> I think I found the problem:
> >>>   ds_request_bts() needs to allocate a small amount of memory.
> >>>   It uses GFP_KERNEL.
> >>>
> >>> Hw-branch-tracer essentially does on_each_cpu(ds_request_bts()).
> >>>
> >>> Since ds_request_bts() is meant to be called on the cpu that
> >>> should be traced, it should use GFP_ATOMIC to allow calls from
> >>> smp_call_function() and friends.
> >>>
> >>> Would that be acceptable?
> >>
> >>That's not really a good solution - GFP_ATOMIC is not a reliable
> >>form of allocation.
> 
> That problem also is in the .29-rc version.
> It affects the hw-branch-tracer.
> The ptrace interface should not be affected.
> 
> The changes I sketched below will be too intrusive.
> Do you want a small patch that turns GFP_KERNEL into GFP_ATOMIC
> for .29?

Yeah - but it will be for .29.1 - the hw-branch-tracer is off by 
default.

	Ingo
