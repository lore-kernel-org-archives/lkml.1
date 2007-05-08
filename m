Return-Path: <linux-kernel-owner+w=401wt.eu-S969359AbXEHXFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969359AbXEHXFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968588AbXEHXFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:05:36 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39747 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967871AbXEHXFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:05:35 -0400
Date: Tue, 8 May 2007 16:09:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Rientjes <rientjes@google.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [RFC/PATCH] doc: volatile considered evil
Message-Id: <20070508160908.ed1824b4.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.0.99.0705081423500.24138@chino.kir.corp.google.com>
References: <516386418.20070501080839@gmail.com>
	<20070430235642.e576e917.akpm@linux-foundation.org>
	<20070508121404.17bd97a6.randy.dunlap@oracle.com>
	<alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com>
	<4640E98B.4030107@goop.org>
	<alpine.DEB.0.99.0705081423500.24138@chino.kir.corp.google.com>
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

On Tue, 8 May 2007 14:27:33 -0700 (PDT) David Rientjes wrote:

> On Tue, 8 May 2007, Jeremy Fitzhardinge wrote:
> 
> > It's probably worth noting that "asm volatile (...)" doesn't mean what
> > many people think it means: specifically, it *does not* prevent the asm
> > from being reordered with respect to the surrounding code.  It may not
> > even prevent it from being reordered with respect to other asm
> > volatiles.  *All* it means is that the asm code will be emitted even if
> > the compiler doesn't think its results will be used.  Note that an
> > "asm()" with no outputs is implicitly "asm volatile()" - on the grounds
> > that it would be otherwise useless as far as gcc can tell.
> > 
> > If you need to guarantee ordering of asm statements, you must do it
> > explicitly, with either a "memory" clobber, or some finer-grain
> > serialization variable (like the _proxy_pda stuff).  It would be useful
> > if you could tell gcc "I'm passing this variable to the asm for
> > serialization purposes, but there's no need to generate any explicit
> > references to it", but as far as I know there's no support for that.
> > 

Well, the document is really about "volatile" in C, not in gcc asm
extensions.
But if you want to add paragraphs(s) to the file, that's OK too.

> Ok, so let's take your second paragraph and my email of an hour ago:
> 
> 	In an asm construct, if all your input operands are modified and 
> 	specified as output operands as well, volatile must be added so 
> 	that the entire construct is not optimized away.  Additionally, 
> 	it must be added if your construct modifies memory that is neither 
> 	listed in inputs nor outputs to the construct so that it is known 
> 	to have at least one side-effect.  Then, the compiler cannot 
> 	delete your construct if it is reachable because it may produce 
> 	such side-effects.
> 
> and add it to any proposed change to CodingStyle that suggests against the 
> 'volatile' keyword since there exists a distinct difference in behavior 
> between using the keyword as a type qualifier for an object and as a 
> qualifier for an asm construct.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
