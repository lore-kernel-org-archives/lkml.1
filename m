Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015Ab0AVXzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab0AVXzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 18:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379Ab0AVXzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 18:55:24 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:53430 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab0AVXzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 18:55:23 -0500
Subject: Re: [RFC] [PATCH 0/7] UBP, XOL and Uprobes [ Summary of Comments
	and actions to be taken ]
From: Jim Keniston <jkenisto@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Avi Kivity <avi@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Mel Gorman <mel@csn.ul.ie>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1264183574.4283.1558.camel@laptop>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100122070232.GA2975@linux.vnet.ibm.com>
	 <1264183574.4283.1558.camel@laptop>
Content-Type: text/plain
Date: Fri, 22 Jan 2010 15:55:11 -0800
Message-Id: <1264204511.5150.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2010-01-22 at 19:06 +0100, Peter Zijlstra wrote:
> On Fri, 2010-01-22 at 12:32 +0530, Srikar Dronamraju wrote:
> 
> > 2. XOL vma vs Emulation vs Single Stepping Inline vs using Protection
> > Rings.
> > 	XOL VMA is an additional process address vma.  This is
> > 	opposition to add an additional vma without user actually
> > 	requesting for the same.
> > 
> > 	XOL vma and single stepping inline are the two architecture
> > 	independent implementations. While other implementations are
> > 	more architecture specific. Single stepping inline wouldnt go
> > 	well with multithreaded process.
> > 
> > 	Even though XOL vma has its own issues, we will go with it since
> > 	other implementations seem to have more complications.
> > 
> > 	we would look forward to implementing boosters later. 
> > 	Later on, if we come across another techniques with lesser
> > 	side-effects than the XOL vma, we would switch to using them.
> 
> How about modifying glibc to reserve like 64 bytes on the TLS structure
> it has and storing the ins and possible boost jmp there? Since each
> thread can only have a single trap at any one time that should be
> enough.

We once implemented something similar, but using an area just beyond the
top of the stack instead of TLS.  We figured it would never pass muster
because we have to temporarily map the page executable (and undo it
after the single-step), and this felt like a big security hole.  I'd
think we'd have the same concern with TLS.

Jim

