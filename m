Return-Path: <linux-kernel-owner+w=401wt.eu-S2993002AbXCIGcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993002AbXCIGcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 01:32:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993004AbXCIGcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 01:32:04 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55613 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993002AbXCIGcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 01:32:03 -0500
Date: Thu, 8 Mar 2007 22:31:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bill Davidsen <davidsen@tmr.com>
cc: Ed Tomlinson <edt@aei.ca>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Revell <rlrevell@joe-job.com>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu
   scheduler
In-Reply-To: <45F0DCB7.5020908@tmr.com>
Message-ID: <Pine.LNX.4.64.0703082226530.10832@woody.linux-foundation.org>
References: <54348.192.54.193.51.1173087934.squirrel@rousalka.dyndns.org>
 <75b66ecd0703051020h1f0c1f85r15a5de082a80cec0@mail.gmail.com>
 <200703051419.25814.gene.heskett@gmail.com> <200703052123.29421.edt@aei.ca>
 <Pine.LNX.4.64.0703051849410.3998@woody.linux-foundation.org>
 <45F0DCB7.5020908@tmr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Mar 2007, Bill Davidsen wrote:
>
> Please, could you now rethink plugable scheduler as well? Even if one had to
> be chosen at boot time and couldn't be change thereafter, it would still allow
> a few new thoughts to be included.

No. Really.

I absolutely *detest* pluggable schedulers. They have a huge downside: 
they allow people to think that it's ok to make special-case schedulers. 
And I simply very fundamentally disagree.

If you want to play with a scheduler of your own, go wild. It's easy 
(well, you'll find out that getting good results isn't, but that's a 
different thing). But actual pluggable schedulers just cause people to 
think that "oh, the scheduler performs badly under circumstance X, so 
let's tell people to use special scheduler Y for that case".

And CPU scheduling really isn't that complicated. It's *way* simpler than 
IO scheduling. There simply is *no*excuse* for not trying to do it well 
enough for all cases, or for having special-case stuff.

But even IO scheduling actually ends up being largely the same. Yes, we 
have pluggable schedulers, and we even allow switching them, but in the 
end, we don't want people to actually do it. It's much better to have a 
scheduler that is "good enough" than it is to have five that are "perfect" 
for five particular cases.

		Linus
