Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbXKOPLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbXKOPLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 10:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbXKOPLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 10:11:04 -0500
Received: from iabervon.org ([66.92.72.58]:37375 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630AbXKOPLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 10:11:03 -0500
Date: Thu, 15 Nov 2007 10:10:59 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Michael Gerdau <mgerdau@tiscali.de>
cc: Philippe Elie <phil.el@wanadoo.fr>,
       Russell Leighton <russ@elegant-software.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: OT: Does Linux have any "Perfect Code"
In-Reply-To: <200711151416.54570.mgerdau@tiscali.de>
Message-ID: <Pine.LNX.4.64.0711150940560.12193@iabervon.org>
References: <c9d133bdb3481fbc01a572d948049f5e@elegant-software.com>
 <20071115082746.GA2885@zaniah> <200711151416.54570.mgerdau@tiscali.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, Michael Gerdau wrote:

> > This code is far to be perfect, some part is outdated, bcopy() use instead
> > of memcpy() for example. More annoying are the comment, the file is 3306
> > lines while there is only 1640 line of code, nothing bad per se but looking
> > some comments:
> > 
> >  		/*
> >  		 * Before we begin this operation, disable kernel preemption.
> >  		 */
> >  		kpreempt_disable();
> 
> <disclaimer>
> I'm not a kernel developer.
> </disclaimer>
> 
> That having said:
> I really do like such obvious (as in: for those knowing the stuff anyway)
> comments when looking at code and probably concepts I'm not familiar with.
>
> ...
> 
> I mean, isn't the whole purpose of comments to help those not familiar
> with the code to understand it's purpose and possibly the intention of
> the author (just in case the author had coded a bug) ?

That's the problem with really obvious comments. In the example above, 
that function had better disable kernel preemption with a name like that, 
and, assuming it's before the code begins the operation in sequence, we 
know when we're doing it. But the comment fails to explain why we need to 
disable kernel preemption before beginning the operation, just that we are 
doing so. Having the comment merely distracts the reader from the fact 
that the purpose of the code and the intention of the author are 
completely undocumented. And there's a realy chance that this comment or 
ones like it cause this statement and the place in the code where things 
would go wrong if preemption weren't disabled to not fit on the reader's 
screen together, so it is not only unclear what the author's intention 
was, but it is harder to figure out from looking at the code than it would 
be without comments, because fewer clues are actually visible at the same 
time, since each of them takes up extra screen space.

The code itself should be written to tell the reader everything there is 
to know about what it does, and the comments in code should only tell the 
reader why it does that.

	-Daniel
*This .sig left intentionally blank*
