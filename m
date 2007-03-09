Return-Path: <linux-kernel-owner+w=401wt.eu-S1767451AbXCISMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767451AbXCISMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 13:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767450AbXCISMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 13:12:06 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43000 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbXCISMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 13:12:03 -0500
Date: Fri, 9 Mar 2007 10:11:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bill Davidsen <davidsen@tmr.com>
cc: Ed Tomlinson <edt@aei.ca>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Revell <rlrevell@joe-job.com>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu
   scheduler
In-Reply-To: <45F17514.5070509@tmr.com>
Message-ID: <Pine.LNX.4.64.0703091005540.10832@woody.linux-foundation.org>
References: <54348.192.54.193.51.1173087934.squirrel@rousalka.dyndns.org>
 <75b66ecd0703051020h1f0c1f85r15a5de082a80cec0@mail.gmail.com>
 <200703051419.25814.gene.heskett@gmail.com> <200703052123.29421.edt@aei.ca>
 <Pine.LNX.4.64.0703051849410.3998@woody.linux-foundation.org>
 <45F0DCB7.5020908@tmr.com> <Pine.LNX.4.64.0703082226530.10832@woody.linux-foundation.org>
 <45F17514.5070509@tmr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Mar 2007, Bill Davidsen wrote:
>
> But it IS okay for people to make special-case schedulers. Because it's MY
> machine,

Sure.

Go wild. It's what open-source is all about.

I'm not stopping you.

I'm just not merging code that makes the scheduler unreadable, even hard 
to understand, and slows things down. I'm also not merging code that sets 
some scheduler policy limits by having specific "pluggable scheduler 
interfaces".

Different schedulers tend to need different data structures in some *very* 
core data, like the per-cpu run-queues, in "struct task_struct", in 
"struct thread_struct" etc etc. Those are some of *the* most low-level 
structures in the kernel. And those are things that get set up to have as 
little cache footprint a possible etc.

IO schedulers have basically none of those issues. Once you need to do IO, 
you'll happibly use a few indirect pointers, it's not going to show up 
anywhere. But in the scheduler, 10 cycles here and there will be a big 
deal.

And hey, you can try to prove me wrong. Code talks. So far, nobody has 
really ever come close.

So go and code it up, and show the end result. So far, nobody who actually 
*does* CPU schedulers have really wanted to do it, because they all want 
to muck around with their own private versions of the data structures.

		Linus
