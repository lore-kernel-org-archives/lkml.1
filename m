Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001Ab0A2AX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab0A2AX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 19:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820Ab0A2AXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 19:23:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752583Ab0A2AXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 19:23:54 -0500
Date: Thu, 28 Jan 2010 16:21:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Kyle Moffett <kyle@moffetthome.net>, tytso@mit.edu,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
In-Reply-To: <1264722786.20211.15.camel@pasglop>
Message-ID: <alpine.LFD.2.00.1001281612260.3800@localhost.localdomain>
References: <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain>  <20100122200129.GG22003@redhat.com>  <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>  <20100122221348.GA4263@redhat.com>  <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>
  <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>  <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>  <20100123112333.GA15455@elte.hu> <20100123114729.GA7828@redhat.com>  <20100123194820.GM21263@thunk.org> 
 <f73f7ab81001241742t1f827ddetd958e1949787020f@mail.gmail.com>  <alpine.LFD.2.00.1001250845180.3574@localhost.localdomain> <1264722786.20211.15.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Jan 2010, Benjamin Herrenschmidt wrote:
> 
> like returning a fd to poll() on ? :-)

Well, there's the possibility of async polling (rather than the 
synchronous wait that ptrace forces now), but there are other advantages 
to having a "connection" model - like not having to look up the child 
process every time like ptrace does now.

Although 'find_task_by_vpid()' is probably cheap enough that nobody really 
cares. We do a fair job at those hash tables.

			Linus
