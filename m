Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0CEGvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 01:51:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43131 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899Ab0CEGvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 01:51:45 -0500
Date: Fri, 5 Mar 2010 07:49:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ben Skeggs <skeggsb@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100305064955.GA6453@elte.hu>
References: <20100304103655.0b14343f@jbarnes-piketon>
 <20100304103929.6eb81d45@jbarnes-piketon>
 <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
 <20100304105624.70fe845e@jbarnes-piketon>
 <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>
 <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
 <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>
 <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>
 <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>
 <1267748927.3496.6.camel@nisroch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267748927.3496.6.camel@nisroch>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ben Skeggs <skeggsb@gmail.com> wrote:

> > But here's the thing: if you expect people to do development, they _need_ 
> > to be able to mix things. A kernel developer needs to be able to update 
> > their kernel. And a kernel _tester_ needs to be able to test that kernel.
>
> Here's the thing.  *You* pushed for nouveau to go into staging before any of 
> the developers were ready for it.  Two of the big reasons (from my POV) for 
> not requesting inclusion were the context programs (which have since been 
> dealt with) and that yes, we have no intention of keeping crusty APIs around 
> when they aren't what we require.
> 
> The idea of staging was to allow for exactly the second problem, so why are 
> you surprised?  The fact Fedora ships nouveau is irrelevant, we also expect 
> that for the most part people will be using our packages, which deal with 
> the ABI issues.

Here is my experience with the development of various ABIs - and i've been on 
both sides of the fence, i've done 'flag day' ABI changes during development 
myself, and i've done gradual ABI development as well.

One experience i can tell you with 100% certainty: no matter whether a project 
is small or large, simple or complex, whether the old ABI is the ugliest wart 
on this planet or just hit by an unfortunate limitation that needs to be 
eliminated.

The conclusion is crystal clear, breaking an ABI via a "flag day" 
cleanup/feature/etc is:

 - wrong

 - harmful

 - limits the developer base

 - limits the tester base

 - wastes time and effort. (fewer developers/testers means that while _this_ 
   feature was easier to add, all your _future_ features will be a bit harder 
   to do. It compounds up.)

 - so it hurts even the very developer who is most convinced that this was the 
   right thing to do

It's a bad technical decision throughout. It's masochistic and often suicidal 
to just about any project in essence. I've seen projects that did it once and 
died just due to that single act of stupidity. I've seen projects that have 
done it a few times and took the usage hit, limped along with the wounds and 
never grew to the size they could have achieved. I've seen projects that did 
it once, took the hit, learned from it and never did it again.

How many times does DRM want to take that bullet head on?

I have _never_ seen a situation where in hindsight breaking the ABI of a 
widely deployed project could be considered 'good', for just about any sane 
definition of 'good'.

It's really that simple IMO. There's very few unconditional rules in OSS, but 
this is one of them.

	Ingo
