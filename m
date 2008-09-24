Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbYIXQbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbYIXQbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbYIXQbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:31:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41881 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYIXQbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:31:06 -0400
Date: Wed, 24 Sep 2008 12:31:04 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <20080924161347.GA31451@Krystal>
Message-ID: <alpine.DEB.1.10.0809241229380.5017@gandalf.stny.rr.com>
References: <20080924051056.650388887@goodmis.org> <20080924051400.195780424@goodmis.org> <1222268595.16700.149.camel@lappy.programming.kicks-ass.net> <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com> <20080924161347.GA31451@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Sep 2008, Mathieu Desnoyers wrote:
> /*
>  * Perform an aligned write of the input data into the buffer.
>  *
>  * buffer : page pointer array
>  * woffset : offset in the page pointer array where write starts from
>  * data : input data
>  * len : length of data to copy
>  *
>  * Note : if a NULL buffer is passed, no copy is performed, but the
>  * alignment and offset calculation is done. Useful to calculate the
>  * size to reserve.
>  *
>  * return : length written
>  */
> size_t write(struct page **buffer, size_t woffset, void *data, size_t len);
> 
> Therefore, we could have code which writes in the buffers, without extra
> copy, and without using vmap, in multiple writes for a single event,
> which would deal with data alignment, e.g. :
> 
> size_t woffset, evsize = 0;
> 
> evsize += write(NULL, evsize, &var1, sizeof(var1));
> evsize += write(NULL, evsize, &var2, sizeof(var2));
> evsize += write(NULL, evsize, &var3, sizeof(var3));
> 
> woffset = reserve(..., evsize);
> 
> woffset += write(buffer, woffset, &var1, sizeof(var1));
> woffset += write(buffer, woffset, &var2, sizeof(var2));
> woffset += write(buffer, woffset, &var3, sizeof(var3));
> 
> commit(..., evsize);
> 
> Does that make sense ?

Mathieu,

I'm starting to think that you are just too smart for your own good ;-)
No it does not make sense. Well, it does not after looking at it for 10 
seconds.

Which brings up my point, the interface must be simple, and not cause 
people to spend minutes trying to figure out what the trace is doing.

-- Steve

