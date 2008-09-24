Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbYIXQcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbYIXQcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYIXQcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:32:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750988AbYIXQcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:32:13 -0400
Date: Wed, 24 Sep 2008 09:24:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Martin Bligh <mbligh@google.com>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.LFD.1.10.0809240921430.3265@nehalem.linux-foundation.org>
References: <20080924051056.650388887@goodmis.org>  <20080924051400.195780424@goodmis.org>  <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>  <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>
 <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Sep 2008, Peter Zijlstra wrote:
> 
> So when we reserve we get a pointer into page A, but our reserve length
> will run over into page B. A write() method will know how to check for
> this and break up the memcpy to copy up-to the end of A and continue
> into B.

I would suggest just not allowing page straddling.

Yeah, it would limit event size to less than a page, but seriously, do 
people really want more than that? If you have huge events, I suspect it 
would be a hell of a lot better to support some kind of indirection 
scheme than to force the ring buffer to handle insane cases.

Most people will want the events to be as _small_ as humanly possible. The 
normal event size should hopefully be in the 8-16 bytes, and I think the 
RFC patch is already broken because it allocates that insane 64-bit event 
counter for things. Who the hell wants a 64-bit event counter that much? 
That's broken.

		Linus
