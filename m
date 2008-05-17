Return-Path: <linux-kernel-owner+w=401wt.eu-S1760730AbYEQBjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760730AbYEQBjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 21:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbYEQBjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 21:39:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbYEQBjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 21:39:00 -0400
Date: Fri, 16 May 2008 18:38:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@elte.hu,
       hpa@zytor.com
Subject: Re: [GIT pull] x86 fixes for 2.6.26
In-Reply-To: <20080516.172835.260358594.davem@davemloft.net>
Message-ID: <alpine.LFD.1.10.0805161831380.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org> <alpine.LFD.1.10.0805170116490.3255@apollo.tec.linutronix.de> <alpine.LFD.1.10.0805161658450.3020@woody.linux-foundation.org> <20080516.172835.260358594.davem@davemloft.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 May 2008, David Miller wrote:
> 
> I think I merged from Linus's tree only 3 or 4 times maximum since I
> created that tree way back when the 2.6.26 merge window opened up.

Basically, a rule-of-thumb would be "once a week is reasonable", but on 
the other hand, if you have actual conflicts, more often is fine, and if 
you know your area isn't impacted (eg most filesystems), you'd probably 
only try to synchronize at release points or something like that.

The reason to avoid doing overly many merges is

 - merging with me at random points is usually not a good idea anyway, 
   unless you have a really strong reason for it. Yes, my tree is fairly 
   stable, but still..

   (This also implies that merging with my *tags* is usually a better idea 
   than merging with some random point in time, and is one reason it makes 
   sense to try to merge with major releases rather than anything else)

 - the history just looks cleaner and is easier to follow when there 
   aren't criss-crossing merges.

   This may not matter most of the time, but it *does* make a difference 
   when doing "git bisect". I don't know about others, but I often do "git 
   bisect visualize" then I have some totally unknown bug and I'm trying 
   to guess what's going on - it's a great way to give people a heads up 
   saying "ok, I'm in the middle of a bisection run, and it _looks_ like 
   it may be due to you".

So trying to have fairly clean history is worth it (it also makes it 
slightly faster to bisect when you don't have lots of criss-cross merges, 
but that's a fairly small factor).

> If users, or even you, want to get a bug fix from Linus's tree or check
> if there will be merge conflicts, just create a test branch and play
> with such things there.

Yes. I think you guys already have a test branch for the "join it all 
together" case, don't you?

		Linus
