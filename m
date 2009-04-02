Return-Path: <linux-kernel-owner+w=401wt.eu-S933940AbZDBSaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940AbZDBSaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933106AbZDBSaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:30:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:57123 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933966AbZDBSaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:30:05 -0400
Subject: Re: [PATCH 5/6] perf_counter: add more context information
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090402181849.GD6340@elte.hu>
References: <20090402091158.291810516@chello.nl>
	 <20090402091319.493101305@chello.nl> <20090402113643.GF10828@elte.hu>
	 <1238672889.8530.5908.camel@twins>  <20090402181849.GD6340@elte.hu>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 20:29:58 +0200
Message-Id: <1238696998.5133.44.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 20:18 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Thu, 2009-04-02 at 13:36 +0200, Ingo Molnar wrote:
> > 
> > > > -#define MAX_STACK_DEPTH		255
> > > > +#define MAX_STACK_DEPTH		254
> > > >  
> > > >  struct perf_callchain_entry {
> > > > -	u64	nr;
> > > > +	u32	nr, hv, kernel, user;
> > > >  	u64	ip[MAX_STACK_DEPTH];
> > > >  };
> > 
> > Oh, and Paul suggested using u16s right after I send it out. So 
> > I'll either send an update or send a incremental in case you 
> > already applied it.
> 
> yes, that's probably a good idea. Although u8 might be even better - 
> do we ever want to do more than 256 deep stack vectors? Even those 
> would take quite some time to construct and pass down.

We'd have to pad it with 4 more bytes to remain u64 aligned, also, why
restrict ourselves. That MAX_STACK_DEPTH limit is trivially fixable if
indeed someone finds its insufficient.



