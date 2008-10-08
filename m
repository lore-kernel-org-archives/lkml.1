Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbYJHQzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbYJHQzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 12:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYJHQy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 12:54:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54878 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbYJHQy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 12:54:57 -0400
Message-ID: <48ECE5A4.1040003@redhat.com>
Date: Wed, 08 Oct 2008 12:53:56 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, hugh@veritas.com, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
References: <20080804130317.994042639@chello.nl> <20080804131012.246115111@chello.nl> <48974512.7000206@goop.org> <1217876046.3589.61.camel@twins> <489757EC.3000309@goop.org> <alpine.LFD.1.10.0808041230070.3340@nehalem.linux-foundation.org> <20081008152708.GA11207@goodmis.org> <alpine.LFD.2.00.0810080836410.3208@nehalem.linux-foundation.org> <48ECD9C8.4000700@redhat.com> <alpine.LFD.2.00.0810080906520.3208@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810080906520.3208@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>
>   
> I know for a fact that some people thought unlocking in non-nested order 
> was a bug. And I believe that belief is a dangerous one.
>   

Ah, OK. You are fighting against nesting nazis, fair enough.

I have written a bit of code where nesting was not possible (similar to
your example, but I call those traversal locking not nesting). I just 
find that
the locks should be nested when the nesting is natural. Breaking the nesting
on natural nesting locks is a bug, IMHO.  But as you know, there are several
programmers out there that can not determine the difference between natural
nesting locks and non nesting locks.

By adding such a rule, those that can not tell the difference will be 
making a
lot of needless noise, hence, it is best not to make any such rule.

Lesson learned.  I'll now go back to debugging my code.

-- Steve

