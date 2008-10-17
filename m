Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYJQBFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYJQBFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 21:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYJQBEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 21:04:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64857 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbYJQBEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 21:04:54 -0400
Date: Thu, 16 Oct 2008 21:04:51 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linuxppc-dev@ozlabs.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] ftrace: powerpc: remove startup functions from tracing
In-Reply-To: <1224204646.7654.52.camel@pasglop>
Message-ID: <alpine.DEB.1.10.0810162100370.20570@gandalf.stny.rr.com>
References: <20080906050602.409299112@goodmis.org>  <20080906120346.GA30964@elte.hu>  <20081016181452.GA29739@yoda.jdub.homelinux.org>  <alpine.DEB.1.10.0810162046570.20570@gandalf.stny.rr.com> <1224204646.7654.52.camel@pasglop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 17 Oct 2008, Benjamin Herrenschmidt wrote:

> On Thu, 2008-10-16 at 20:48 -0400, Steven Rostedt wrote:
> > 
> > The early init code in PowerPC is not mapped to their final locations
> > and all jumps and memory references must be done with relative jumps
> > and accesses.
> > 
> > The lib files in the powerpc directory are called in early boot, and
> > since mcount will perform direct access to memory, the lib files need
> > not be traced.
> 
> This is annoying though, because that means things like memcpy,
> copy_to_from_user etc... can't be traced. On the other hand a lot
> of that is asm and already doesn't call mcount.

Yeah, I know. I was going to pick and choose which files in there should 
be converted, but then I saw that they were mostly asm, and it seemed to 
be better safe than sorry.

Sure, we could probably bring it down a bit. But I'm a bit paranoid it may 
cause someone else not to boot because of something else being called at 
early boot up.

But don't worry. When we get MCOUNT_RECORD ported to PPC this no longer 
becomes an issue, and we can simply do a
"ifndef CONFIG_FTRACE_MCOUNT_RECORD" around the -pg removal in the 
Makefile. (or what ever the Makefile syntax is for config options)

-- Steve

