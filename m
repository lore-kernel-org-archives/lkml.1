Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbZDBLph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbZDBLph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZDBLp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:45:27 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:44136 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbZDBLp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:45:26 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 5/6] perf_counter: add more context information
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090402113643.GF10828@elte.hu>
References: <20090402091158.291810516@chello.nl>
	 <20090402091319.493101305@chello.nl>  <20090402113643.GF10828@elte.hu>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 13:46:10 +0200
Message-Id: <1238672770.8530.5901.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 13:36 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Put in counts to tell which ips belong to what context.
> > 
> >   -----
> >    | |  hv
> >    | --
> > nr | |  kernel
> >    | --
> >    | |  user
> >   -----
> 
> btw., i have an observation about the format:
> 
> > -#define MAX_STACK_DEPTH		255
> > +#define MAX_STACK_DEPTH		254
> >  
> >  struct perf_callchain_entry {
> > -	u64	nr;
> > +	u32	nr, hv, kernel, user;
> >  	u64	ip[MAX_STACK_DEPTH];
> >  };
> 
> For the special case of signal notifications, if the signal is 
> delivered immediately to the same task that raised it (pid=0), the 
> call chain is actually a still meaningful one: it is the stack that 
> is below the currently executing signal handler context.
> 
> Wouldnt it make sense to record the full stack frame for that case, 
> to allow walking/unwinding of the stack? Or can user-space do that 
> just fine, based on its own signal context?

I think it can do that just fine or even better than we can -- userspace
having access to a full dwarf2 unwinder and such.

> We are going to hard-code the "call-chain is a series of IPs, 
> nothing else" model, and i'd like to make sure it's future-proof :)

I think it should be, function return addresses are the primary piece of
information here.

