Return-Path: <linux-kernel-owner+w=401wt.eu-S1032409AbXEHVhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032409AbXEHVhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032011AbXEHVhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:37:07 -0400
Received: from gw.goop.org ([64.81.55.164]:46568 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032399AbXEHVhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:37:05 -0400
Message-ID: <4640ED7D.708@goop.org>
Date: Tue, 08 May 2007 14:37:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [RFC/PATCH] doc: volatile considered evil
References: <516386418.20070501080839@gmail.com> <20070430235642.e576e917.akpm@linux-foundation.org> <20070508121404.17bd97a6.randy.dunlap@oracle.com> <alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com> <4640E98B.4030107@goop.org> <alpine.DEB.0.99.0705081423500.24138@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.0.99.0705081423500.24138@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> Ok, so let's take your second paragraph and my email of an hour ago:
>
> 	In an asm construct, if all your input operands are modified and 
> 	specified as output operands as well, volatile must be added so 
> 	that the entire construct is not optimized away.  Additionally, 
> 	it must be added if your construct modifies memory that is neither 
> 	listed in inputs nor outputs to the construct so that it is known 
> 	to have at least one side-effect.

Hm.  Is "asm volatile" necessary if you have a "memory" clobber?  Would
probably be the safest thing, I guess.

> and add it to any proposed change to CodingStyle that suggests against the 
> 'volatile' keyword since there exists a distinct difference in behavior 
> between using the keyword as a type qualifier for an object and as a 
> qualifier for an asm construct.
>   

Yeah, they're completely different.  They're not even analogous, really,
which was my point.  People confer more meaning to "asm volatile" than
it actually has, because of the analogy with volatile variables/types. 
They would have been better off with something like "asm static", which
isn't much more meaningful, but at least it doesn't mislead the reader
into thinking it has anything to do with the other volatile.

But yes, seems like a worthwhile thing to point out.  Or just point to
the gcc manual, which is pretty clear about all this stuff.

    J
