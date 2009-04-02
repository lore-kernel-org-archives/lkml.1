Return-Path: <linux-kernel-owner+w=401wt.eu-S932776AbZDBSTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776AbZDBSTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757637AbZDBSTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:19:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51693 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbZDBSTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:19:03 -0400
Date: Thu, 2 Apr 2009 20:18:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] perf_counter: add more context information
Message-ID: <20090402181849.GD6340@elte.hu>
References: <20090402091158.291810516@chello.nl> <20090402091319.493101305@chello.nl> <20090402113643.GF10828@elte.hu> <1238672889.8530.5908.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238672889.8530.5908.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2009-04-02 at 13:36 +0200, Ingo Molnar wrote:
> 
> > > -#define MAX_STACK_DEPTH		255
> > > +#define MAX_STACK_DEPTH		254
> > >  
> > >  struct perf_callchain_entry {
> > > -	u64	nr;
> > > +	u32	nr, hv, kernel, user;
> > >  	u64	ip[MAX_STACK_DEPTH];
> > >  };
> 
> Oh, and Paul suggested using u16s right after I send it out. So 
> I'll either send an update or send a incremental in case you 
> already applied it.

yes, that's probably a good idea. Although u8 might be even better - 
do we ever want to do more than 256 deep stack vectors? Even those 
would take quite some time to construct and pass down.

	Ingo
