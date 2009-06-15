Return-Path: <linux-kernel-owner+w=401wt.eu-S934173AbZFOTKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934173AbZFOTKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933773AbZFOTKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:10:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39731 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934134AbZFOTKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:10:37 -0400
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
 support to use NMI-safe methods
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090615190759.GA12778@elte.hu>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org>
	 <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain>
	 <20090615171845.GA7664@elte.hu>
	 <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain>
	 <4A369508.2090707@zytor.com> <20090615184858.GD6520@Krystal>
	 <1245091917.6741.185.camel@laptop> <20090615185907.GF6520@Krystal>
	 <20090615190321.GA11641@elte.hu>  <20090615190759.GA12778@elte.hu>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 21:10:11 +0200
Message-Id: <1245093011.6741.213.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 21:07 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > To a point where it cannot afford a simple register save/restore 
> > > ?
> > > 
> > > There is "caring" and "_caring_". I am tempted to ask what NMI 
> > > handler execution frequency you have in mind here to figure out 
> > > if we are not trying to optimize sub-nanoseconds per minutes. ;)
> > 
> > I routinely run 'perf' with half a million NMIs per second or 
> > more. ( Why wait 10 seconds for a profile you can get in 1 second? 
> > ;-)
> > 
> > Granted that is over multiple CPUs - but still performance does 
> > matter here too.
> > 
> > Reading cr2 is certainly fast. Writing it - dunno.
> 
> But one thing is sure: it is certainly going to be faster than the 
> INVLPG(s!) we have to do with the GUP solution.

Sure, but we only pay that price when we do the callchain bit, not on
every NMI.

