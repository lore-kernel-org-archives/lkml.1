Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbXIDSTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbXIDSTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 14:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbXIDSTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 14:19:43 -0400
Received: from ozlabs.org ([203.10.76.45]:44003 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbXIDSTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 14:19:42 -0400
Subject: Re: [PATCH] Fix out-by-one error in traps.c
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lguest <lguest@ozlabs.org>, Frederik Deweerdt <deweerdt@free.fr>,
       Andi Kleen <ak@muc.de>
In-Reply-To: <alpine.LFD.0.999.0708311120030.25853@woody.linux-foundation.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	 <20070822202551.GB31846@slug>
	 <20070823145038.9895784f.akpm@linux-foundation.org>
	 <20070824060438.GE31846@slug> <46CE7EDC.9080007@goop.org>
	 <20070824082249.GG31846@slug>
	 <1188043649.20041.81.camel@localhost.localdomain>
	 <20070825122324.GA6138@slug> <20070825211405.GA18217@slug>
	 <1188230999.5531.15.camel@localhost.localdomain>
	 <20070830163812.GA22190@slug>
	 <1188512066.6353.5.camel@localhost.localdomain>
	 <alpine.LFD.0.999.0708302140480.25853@woody.linux-foundation.org>
	 <1188540238.6004.28.camel@localhost.localdomain>
	 <alpine.LFD.0.999.0708310044450.25853@woody.linux-foundation.org>
	 <1188581852.10802.13.camel@localhost.localdomain>
	 <alpine.LFD.0.999.0708311120030.25853@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 05 Sep 2007 04:18:17 +1000
Message-Id: <1188929908.10802.113.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-31 at 11:24 -0700, Linus Torvalds wrote:
> 
> On Sat, 1 Sep 2007, Rusty Russell wrote:
> > 
> > This is only for the initial booting stack (init_thread_union); see
> > arch/i386/kernel/head.S:
> > 	/* Set up the stack pointer */
> > 	lss stack_start,%esp
> > 	...
> > 	pushl $0		# fake return address for unwinder
> 
> Ok, we should fix that. We should just make it look like all other stack 
> frames.
> 
> There is other code in the kernel that "knows" that all kernel stacks have 
> the fields for the user stack return on it, namely the ptrace code etc. 
> Now, the initial stack is hopefully never *accessed* by that kind of code, 
> but this kind of special-case code is just wrong.

Yes, but -ETIMEDOUT.  Maybe for 2.6.24...

> IOW, how 
> about this one, which just declares a structure that describes the stack 
> frame thing? That just makes everything clearer, since we can then use 
> "sizeof(that structure)" instead of using the magic "2*sizeof(unsigned 
> long)".

Much nicer, thanks.

Rusty.

