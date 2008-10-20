Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbYJTR2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbYJTR2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYJTR21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:28:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39997 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYJTR21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:28:27 -0400
Date: Mon, 20 Oct 2008 13:28:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linuxppc-dev@ozlabs.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] ftrace: fixes for PPC
In-Reply-To: <20081020170808.GB7249@yoda.jdub.homelinux.org>
Message-ID: <alpine.DEB.1.10.0810201327410.4852@gandalf.stny.rr.com>
References: <20080906050602.409299112@goodmis.org> <20080906120346.GA30964@elte.hu> <20081016181452.GA29739@yoda.jdub.homelinux.org> <alpine.DEB.1.10.0810161421530.11042@gandalf.stny.rr.com> <20081016183529.GB29739@yoda.jdub.homelinux.org>
 <alpine.DEB.1.10.0810161444050.11042@gandalf.stny.rr.com> <20081016150106.6ddf7e46@zod.rchland.ibm.com> <alpine.DEB.1.10.0810201222570.3760@gandalf.stny.rr.com> <20081020170808.GB7249@yoda.jdub.homelinux.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 20 Oct 2008, Josh Boyer wrote:

> On Mon, Oct 20, 2008 at 12:30:33PM -0400, Steven Rostedt wrote:
> >> Anyway, if you want a tester let me know.  It seems 2.6.27.1 should be
> >> fine since FTRACE was disabled, but for .28-rc1 it would be cool if it
> >> worked :).
> >
> >Hi Josh,
> >
> >I've been looking deeper at the code for PPC. I realized that my PPC64 box 
> >that I've been testing on did not use modules. While looking at the module 
> >code it dawned on me the dynamic ftrace needs a bit of work. This is 
> >because the way modules are handled in PPC (and other architectures as 
> >well).  The jmps used by mcount is a 24 bit jump. Since the modules are 
> >loaded farther than 24bits away, a trampoline is needed.
> 
> Ah, indeed.
> 
> >A bit of rework is needed in the ftrace infrastructure to handle the 
> >trampoline. Too much work to go into 28. I'll start working on code that 
> >can hopefully be ready and tested for 29. It's not that major of a change, 
> >but since the merge window for 28 has already been opened, we would like 
> >to get a bit more testing in before we hand it over to Linus.
> 
> That seems like a good plan.  Should we mark dynamic ftrace as X86 only
> in Kconfig for .28 to prevent people from inadvertently setting it?

Well, we probably should disable it for PPC at least. I don't know if 
sparc has the same issue.

David?

-- Steve

