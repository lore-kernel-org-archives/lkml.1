Return-Path: <linux-kernel-owner+w=401wt.eu-S1761559AbXKAPbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559AbXKAPbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbXKAPbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:31:05 -0400
Received: from sacred.ru ([62.205.161.221]:56311 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756841AbXKAPbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:31:04 -0400
Message-ID: <4729F118.3080506@openvz.org>
Date: Thu, 01 Nov 2007 18:30:32 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch] PID namespace design bug, workaround
References: <20071101144307.GA29566@elte.hu> <4729E7E4.8070208@openvz.org> <1193928977.27652.289.camel@twins> <4729EB88.6080408@openvz.org> <20071101151753.GA6181@elte.hu>
In-Reply-To: <20071101151753.GA6181@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 01 Nov 2007 18:30:30 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Pavel Emelyanov <xemul@openvz.org> wrote:
> 
>> The "fix" I mention is just returning -EINVAL in case user orders 
>> CLONE_NEWPIDS and compiling out all the namespace cloning code. This 
>> is just a more elegant way to get rid of pid namespaces rather than 
>> Ingo proposed.
> 
> unfortunately i have to NACK that approach. We never allowed broken 
> user-space visible APIs into the kernel like that because it just gives 
> a vector for that breakage to become de-facto used and forced upon the 
> core kernel. Even if they can be .config turned off. That's just a lame 
> excuse that delays the fixing of it. We may mark features that have a 
> good expectation to be fixed as CONFIG_EXPERIMENTAL, and we may mark 

Pid namespaces have more than a good expectations to be fixed, so
feel free to mark the (currently pending) PID_NS config option with
"depends on EXPERIMENTAL".

All the problems I know are slowly getting fixed, but most of them are
just related to "bad pid value is reported to the user space when we 
work inside some new namespace".

Unfortunately, as I can see, all the discussions of pid namespaces 
happen behind my bask, so all I can is just fix the problems I'm 
aware of.

> drivers that nobody maintains anymore as CONFIG_BROKEN, but we dont 
> introduce new core syscall features with CONFIG_BROKEN! We never did and 
> i hope we never will.
> 
> The _only_ way to force the fixing of such type of breakages is to not 
> offer them _at all_. Really, you are proposing a major new extension to 
> lots of important core Linux APIs so please try to solve this problem 
> cleanly, it's really severe. Right now as things stand this containers 

I'm sure, that no *new* problems appear in case you don't enter the new
namespace, so just disable the pid space creation code (with EXPERIMENTAL 
option) and live with the original kernel.

If you point me one, I'd be glad to fix it.

> sub-feature is "a little bit pregnant". This is one of the few cases 
> where we really _must_ say no.
> 
> 	Ingo
> 

