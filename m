Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbYGHOIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbYGHOIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 10:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbYGHOIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 10:08:13 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:35858 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbYGHOIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 10:08:13 -0400
Subject: Re: [bug ?] do_get_mempolicy()
From: Lee Schermerhorn <lee.schermerhorn@hp.com>
Reply-To: lee.schermerhorn@hp.com
To: John Blackwood <john.blackwood@ccur.com>
Cc: linux-kernel@vger.kernel.org, Joe Korty <joe.korty@ccur.com>
In-Reply-To: <486D3A4A.6000502@ccur.com>
References: <486D3A4A.6000502@ccur.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 08 Jul 2008 09:23:29 -0400
Message-Id: <1215523409.22680.9.camel@murky.zko.hp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 16:44 -0400, John Blackwood wrote:
> Hi Lee,

John:  I'm just getting back from a long weekend and I'm wading through
a big e-mail back log.  I'll take a look at this when I get to the end
of my inbox.  I/m probably responsible for that line.  I recall thinking
that get_mempolicy() should return the policy that one would pass back
in to achieve the same effect.  But, I blew it.

> 
> I'm having unexpected results with get_mempolicy(2) in 2.6.26, and
> I am hoping that you can either agree with me, or maybe comment on my
> misconceptions.
> 
> When I have a task with no special task mempolicy (the default mempolicy),
> when I call get_mempolicy(2), it returns a policy value of 2 (MPOL_BIND)
> with a NULL nodemask.
> 
> I believe that this is because of the code in do_get_mempolicy() that does:
> 
>   *policy |= pol->flags;
> 
> in the else case when flags do not contain MPOL_F_NODE.

I think that need to mask off the internal flags, and shift the
remaining ones up to the correct location.  I'll send a patch, if no one
beats me to it.

> 
> I guess I don't understand why we are ORing in the pol->flags into the
> *policy value.  For example, when this is for the default_policy, the
> MPOL_F_LOCAL flag (which has a value of 2) gets stuffed into the *policy
> location, and a get_mempolicy(2) caller sees this as the MPOL_BIND
> mempolicy.
> 
> Maybe the "*policy |= pol->flags;" line should be removed ?
> 
> That is, maybe it was valid at some point, but subsequent changes
> make this line of code no longer valid ?
> 
> Sorry if I'm out-to-lunch here...

No, doesn't appear that way..

> 
> Thanks very much for you time and considerations on this issue.
> 

thanks for reporting it. 

Lee

