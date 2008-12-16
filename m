Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbYLPNNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbYLPNNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 08:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbYLPNNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 08:13:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:44121 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbYLPNNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 08:13:39 -0500
Date: Tue, 16 Dec 2008 14:13:30 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net
Subject: Re: [patch] Performance Counters for Linux, v4
Message-ID: <20081216141330.1943c30d@infradead.org>
In-Reply-To: <20081216130302.GA27678@elte.hu>
References: <20081214212829.GA9435@elte.hu>
	<20081216122229.GA1430@ucw.cz>
	<20081216125000.GC25019@elte.hu>
	<20081216125720.GC1684@ucw.cz>
	<20081216130302.GA27678@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 14:03:02 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> > >  - plus you have to forbid SMT CPUs as well. On HT a task could
> > >    co-schedule with your setuid task and observe its timing
> > >    characteristics via its _own_ behavior. (which is impacted by
> > > whatever is running on another SMT/HT thread.)  
> > 
> > Yes, SMT is evil.  
> 
> HT got added back to Nehalem, so SMT is coming to you in every future
> x86 CPU. It brings a serious performance win, so nobody will turn off
> SMT threading in practice. If SMT worries you, it needs explicit
> partitioning of security-relevant processing to different physical
> CPUs, via cgroups/cpusets/etc.

and/or you use properly implemented crypto code (see Bruce Schneider's
books). The timing "problem" isn't really SMT specific. If you have
improperly implemented crypto (eg crypto code where the code paths and
not just the data payload are key dependent) then on any system with
more than one (logical) processor there is interference that an
attacker can use.

The only possible answer is to use proper implementation; turning off HT
may make you feel good but you go from shoddy crypto for which there is
some internet papers on how to crack it, to shoddy crypto for which the
same papers apply ;)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
