Return-Path: <linux-kernel-owner+w=401wt.eu-S969557AbXEHXJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969557AbXEHXJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031630AbXEHXJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:09:23 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:18331 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969479AbXEHXJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:09:21 -0400
Date: Tue, 8 May 2007 16:13:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Rientjes <rientjes@google.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] doc: volatile considered evil
Message-Id: <20070508161309.c398a913.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.0.99.0705081306000.15420@chino.kir.corp.google.com>
References: <516386418.20070501080839@gmail.com>
	<20070430235642.e576e917.akpm@linux-foundation.org>
	<20070508121404.17bd97a6.randy.dunlap@oracle.com>
	<alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com>
	<m3k5vj2iha.fsf@maximus.localdomain>
	<alpine.DEB.0.99.0705081306000.15420@chino.kir.corp.google.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 13:20:31 -0700 (PDT) David Rientjes wrote:

> On Tue, 8 May 2007, Krzysztof Halasa wrote:
> 
> > > Since 'volatile' has two different semantics depending on the context in 
> > > which it is used, this warning should be appended to include the fact that 
> > > it is legitimate to use for inline assembly.
> > 
> > I think it hasn't two semantics, it's like arguing that char has two
> > semantics.
> > 
> > Volatile does one thing - prohibits C compiler from optimizing
> > accesses to the variable. Either with (volatile *) casts and with
> > volatile var;
> > 
> 
> What the meaning of an "access" to a volatile memory-mapped I/O port or a 
> variable that can be asynchronously interrupted is implementation-defined.
> 
> You're only citing qualified versions of objects.
> 
> In an asm construct, if all your input operands are modified and specified 
> as output operands as well, volatile must be added so that the entire 
> construct is not optimized away.  Additionally, it must be added if your 
> construct modifies memory that is neither listed in inputs nor outputs to 
> the construct so that it is known to have at least one side-effect.  Then, 
> the compiler cannot delete your construct if it is reachable because it 
> may produce such side-effects.
> 
> Thus, the warning that was proposed for addition to CodingStyle should be 
> modified to explicitly state that the use of 'volatile' for asm constructs 
> is perfectly legitimate and its use as a type qualifier for objects in 
> code is inappropriate.

It's already there, isn't it?  <quote from original:>

The only acceptable uses for "volatile" are:

 - in _code_, i.e., for things like the definition of "readb()" etc, where we
   use it to force a particular access.
 - with inline asms
 - on "jiffies", for stupid legacy reasons

</quote>

or are you saying that you want to subject/header/title modified also?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
