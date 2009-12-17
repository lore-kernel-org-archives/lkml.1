Return-Path: <linux-kernel-owner+w=401wt.eu-S936784AbZLQWn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936784AbZLQWn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 17:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936765AbZLQWn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 17:43:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936764AbZLQWn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 17:43:27 -0500
Date: Thu, 17 Dec 2009 14:43:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alain Knaff <alain@knaff.lu>
cc: markh@compro.net, fdutils@fdutils.linux.lu, linux-kernel@vger.kernel.org
Subject: Re: DMA cache consistency bug introduced in 2.6.28 (Was: Re: [Fdutils]
 Cannot format floppies under kernel 2.6.*?)
In-Reply-To: <4B2AAC87.5000703@knaff.lu>
Message-ID: <alpine.LFD.2.00.0912171440420.15740@localhost.localdomain>
References: <4AFB3962.2020106@ntlworld.com> <4B275B18.80704@knaff.lu> <4B275D37.4090807@cfl.rr.com> <4B2761E9.2030301@knaff.lu> <4B276513.6030509@cfl.rr.com> <4B276753.80807@knaff.lu> <4B27983F.5090600@compro.net> <4B27EF18.7050101@knaff.lu>
 <4B28FDEB.3030800@compro.net> <4B290029.90602@knaff.lu> <4B2901DB.8040403@compro.net> <4B29052B.9070406@knaff.lu> <4B292D84.5040306@compro.net> <4B29624F.2080109@knaff.lu> <4B2A3805.8040707@compro.net> <4B2A3E3E.8060405@knaff.lu> <4B2A4975.8020809@compro.net>
 <4B2A49F4.6070402@compro.net> <4B2A4B86.8060307@knaff.lu> <4B2A4C78.10107@compro.net> <4B2A4CF7.6040000@knaff.lu> <4B2A4EC9.2030902@compro.net> <4B2A4FA5.5000701@knaff.lu> <4B2A5192.6090602@compro.net> <4B2A530D.3080606@knaff! .lu> <4B2A6394.3080705@knaff.lu>
 <alpine.LFD.2.00.0912170916420.15740@localhost.locald! omain> <4B2A98BB.5080406@knaff.lu> <alpine.LFD.2.00.0912171256560.15740@localhost.localdomain> <4B2AAC87.5000703@knaff.lu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Dec 2009, Alain Knaff wrote:
> [...]
> > You'd need a git tree that contains both the working and non-working 
> > versions, and then literally just do
> > 
> > 	git bisect start
> > 	git bisect good <known good version number here>
> > 	git bisect bad <known bad version here>
> > 
> > and it will give you a commit to try. Compile, test, see if it's good or 
> > bad, and do
> > 
> > 	git bisect [good|bad]
> > 
> > depending on the result. Rinse and repeat (depending on how tight the 
> > initial good/bad commits were, it will need 10-15 kernel tests).
> 
> ... and how do I check out the most recent good / oldest bad kernel for
> compilation?

'git bisect' does all that for you. You don't need to check out the 
kernels you mark good or bad - git will just calculate the commit graphs, 
and pick a commit that is in the "middle" between them, and check out that 
commit.

> > So after a successful bisect, it is usually a good idea to try to go back 
> > to the original known-bad kernel, and then revert the commit that was 
> > indicated as the bad one (assuming the revert works - it could be that the 
> > bad one ends up being fundamental to other commits after it), and test 
> > that yes, that really fixes the bug.
> 
> What command lines would I use for that revert?

	git revert <sha1-that-git-bisect-reported>

but even if that revert isn't successful, just the bisection result will 
be very interesting (assuming it all looks sane, of course - as mentioned, 
sometimes bisect results get screwed up because the bug isn't entirely 
reproducible due to timing etc).

			Linus
