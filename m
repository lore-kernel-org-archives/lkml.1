Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbZFERrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbZFERrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 13:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZFERrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 13:47:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:41033 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbZFERrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 13:47:32 -0400
Message-ID: <4A295A08.4070802@kernel.org>
Date: Fri, 05 Jun 2009 10:46:48 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpumask: alloc blank cpumask left over
References: <4A2835D8.6040903@kernel.org> <200906051428.08299.rusty@rustcorp.com.au> <4A28B3A9.3010505@kernel.org> <200906052311.57762.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906051026030.6847@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906051026030.6847@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 5 Jun 2009, Rusty Russell wrote:
>> OK, here's what I've got in my tree.  Ingo, I think this should go in the
>> current -rc to avoid nasty bugs.
> 
> Why is the fix not to simply clear it in alloc?
> 
>> BTW, the original alloc_cpumask_var did zero; that was dropped after arguments
>> over efficiency and fitting with other interfaces, but I clearly had the old
>> semantics in my head for a while.
> 
> How could this ever be a efficiency issue? If you allocate cpumasks so 
> often that it's an efficiency problem, it would seem that you have bigger 
> issues than the memset. You'll have to initialize them some other way 
> anyway, so it's not like you can ever really avoid the dirty cachelines.
> 
> IOW, why isn't the fix just to clean up the horrible mess that is 
> alloc_cpumask_var_node() once and for all. Why not something like this? 
> The end result looks a lot simpler.
> 
> Or you could just add in that __GFP_ZERO there, and remove the memset. I 
> don't care. But the current code just looks messy and crazy, and that 
> FIXME is bogus. The end of the allocation needs to be cleared regardless.

some alloc_cpumask_var or alloc_cpumask_var_node calling are followed by 
cpumask_copy etc to assign the allocated cpuamsk_var_t.

about 66% calling are falling to that case.

YH
