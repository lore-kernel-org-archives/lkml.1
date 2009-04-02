Return-Path: <linux-kernel-owner+w=401wt.eu-S1764370AbZDBSmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764370AbZDBSmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZDBSml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:42:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42383 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZDBSmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:42:40 -0400
Subject: Re: [PATCH 5/6] perf_counter: add more context information
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090402183417.GA843@elte.hu>
References: <20090402091158.291810516@chello.nl>
	 <20090402091319.493101305@chello.nl> <20090402113643.GF10828@elte.hu>
	 <1238672889.8530.5908.camel@twins> <20090402181849.GD6340@elte.hu>
	 <1238696998.5133.44.camel@laptop>  <20090402183417.GA843@elte.hu>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 20:42:35 +0200
Message-Id: <1238697755.5133.62.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 20:34 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Thu, 2009-04-02 at 20:18 +0200, Ingo Molnar wrote:
> > > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > 
> > > > On Thu, 2009-04-02 at 13:36 +0200, Ingo Molnar wrote:
> > > > 
> > > > > > -#define MAX_STACK_DEPTH		255
> > > > > > +#define MAX_STACK_DEPTH		254
> > > > > >  
> > > > > >  struct perf_callchain_entry {
> > > > > > -	u64	nr;
> > > > > > +	u32	nr, hv, kernel, user;
> > > > > >  	u64	ip[MAX_STACK_DEPTH];
> > > > > >  };
> > > > 
> > > > Oh, and Paul suggested using u16s right after I send it out. So 
> > > > I'll either send an update or send a incremental in case you 
> > > > already applied it.
> > > 
> > > yes, that's probably a good idea. Although u8 might be even better - 
> > > do we ever want to do more than 256 deep stack vectors? Even those 
> > > would take quite some time to construct and pass down.
> > 
> > We'd have to pad it with 4 more bytes to remain u64 aligned,
> 
> ok, indeed.
> 
> > [...] also, why restrict ourselves. That MAX_STACK_DEPTH limit is 
> > trivially fixable if indeed someone finds its insufficient.
> 
> well .. think about it: walking more than 256 stack frames for every 
> IRQ event? Getting backtraces like:
> 
>  <func_0+0x123>
...
>  <func_269+0x123>
> 
> does that make much sense _per event_? How do you visualize it?

You can use it to calculate aggregate times. Eg. attribute the time
spend in func_0 to func_1 to func_2 etc. And use a tree view based on
these call-chains, allowing you to drill-down -- which is basically what
the sysprof GUI does.

