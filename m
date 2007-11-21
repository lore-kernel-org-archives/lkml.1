Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbXKUUKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbXKUUKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 15:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbXKUUKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 15:10:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60943 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbXKUUKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 15:10:04 -0500
Date: Wed, 21 Nov 2007 21:09:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: linux-kernel@vger.kernel.org
Subject: Re: some thoughts about TSC based delay_tsc()
Message-ID: <20071121200958.GA30663@elte.hu>
References: <200711212057.10465.mitov@issp.bas.bg> <20071121192754.GA22769@elte.hu> <200711212206.34339.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711212206.34339.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Marin Mitov <mitov@issp.bas.bg> wrote:

> On Wednesday 21 November 2007 09:27:54 pm you wrote:
> > * Marin Mitov <mitov@issp.bas.bg> wrote:
> > > Hi Ingo,
> > >
> > > The patch is quite good ;-) but we forget when it is needed :-( In 
> > > fact we need it only for PREEMPT SMP kernels - it could hurt 
> > > PREEMPT UP kernels (no migration possible), so no need for 
> > > preempt_disable()/preempt_enable().
> > >
> > > In short the old version of delay_tsc() is good for UP kernels and 
> > > NON PREEMPT SMP kernels too.
> >
> > please reply to the public list, so that discussions do not get lost.
> >
> > i dont think there's any problem: udelay() is about _wasting_ cycles -
> > it's what drivers use for short delays.
> 
> Sure for the thread executing udelay(), but not for the other ready 
> threads which should also wait till preempt_enable() to grab the same 
> cpu even for PREEMPT (UP or SMP) kernels (or I misunderstand 
> something?).

on non-PREEMPT kernels there's no real difference between old and and 
new code because the kernel is not preemptible. So we can use the new 
code unconditionally.

	Ingo
