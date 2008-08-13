Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYHMUHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYHMUHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYHMUHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:07:41 -0400
Received: from gw.goop.org ([64.81.55.164]:50091 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbYHMUHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:07:41 -0400
Message-ID: <48A33EE3.80109@goop.org>
Date: Wed, 13 Aug 2008 13:06:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: Efficient x86 and x86_64 NOP microbenchmarks
References: <20080813191926.GB15547@Krystal> <48A33D65.4020802@redhat.com>
In-Reply-To: <48A33D65.4020802@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> No, I can easily make a patch that does not use frame pointers but 
> still uses -pg. We just can not print the parent function in the 
> trace. This can easily be added to a config, as well as easily 
> implemented.

Why?  You can always get the calling function, because its return 
address is on the stack (assuming mcount is called before the function 
puts its own frame on the stack).  But without a frame pointer, you 
can't necessarily get the caller's caller.

But I think Andi's point is that gcc forces frame pointers on when you 
enable mcount, so there's no choice in the matter.

    J
