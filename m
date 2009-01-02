Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbZABRrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbZABRrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 12:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757118AbZABRrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 12:47:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43986 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbZABRrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:47:04 -0500
Date: Fri, 2 Jan 2009 18:46:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       rdreier@cisco.com, ian.campbell@citrix.com,
       jeremy.fitzhardinge@citrix.com, deller@gmx.de, rusty@rustcorp.com.au,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@mcmartin.ca, randolph@tausq.org, sam@ravnborg.org,
       dave@hiauly1.hia.nrc.ca
Subject: Re: [PATCH] kbuild: Disallow GCC 4.1.0 / 4.1.1
Message-ID: <20090102174641.GA27287@elte.hu>
References: <alpine.LFD.2.00.0812310942110.5086@localhost.localdomain> <20081231105425.9ccac21d.akpm@linux-foundation.org> <alpine.LFD.2.00.0812311318420.5086@localhost.localdomain> <20081231.141408.60544902.davem@davemloft.net> <20090102115547.GB3027@elte.hu> <alpine.LFD.2.00.0901020844070.5086@localhost.localdomain> <alpine.LFD.2.00.0901020933370.5086@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901020933370.5086@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 2 Jan 2009, Linus Torvalds wrote:
> > 
> > I think this is wrong.
> > 
> > Just move the check into <linux/compiler-gcc4.h>
> 
> In fact, looking at that whole mess, I redid it all. It was disgusting 
> how conditionals in gcc4.h needed to double-check that __GNUC__ really 
> was 4 (rather than something bigger), which largely negated the whole 
> nice clean compiler version separation.
> 
> I pushed out my preferred version, which fixes up the whole thing. The 
> gcc4 header file now only gets included for __GNUC__ == 4, and when we 
> ever see a __GNUC__ of 5, it will automatically DTRT and try to include 
> <linux/compiler-gcc5.h> instead of #4.
> 
> And then the check in gcc4.h for 4.1.0 and 4.1.1 is much simplified.  
> The two patches I pushed out add functionality, but don't actually add 
> any new lines (the first simplification patch removes more lines than it 
> adds, and the second one that adds the __weak bug test adds as mahy 
> lines as the cleanup removed).
> 
> And it all looks more logical too, imho.

yeah, agreed, much cleaner.

The gcc3 check for gcc 3.0 and 3.1 can be pushed into gcc3 as well - not 
sure whether you fixed that. (i fixed it in the patch i just sent - but i 
didnt notice the gcc5 mess in gcc4.h that you fixed)

	Ingo
