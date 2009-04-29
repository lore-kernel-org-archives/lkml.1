Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbZD2LTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbZD2LTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZD2LTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:19:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54965 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbZD2LTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:19:39 -0400
Date: Wed, 29 Apr 2009 13:19:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/29] x86/perfcounters: rework
	pmc_amd_save_disable_all() and pmc_amd_restore_all()
Message-ID: <20090429111934.GA8298@elte.hu>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com> <1241002046-8832-5-git-send-email-robert.richter@amd.com> <1241003260.8021.236.camel@laptop> <20090429111159.GJ2373@elte.hu> <1241003785.8021.248.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241003785.8021.248.camel@laptop>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2009-04-29 at 13:11 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > On Wed, 2009-04-29 at 12:47 +0200, Robert Richter wrote:
> > > > MSR reads and writes are expensive. This patch adds checks to avoid
> > > > its usage where possible.
> > > 
> > > save_disable_all()
> > > enable(1)
> > > restore_all()
> > > 
> > > would not correctly enable 1 with the below modification as we do 
> > > not write the configuration into the msr, on which restore relies, 
> > > as it only toggles the _ENABLE bit.
> > > 
> > > That said, I'm not sure if that's really an issue, but its why the 
> > > does does as it does.
> > > 
> > > A better abstraction could perhaps avoid this issue all-together.
> > 
> > Could we remove the disable-all facility altogether and make the 
> > core code NMI-safe? The current approach wont scale on CPUs that 
> > dont have global-disable features.
> > 
> > disable-all was arguably a hack i introduced and which spread too 
> > far. Can you see a conceptual need for it?
> 
> power suffers the same issue and simply iterates the things like 
> amd does now.
> 
> The thing is, with a global disable you get slightly better 
> coupling, so in that respect it might be nice to have.

ok. With system-wide profiling there's no global disable/enable in 
the fastpath. Do we have any of them in the per task counter 
fastpath?

	Ingo
