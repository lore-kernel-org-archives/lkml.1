Return-Path: <linux-kernel-owner+w=401wt.eu-S1032090AbXEHUVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032090AbXEHUVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032080AbXEHUVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:21:30 -0400
Received: from smtp-out.google.com ([216.239.45.13]:45881 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032075AbXEHUV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:21:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=li7d4g4T0WSDu6lOlQVDn3jQckxuaWzBWKGeqGE2h3dX9oO3FhrncXjm66BW91i5n
	0We0fqnCETC3A3vZam6RQ==
Date: Tue, 8 May 2007 13:20:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] doc: volatile considered evil
In-Reply-To: <m3k5vj2iha.fsf@maximus.localdomain>
Message-ID: <alpine.DEB.0.99.0705081306000.15420@chino.kir.corp.google.com>
References: <516386418.20070501080839@gmail.com> <20070430235642.e576e917.akpm@linux-foundation.org>
 <20070508121404.17bd97a6.randy.dunlap@oracle.com>
 <alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com>
 <m3k5vj2iha.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Krzysztof Halasa wrote:

> > Since 'volatile' has two different semantics depending on the context in 
> > which it is used, this warning should be appended to include the fact that 
> > it is legitimate to use for inline assembly.
> 
> I think it hasn't two semantics, it's like arguing that char has two
> semantics.
> 
> Volatile does one thing - prohibits C compiler from optimizing
> accesses to the variable. Either with (volatile *) casts and with
> volatile var;
> 

What the meaning of an "access" to a volatile memory-mapped I/O port or a 
variable that can be asynchronously interrupted is implementation-defined.

You're only citing qualified versions of objects.

In an asm construct, if all your input operands are modified and specified 
as output operands as well, volatile must be added so that the entire 
construct is not optimized away.  Additionally, it must be added if your 
construct modifies memory that is neither listed in inputs nor outputs to 
the construct so that it is known to have at least one side-effect.  Then, 
the compiler cannot delete your construct if it is reachable because it 
may produce such side-effects.

Thus, the warning that was proposed for addition to CodingStyle should be 
modified to explicitly state that the use of 'volatile' for asm constructs 
is perfectly legitimate and its use as a type qualifier for objects in 
code is inappropriate.

		David
