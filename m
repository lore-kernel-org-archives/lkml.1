Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbZBKSmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbZBKSmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 13:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756905AbZBKSme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 13:42:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65420 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765AbZBKSme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 13:42:34 -0500
Date: Wed, 11 Feb 2009 13:42:32 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Luck, Tony" <tony.luck@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
       "kaneshige.kenji@jp.fujitsu.com" <kaneshige.kenji@jp.fujitsu.com>
Subject: RE: [PATCH 0/8] git pull request for tip/tracing/core
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA361689CF0@orsmsx505.amr.corp.intel.com>
Message-ID: <alpine.DEB.1.10.0902111341170.15438@gandalf.stny.rr.com>
References: <20090208054955.777429253@goodmis.org> <20090209093751.GD7930@elte.hu> <20090211153650.GA19576@elte.hu> <alpine.DEB.1.10.0902111147450.15438@gandalf.stny.rr.com> <alpine.DEB.1.10.0902111158380.15438@gandalf.stny.rr.com> <20090211171622.GA13239@elte.hu>
 <alpine.DEB.1.10.0902111227570.15438@gandalf.stny.rr.com> <20090211173131.GA27546@elte.hu> <57C9024A16AD2D4C97DC78E552063EA361689C3B@orsmsx505.amr.corp.intel.com> <alpine.DEB.1.10.0902111320010.15438@gandalf.stny.rr.com>
 <57C9024A16AD2D4C97DC78E552063EA361689CF0@orsmsx505.amr.corp.intel.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 11 Feb 2009, Luck, Tony wrote:

> > The bits in question is really the number of possible nested interrupts
> > that can happen. We take the paranoid approach that we can have a max
> > nesting of NR_IRQS. Perhaps this can be changed, and just do a max of
> > 1<<10 nesting? And have a big warn on if it happens to be bigger, or fall
> > to another counter if it is bigger.
> >
> > 1000 nested IRQs seems a bit extreme :-/
> 
> Ah, I see.  Then the answer is very different.  The number of nested
> interrupts possible on a cpu is limited by the number of priority
> classes for interrupts (See Table 5-8 on page 2:112 of the Itanium
> software developers manual).  Effectively the max nesting depth is
> 16.
> 
> 1000 nested interrupts would be certain to run us out of stack.

Ingo,

Do you think this is a good assumption to make, that no arch will have 
over 1<<10 nested interrupts. We can add a WARN_ON if it happens. Then we 
can make all archs have a 10 bit offset. Smaller may also be sufficient.

-- Steve

