Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbYDQAfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbYDQAfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 20:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYDQAfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 20:35:13 -0400
Received: from ozlabs.org ([203.10.76.45]:53817 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711AbYDQAfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 20:35:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18438.39737.921541.359469@cargo.ozlabs.ibm.com>
Date: Thu, 17 Apr 2008 10:35:05 +1000
From: Paul Mackerras <paulus@samba.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC patch 23/27] Immediate Values - Powerpc Optimization NMI
	MCE support
In-Reply-To: <20080416233331.GA9225@Krystal>
References: <20080416213426.298498397@polymtl.ca>
	<20080416213556.704299869@polymtl.ca>
	<18438.34621.508450.720068@cargo.ozlabs.ibm.com>
	<20080416233331.GA9225@Krystal>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers writes:

> * Paul Mackerras (paulus@samba.org) wrote:
> > Mathieu Desnoyers writes:
> > 
> > > Use an atomic update for immediate values.
> > 
> > What is meant by an "atomic" update in this context?  AFAICS you are
> > using memcpy, which is not in any way guaranteed to be atomic.
> > 
> > Paul.
> 
> I expect memcpy to perform the copy in one memory access, given I put a 
> 
>   .align 2
> 
> before the 2 bytes instruction. It makes sure the instruction modified
> fits in a single, aligned, memory write.

My original question was in the context of the powerpc architecture,
where instructions are always 4 bytes long and aligned.  So that's not
an issue.

> Or maybe am I expecting too much from memcpy ?

I don't think memcpy gives you any such guarantees.  It would be quite
within its rights to say "it's only a few bytes, I'll do it byte by
byte".

If you really want it to be atomic (which I agree is probably a good
idea), I think the best way to do it is to use an asm to generate a
sth (store halfword) instruction to the immediate field (instruction
address + 2).  That's on powerpc of course; I don't know what you
would do on other architectures.

Paul.
