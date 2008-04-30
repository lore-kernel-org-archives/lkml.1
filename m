Return-Path: <linux-kernel-owner+w=401wt.eu-S934157AbYD3Wy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934157AbYD3Wy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760345AbYD3Wx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:53:59 -0400
Received: from mail.lang.hm ([64.81.33.126]:51238 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676AbYD3Wx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:53:58 -0400
Date: Wed, 30 Apr 2008 15:54:56 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: David Miller <davem@davemloft.net>, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <200805010039.02451.rjw@sisk.pl>
Message-ID: <alpine.DEB.1.10.0804301546580.7807@asgard>
References: <20080430135405.ddc42075.akpm@linux-foundation.org> <20080430221936.GA27292@elte.hu> <20080430.152227.23100100.davem@davemloft.net> <200805010039.02451.rjw@sisk.pl>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008, Rafael J. Wysocki wrote:

> On Thursday, 1 of May 2008, David Miller wrote:
>> From: Ingo Molnar <mingo@elte.hu>
>> Date: Thu, 1 May 2008 00:19:36 +0200
>>
>>> The same goes in the other direction as well - you were just hit by
>>> scheduler tree related regressions that were only triggered on your
>>> 128-way sparc64, but not on our 64way x86 and smaller boxes.
>>
>> You keep saying this over and over again, but the powerpc folks hit
>> this stuff too.
>
> Well, I think that some changes need some wider testing anyway.
>
> They may be correct from the author's point of view and even from the knowledge
> and point of view of the maintainer who takes them into his tree.  That's
> because no one knows everything and it'll always be like this.

I think this is a very important point to keep in mind

> Still, with the current process such "suspicious" changes go in as parts of
> large series of commits and need to be "rediscovered" by the affected testers
> with the help of bisection.  Moreover, many changes of this kind may go in from
> many different sources at the same time and that's really problematic.

git makes it easy to have many branches that get merged upstream, would it 
really help much if these changes were initially done as seperate branches 
and then merged in?

if so there are two ways to do this

have Ingo (and others) create a small forest of branches that get merged 
into linux-next

have Ingo (and others) create a small forest of branches that get merged 
into one 'please pull' branch that gets merged into linux-next

the second has the advantage that merge conflicts between the different 
branches will be resolved before they go upstream, and there's less work 
to be done upstream (as the upstream doesn't need to keep adding branches 
to pull)

the first may have an advantage in terms of making the different branches 
more visable.

> In fact, so many changes go in at a time during a merge window, that we often
> can't really say which of them causes the breakage observed by testers and
> bisection, that IMO should really be a last-resort tool, is used on the main
> debugging techinque.

there are always going to be cases where the problem can only be found by 
bisecting it, but I agree that there seems to be a little too much 
reliance on bisecting (but that was a heated topic a few weeks ago, let's 
not re-hash it now)

David Lang
