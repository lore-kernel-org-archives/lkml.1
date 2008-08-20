Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbYHTVlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbYHTVlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbYHTVk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:40:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:45647 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbYHTVk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:40:58 -0400
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Eran Liberty <liberty@extricom.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>,
       Scott Wood <scottwood@freescale.com>, Alan Modra <amodra@au1.ibm.com>,
       Segher Boessenkool <segher@kernel.crashing.org>
In-Reply-To: <48AC23F4.80900@extricom.com>
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com>
	 <48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal>
	 <48A9AFA7.8080508@freescale.com>
	 <alpine.DEB.1.10.0808181425090.796@gandalf.stny.rr.com>
	 <1219110814.8062.2.camel@pasglop>
	 <alpine.DEB.1.10.0808182208110.13401@gandalf.stny.rr.com>
	 <1219113549.8062.13.camel@pasglop> <1219114600.8062.15.camel@pasglop>
	 <alpine.DEB.1.10.0808182304300.13401@gandalf.stny.rr.com>
	 <1219119431.8062.35.camel@pasglop> <1219216705.21386.46.camel@pasglop>
	 <alpine.DEB.1.10.0808200913070.13132@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0808200916090.13132@gandalf.stny.rr.com>
	 <48AC1DD8.9080702@extricom.com>
	 <alpine.DEB.1.10.0808200941560.13132@gandalf.stny.rr.com>
	 <48AC23F4.80900@extricom.com>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 07:37:51 +1000
Message-Id: <1219268271.21386.67.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hmm... so whats now?
> 
> Is there a way to prove this scenario is indeed the one that caused the 
> opps?

I've verified in sim that the crash in do_lookup() I was seeing (similar
backtrace) was indeed caused by an interrupt coming between those two
instructions and clobbering the saved GPRs.

So I think it's very likely our problem.

Ben.


