Return-Path: <linux-kernel-owner+w=401wt.eu-S1032380AbXEHV3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032380AbXEHV3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032365AbXEHV3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:29:15 -0400
Received: from smtp-out.google.com ([216.239.45.13]:61652 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032369AbXEHV3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:29:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=RcAATuMRChIjaivZ9rFJATdsqYkNzONMvszxkJ/zQcdam/rIQX33qLUe2lXxIfh62
	v/SObABdTJHsAnXbJcjqw==
Date: Tue, 8 May 2007 14:27:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [RFC/PATCH] doc: volatile considered evil
In-Reply-To: <4640E98B.4030107@goop.org>
Message-ID: <alpine.DEB.0.99.0705081423500.24138@chino.kir.corp.google.com>
References: <516386418.20070501080839@gmail.com> <20070430235642.e576e917.akpm@linux-foundation.org>
 <20070508121404.17bd97a6.randy.dunlap@oracle.com>
 <alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com>
 <4640E98B.4030107@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Jeremy Fitzhardinge wrote:

> It's probably worth noting that "asm volatile (...)" doesn't mean what
> many people think it means: specifically, it *does not* prevent the asm
> from being reordered with respect to the surrounding code.  It may not
> even prevent it from being reordered with respect to other asm
> volatiles.  *All* it means is that the asm code will be emitted even if
> the compiler doesn't think its results will be used.  Note that an
> "asm()" with no outputs is implicitly "asm volatile()" - on the grounds
> that it would be otherwise useless as far as gcc can tell.
> 
> If you need to guarantee ordering of asm statements, you must do it
> explicitly, with either a "memory" clobber, or some finer-grain
> serialization variable (like the _proxy_pda stuff).  It would be useful
> if you could tell gcc "I'm passing this variable to the asm for
> serialization purposes, but there's no need to generate any explicit
> references to it", but as far as I know there's no support for that.
> 

Ok, so let's take your second paragraph and my email of an hour ago:

	In an asm construct, if all your input operands are modified and 
	specified as output operands as well, volatile must be added so 
	that the entire construct is not optimized away.  Additionally, 
	it must be added if your construct modifies memory that is neither 
	listed in inputs nor outputs to the construct so that it is known 
	to have at least one side-effect.  Then, the compiler cannot 
	delete your construct if it is reachable because it may produce 
	such side-effects.

and add it to any proposed change to CodingStyle that suggests against the 
'volatile' keyword since there exists a distinct difference in behavior 
between using the keyword as a type qualifier for an object and as a 
qualifier for an asm construct.

		David
