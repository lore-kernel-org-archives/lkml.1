Return-Path: <linux-kernel-owner+w=401wt.eu-S1763818AbYBNU7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763818AbYBNU7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932532AbYBNU6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:58:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59347 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369AbYBNU6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:58:38 -0500
Date: Thu, 14 Feb 2008 22:34:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH] Fix direct mapping alias regressin in ioremap v2
Message-ID: <20080214213417.GA19473@one.firstfloor.org>
References: <20080214165645.GA26748@basil.nowhere.org> <20080214174237.GA24383@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214174237.GA24383@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 06:42:37PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> >     Fix bug noticed by Ingo of __va() wrapping on 32bit
> 
> what you should realize is that had we applied your previous patch in a 
> rush, it would have introduced a far more serious regression than the 
> type of problem you are trying to solve. That's one of the reasons why 
> we disagree with your sense of urgency.

Sense of urgency in this case just means for 2.6.25 which
is still a few weeks away.

Sorry for not being a perfect being. Yes I did test the patch, but
no my testing did not catch the problem unfortunately. But I'm grateful
that your review caught the problem.

> 
> We've got the clean fixes queued up and it's all under testing. (going 
> fine so far)


Ok but will you push them to .25?

> 
> Also, you only appear to have resent your fix with the obvious bug 
> fixed, but it's still unclean and you do not seem to have replied to my 

First I disagree on you describing my change as unclean. There is nothing
particularly unclean about it. It's basically back to the same
code as it was in .24 for this case.

I think fixing this regression is important for 2.6.25
and I didn't think intrusive changes to pageattr.c are a good idea anymore 
for .25 at this stage so I did a simple fix.

I chose to fix this in the simplest way I could think of by
more or less going back to the old .24 code just adapted 
for the new interfaces.

Now if you decide you want to push the big changes in #mm that
make cpa work generally for ioremaps to .25 that would probably[1] fix the 
regression too and I wouldn't complain too loudly about that. 

But at least I personally think a as simple as possible fix is better at 
this stage.

[1] I reserve judgement at this stage because I have not reviewed the latest
code there in detail yet.

> > > Please have a look at how we solved the "secondary alias" 64-bit 
> > > problem in x86.git#mm and please resend against x86.git#mm if you 
> > > still think something is missing. Thanks,

I can send it against whatever tree contains the fixes going before
2.6.25 to Linus. Is that #mm now?  I thought it was git-x86#master
so far that I is why I sent it against mainline which is virtually
identical to git-x86#master in this area.

-Andi

