Return-Path: <linux-kernel-owner+w=401wt.eu-S934432AbZDIPDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934432AbZDIPDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbZDIPDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:03:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929AbZDIPDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:03:39 -0400
Date: Thu, 9 Apr 2009 08:00:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Andy Whitcroft <apw@canonical.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: checkpatch fixes
In-Reply-To: <20090409030440.GA9169@elte.hu>
Message-ID: <alpine.LFD.2.00.0904090750370.4583@localhost.localdomain>
References: <20090408062106.39EE0FC3E5@magilla.sf.frob.com> <alpine.LFD.2.00.0904081007530.4583@localhost.localdomain> <20090409030440.GA9169@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Apr 2009, Ingo Molnar wrote:
> 
> We should perhaps introduce an too-deep-indentation warning: any 
> function with "[;{}]$" lines of 4 tabs in a row is already suspect 
> IMHO. At 5 it's definitely crazy and ugly.
> 
> This would be a very efficient function-length reductor: it cannot 
> be worked around via line wraps.

People would start using spaces to try to work around it instead, which is 
a worse cure than the problem.

Also, the thing is, a long _individual_ line is not a problem even if you 
have a 80-column terminal. Sane editors will have a marker for "this line 
continues", and even if you have an insane editors that doesn't do that, 
it's pretty obvious - and if you really care about the end of that 
_particular_ line (most of the time you don't), you can just move to that 
line.

So if you have a couple of long lines occasionally, that's not a huge 
problem. In fact, that's why I hate splitting lines so much: the "false 
indentation" that a line split causes is generally much more confusing 
visually (not so much in something like a function header, but often very 
much so inside the code itself).

> It would also be wonderful to warn about bad 80 columns 'fixes' - 
> i've seen way too many perfectly fine cleanups damaged by ugly 
> line-wrapping solutions.

The thing is, it's very hard to warn about those. You need more 
understanding than your average perl-script can ever get.

> We could also up the limit to 90 or 100 columns. My terminals are at 
> 90 columns and that's still pretty ergonomic.

I tend to start out with a 80x24 and just resize it, and end up at some 
random value. It's usually in the 90x40 range for me. But I do want the 
code to be perfectly _readable_ in a 80x24 window, and quite frankly, if 
you look at something like kernel/ptrace.c, it really generally is.

So sure, that "int ptrace_readdata()" line is longer than that, and won't 
show completely. But you don't miss any huge glaring code issues even in 
the truncated mode. In fact, if I try to use 80x24, my biggest issue will 
inevitably be not the 80 part, but the 24 part. 

IOW, I think there is much more reason to hate long _functions_ than there 
is reason to hate long lines. Both cause you to scroll. The long function 
where there is action over more than 24 lines happens a lot more.

					Linus
