Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbZBTCIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbZBTCIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 21:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbZBTCIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 21:08:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39286 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbZBTCIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 21:08:44 -0500
Date: Thu, 19 Feb 2009 21:08:42 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] changes for tip, and a nasty x86 page table bug 
In-Reply-To: <alpine.LFD.2.00.0902191753240.21686@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0902192107230.31658@gandalf.stny.rr.com>
References: <20090220011316.379904625@goodmis.org> <alpine.LFD.2.00.0902191753240.21686@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 19 Feb 2009, Linus Torvalds wrote:

> 
> 
> On Thu, 19 Feb 2009, Steven Rostedt wrote:
> > 
> > In doing this change, I stumbled upon a nasty bug in the page handling
> > of the x86 code, where we can fall into a state where the PTE
> > has the RW bit set, but the PMD does not.
> 
> How do we ever have a PMD that is read-only? That sounds like a bug to 
> begin with. There's no reason to ever do that.

Patch 2/6 explains how this happened, and supplies the fix.

> 
> In fact, it should trigger the pmd_bad() tests if it ever happens, 
> wouldn't it? We want all the _KERNPG_TABLE bits to always be set, no?

I'm not sure what would do a pmd_bad check.

-- Steve

