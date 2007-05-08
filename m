Return-Path: <linux-kernel-owner+w=401wt.eu-S1032447AbXEHWAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032447AbXEHWAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032441AbXEHWAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:00:37 -0400
Received: from smtp-out.google.com ([216.239.45.13]:6768 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032436AbXEHWAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:00:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=OW1pcmVBC1bSR2Kadvdoak5/JPIkoKfys0TfeaeBmHYuwUEiTzl00/N/ORXWcTQ0g
	1J0gEECctZHOTiV9GWtYw==
Date: Tue, 8 May 2007 14:59:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [RFC/PATCH] doc: volatile considered evil
In-Reply-To: <4640ED7D.708@goop.org>
Message-ID: <alpine.DEB.0.99.0705081453350.25466@chino.kir.corp.google.com>
References: <516386418.20070501080839@gmail.com> <20070430235642.e576e917.akpm@linux-foundation.org>
 <20070508121404.17bd97a6.randy.dunlap@oracle.com>
 <alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com>
 <4640E98B.4030107@goop.org> <alpine.DEB.0.99.0705081423500.24138@chino.kir.corp.google.com>
 <4640ED7D.708@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Jeremy Fitzhardinge wrote:

> > 	In an asm construct, if all your input operands are modified and 
> > 	specified as output operands as well, volatile must be added so 
> > 	that the entire construct is not optimized away.  Additionally, 
> > 	it must be added if your construct modifies memory that is neither 
> > 	listed in inputs nor outputs to the construct so that it is known 
> > 	to have at least one side-effect.
> 
> Hm.  Is "asm volatile" necessary if you have a "memory" clobber?  Would
> probably be the safest thing, I guess.
> 

No, because the first requirement for 'volatile' in my paragraph above is 
restricted to clobbering specific hard registers and an operand cannot 
describe a hard register for a member when that register appears in the 
clobber list.  If an input operand is modified (i.e. not "accessed", 
rather "modified" inclusive of the case where the previous value is the 
same as the original value) then it must also be specified as an output 
operand.

Now if all such output operands are to specify that the input operands 
were "modified", 'volatile' is required to ensure the side-effects are 
preserved or, otherwise, gcc is free optimize the entire asm construct 
away since it appears to be unused.

> Yeah, they're completely different.  They're not even analogous, really,
> which was my point.  People confer more meaning to "asm volatile" than
> it actually has, because of the analogy with volatile variables/types. 
> They would have been better off with something like "asm static", which
> isn't much more meaningful, but at least it doesn't mislead the reader
> into thinking it has anything to do with the other volatile.
> 

You're point about reordering "asm volatile" constructs differs depending 
on -mvolatile-asm-stop or -mno-volatile-asm-stop, however.

		David
