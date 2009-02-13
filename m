Return-Path: <linux-kernel-owner+w=401wt.eu-S1760538AbZBMObz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760538AbZBMObz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZBMObr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:31:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47315 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbZBMObr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:31:47 -0500
Subject: Re: irq-disabled vs vmap vs text_poke
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       akpm <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090213142521.GB31922@Krystal>
References: <1234529407.6519.28.camel@twins>
	 <20090213125505.GE18462@wotan.suse.de> <1234530138.6519.38.camel@twins>
	 <20090213130450.GB9346@elte.hu>  <20090213142521.GB31922@Krystal>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Feb 2009 15:33:46 +0100
Message-Id: <1234535626.6519.113.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-13 at 09:25 -0500, Mathieu Desnoyers wrote:
> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > > I think I got a mostly working patch cobbled together sitting here
> > > > somewhere. I was waiting for some _really_ good use case before spending
> > > > more time on it. I would prefer if at all possible to do vmap operations
> > > > in sleepable, process context.
> > > 
> > > Agreed, I think we want to fix text_poke() and make the vmap/vunmap()
> > > ops yell louder at violations of these rules.
> > > 
> > > I'm just totally clueless wrt text_poke() hence this email ;-)
> > 
> > also, this started triggering yesterday for the first time - and never
> > saw it before. Has some commit caused this side-effect?
> > 
> > It triggers during kprobes self-test - has that been improved recently?
> > 
> 
> When is this self-test run ? If it's at early boot while still in UP
> with interrupts off, kprobes should probably use text_poke_early()
> rather than text_poke().

Looking at the dmesg it looks to be post smp-init, so its late init
calls.

I think its the do_initcalls() from do_basic_setup(). So the machine
should be mostly up and running.
