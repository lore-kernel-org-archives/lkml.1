Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555Ab0ARMHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab0ARMHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237Ab0ARMHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:07:53 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:36613 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab0ARMHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:07:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vtch2ZqMIoqlBOXVrpqDA/Kfsf3JjekRMVXEfMkM0c1hLJWO+JuOkargnn8E2tu8WH
         3jTwa3PrKsBMM7gA35ogyc6W//zKjqJ2K1ImBwkgtAYcqukU+b/Mk06feQ7A23tRacwY
         xImUnTpE1GfJdLJKWKeuwqfMhVDAifjDb/SlA=
Date: Mon, 18 Jan 2010 13:07:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net
Subject: Re: [PATCH] perf: fix the is_software_event() definition
Message-ID: <20100118120747.GG5256@nowhere>
References: <4b4c761b.0338560a.1eaa.ffff824d@mx.google.com> <1263312616.4244.153.camel@laptop> <bd4cb8901001130154p732672b6x56e758c1ab33a8e8@mail.gmail.com> <1263400193.4244.238.camel@laptop> <bd4cb8901001130852y1de007cbqe66d77605c1ec372@mail.gmail.com> <bd4cb8901001130922s7ad85af6w6c631d90de177ef9@mail.gmail.com> <20100117141233.GF5035@nowhere> <1263813189.4283.245.camel@laptop> <1263815616.4283.332.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263815616.4283.332.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 12:53:36PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 12:13 +0100, Peter Zijlstra wrote:
> > On Sun, 2010-01-17 at 15:12 +0100, Frederic Weisbecker wrote:
> > 
> > > You need to also call pmu->disable() if it is a software event,
> > > because a breakpoint needs to be unregistered in hardware level
> > > too.
> > 
> > breakpoint isn't a software pmu. But yeah, enable and disable need to
> > match.
> 
> That is, it shouldn't be a software pmu, because we assume software
> events can always be scheduled, whereas that's definitely not so for the
> breakpoint one.
> 
> Which seems to suggest the following
> 
> ---
> Subject: perf: fix the is_software_event() definition
> 
> When adding the breakpoint pmu Frederic forgot to exclude it from being
> a software event. While we're at it, make it an inclusive expression.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>



Agreed.

But then Stephane will need to update his patch and use
something else than is_software_event() to guess if an event
needs its pmu->enable/disable to be called.

A kind of helper that can tell: I am not handled by
hw_perf_group_sched_in()

But I suck too much in naming to propose something sane :)

