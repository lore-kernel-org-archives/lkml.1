Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbZHZDgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbZHZDgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 23:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756583AbZHZDgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 23:36:49 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:41366 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571AbZHZDgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 23:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QXyDN0BfF0KRuqq+KVwRtGw+aFI25uHiLAFAnOf8gvloNbUs5giAfOwXALjG0C79m7
         H1xRk6s18YGhxy3vCB+S0ULchTZjthD2H7OhORlPS4vmVqIwLCt7KoF+T+pJ2VwUCPTb
         pkfGpaQ5uRL6qJTgeI/uBvkeO3RlngwpHTfYs=
Date: Wed, 26 Aug 2009 05:36:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch 0/1] HW-BKPT: Allow per-cpu kernel-space Hardware
	Breakpoint requests
Message-ID: <20090826033637.GB6245@nowhere>
References: <20090817124641.GA13354@in.ibm.com> <20090819161119.GA3633@in.ibm.com> <20090819173259.GF4972@nowhere> <20090820172719.GA16499@in.ibm.com> <20090821142811.GF11098@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821142811.GF11098@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 04:28:11PM +0200, Ingo Molnar wrote:
> 
> * K.Prasad <prasad@linux.vnet.ibm.com> wrote:
> 
> > > Providing those would let us build a pmu struct on top of this 
> > > high level API, hopefully.
> 
> Note that there's a PMU struct already in 
> arch/x86/kernel/cpu/perf_counter.c. Could debug-register ops be 
> tacked on to it?



No, we don't need to build an arch level pmu since the BP api
already handles the arch abstraction (or well, it is planned to).

Instead, what we need is a core pmu that relies on the BP api.
Such pmu will be allocated dynamically while creating a hardware
breakpoint counter.

