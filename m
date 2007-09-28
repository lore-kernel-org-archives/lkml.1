Return-Path: <linux-kernel-owner+w=401wt.eu-S1761313AbXI1Jw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761313AbXI1Jw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbXI1JwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:52:21 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2045 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbXI1JwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:52:20 -0400
Date: Fri, 28 Sep 2007 10:52:07 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
Message-ID: <20070928095207.GA18163@shadowen.org>
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky> <20070928084003.GA18882@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928084003.GA18882@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 10:40:03AM +0200, Ingo Molnar wrote:
> 
> * Andy Whitcroft <apw@shadowen.org> wrote:
> 
> > This version brings a number of new checks, and a number of bug fixes.  
> 
> your checkpatch patch itself produces 22 warnings ...
> 
> i ran it over kernel/sched.c and there are many bogus warnings that i 
> reported to you earlier:
> 
>   WARNING: multiple assignments should be avoided
>   #2319:
>   +       max_load = this_load = total_load = total_pwr = 0;
> 
> and new bogus ones:
> 
>   ERROR: need consistent spacing around '*' (ctx:WxV)
>   #5287:
>   +               mode_t mode, proc_handler *proc_handler)
> 
>   ERROR: need consistent spacing around '*' (ctx:WxV)
>   #5328:
>   +static ctl_table *sd_alloc_ctl_cpu_table(int cpu)
> 
>   ERROR: need space before that '*' (ctx:VxV)
>   #209:
>   +# define INIT_TASK_GRP_LOAD    2*NICE_0_LOAD
> 
> why did you ignore my feedback? Ever since v8 the quality of 
> checkpatch.pl has been getting worse and worse as there are way too many 
> false positives. I'm still stuck on v8 for my own use, v9 and v10 is 
> unusable.

I think if you read your incoming email you will see nothing of the sort.
I have discussed this with you and in public.  The multiple assignment
check you dissagree with and we have softened it in direct response to that
dislike.  However, the main proponent of this existing wanted that check.
Therefore it has stayed.  The other false positives you report are real.
Some are fixed in my development version, others are not.  They come
from the fact that I was asked for better checks on '*' and the like in
its binary mode.  To get that I had to actually start telling unary and
binary uses of the same operator appart.  That is hard in the face of
typedef'd types.  I am working to make it better.

However, the key here is that it will never be 100%, not without
becoming a try C parser.  The output is a _guide_ if you don't like its
output ignore the reports you dislike.  I for one send out patches with
style violations where I deem that the code is better that way.

-apw
