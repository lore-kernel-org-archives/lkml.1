Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbZBKUkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbZBKUkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 15:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbZBKUj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 15:39:57 -0500
Received: from relay1.sgi.com ([192.48.179.29]:45563 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755085AbZBKUj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 15:39:57 -0500
Date: Wed, 11 Feb 2009 14:39:55 -0600
From: Jack Steiner <steiner@sgi.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Mike Travis <travis@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
       "kaneshige.kenji@jp.fujitsu.com" <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [PATCH 0/8] git pull request for tip/tracing/core
Message-ID: <20090211203954.GA9137@sgi.com>
References: <20090208054955.777429253@goodmis.org> <20090209093751.GD7930@elte.hu> <20090211153650.GA19576@elte.hu> <alpine.DEB.1.10.0902111147450.15438@gandalf.stny.rr.com> <alpine.DEB.1.10.0902111158380.15438@gandalf.stny.rr.com> <20090211171622.GA13239@elte.hu> <alpine.DEB.1.10.0902111227570.15438@gandalf.stny.rr.com> <20090211173131.GA27546@elte.hu> <57C9024A16AD2D4C97DC78E552063EA361689C3B@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA361689C3B@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 09:57:00AM -0800, Luck, Tony wrote:
> > > Before we go and make the change, Peter brought up a good point on IRC. Is
> > > there any reason that ia64 needs 1 << 14 IRQs?  That's 16384!
> > >
> > > Perhaps the better solution wolud be (if possible), to simply lower the
> > > number of bits.
> >
> > i'm the wrong person to be asked about that. (Cc:-ed the right people)
> 
> People build some pretty big systems on ia64.  SGI's largest has 4096
> cpus ... so 16384 IRQs is only 4 per cpu.  That doesn't sound like very
> many to me.

As long as per-cpu interrupts (ex., timer, cpe_hndlr, cmc_hndlr, etc) are not counted
in the IRQ count, SGI is ok with  256 IRQs. We had problems overflowing the old
limit of 256 but have worked around it.

If per-cpu interrupts ARE counted in the total IRQs, then we currently use 5
per-cpu interrupts for each cpu. A 4k cpu config will need 20k IRQs + additional
IRQs for real devices.

I know the IRQ infrastructure has changed recently so this may no longer apply.


--- jack
