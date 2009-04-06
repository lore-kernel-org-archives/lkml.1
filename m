Return-Path: <linux-kernel-owner+w=401wt.eu-S1759407AbZDFVqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407AbZDFVqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbZDFVqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:46:35 -0400
Received: from main.gmane.org ([80.91.229.2]:40696 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbZDFVqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:46:34 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux 2.6.29
Date: Mon, 06 Apr 2009 17:46:17 -0400
Message-ID: <49DA7829.5090709@tmr.com>
References: <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090401143622.b1885643.akpm@linux-foundation.org> <20090402010044.GA16092@elte.hu> <20090403040649.GF3795@csclub.uwaterloo.ca> <alpine.LFD.2.00.0904022112260.4130@localhost.localdomain> <20090403072507.GO5178@kernel.dk> <20090403081514.GA21325@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu,
       drees76@gmail.com, jesper@krogh.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
X-Gmane-NNTP-Posting-Host: pool-70-109-119-176.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090328 Fedora/1.1.15-3.fc9 SeaMonkey/1.1.15
In-Reply-To: <20090403081514.GA21325@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> Ergo, i think pluggable designs for something as critical and as 
> central as IO scheduling has its clear downsides as it created two 
> mediocre schedulers:
> 
>  - CFQ with all the modern features but performance problems on 
>    certain workloads
> 
>  - Anticipatory with legacy features only but works (much!) better 
>    on some workloads.
> 
> ... instead of giving us just a single well-working CFQ scheduler.
> 
> This, IMHO, in its current form, seems to trump the upsides of IO 
> schedulers.
> 
> So i do think that late during development (i.e. now), _years_ down 
> the line, we should make it gradually harder for people to use AS.
> 
I rarely disagree with you, and more rarely feel like arguing a point in public, 
but you are basing your whole opinion on the premise that it is possible to have 
one io scheduler which handles all cases. And that seems obviously wrong, 
because you address different types of activity with tuning or adapting, in some 
cases you need a whole different approach, and you need to lock in that approach 
even if some metric says something else would be better for the "better" seen by 
the developer rather than the user.


> What do you think?
> 
I think that by trying to create "one size fits all" you will hit a significant 
number of cases where it really doesn't fit well and you have so many tuning 
features both automatic and manual that you wind up with code which is big, 
inefficient, confusing to tune, hard to maintain, and generally not optimal for 
any one thing.

What we have is easy to test and the behavior is different enough in most cases 
that you can tell which is best, or at least that a change didn't help. I have 
watched long threads and chats about tuning VM (dirty_*, swappiness, etc) to be 
aware that in most cases either faster disk or more memory is the answer, not 
tuning to be "less unsatisfactory." Several distinct io schedulers is good, one 
complex bland one would not be.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

