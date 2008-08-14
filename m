Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbYHNB0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbYHNB0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 21:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYHNB0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 21:26:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbYHNB0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 21:26:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Fcc: ~/Mail/linus
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC PATCH] x86 alternatives : fix LOCK_PREFIX race with	preemptible
 kernel and CPU hotplug
In-Reply-To: Jeremy Fitzhardinge's message of  Wednesday, 13 August 2008 18:22:22 -0700 <48A388CE.2020404@goop.org>
References: <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com>
	<489CE90D.1040902@goop.org>
	<alpine.LFD.1.10.0808081750060.3462@nehalem.linux-foundation.org>
	<alpine.DEB.1.10.0808082113090.3707@gandalf.stny.rr.com>
	<20080813175213.GA8679@Krystal>
	<alpine.LFD.1.10.0808131119290.3462@nehalem.linux-foundation.org>
	<20080813184142.GM1366@one.firstfloor.org>
	<20080813193011.GC15547@Krystal>
	<20080813193715.GQ1366@one.firstfloor.org>
	<20080813200119.GA18966@Krystal>
	<20080813234156.GA25775@Krystal>
	<48A375E3.9090609@zytor.com>
	<48A388CE.2020404@goop.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080814012638.BA70D154495@magilla.localdomain>
Date: Wed, 13 Aug 2008 18:26:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That said, I wonder how useful it is to do the SMP->UP code transition.  
> How often does a kernel go from being SMP to UP in a situation where we 
> really care about the performance?  And that won't be shortly be 
> becoming SMP again anyway?

I agree, it only seems worthwhile to do this substitution when from the
config+hardware it's determined at boot that nr_cpus_possible==1 (i.e. no
CPU hotplug possibility).


Thanks,
Roland
