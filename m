Return-Path: <linux-kernel-owner+w=401wt.eu-S934805AbZAPOcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934805AbZAPOcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbZAPOce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:32:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52872 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZAPOcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:32:33 -0500
Date: Fri, 16 Jan 2009 09:32:32 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/2] ftrace: updates to tip
In-Reply-To: <20090116112345.GC20082@elte.hu>
Message-ID: <alpine.DEB.1.10.0901160929300.22303@gandalf.stny.rr.com>
References: <20090116004050.273665842@goodmis.org> <20090116112345.GC20082@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 16 Jan 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ingo,
> > 
> > The first patch is critical, and needs to stay with trace_output.c Not 
> > that critical since trace_output.c is not in mainline yet.
> > 
> > The second patch gives the ability to stack trace functions. I've been 
> > leery about adding this and still keep it a separate option from the 
> > "stacktrace" that already exists. This is because when enabled with no 
> > filtering, the lag between typing and seeing what is typed can be up to 
> > 10 seconds or more.
> 
> Btw., is this true even if frame pointers are enabled? When frame pointers 
> are disabled we scan the full kernel stack => that can be quite slow if 
> every kernel function is traced ;-)

After making my latest changes, I see a half sec lag. I don't know
why it was so slow before. But I do have all the debug features enabled
which would also slow things down quite a bit (lockdep, et. al)

> 
> > I made the function stack trace an option attached to the function 
> > tracer, so it must be enabled after the function tracer has been set. 
> > This still needs to be updated in ftrace.txt.
> 
> maybe we could drive this via the filter API? Something like:
> 
>    echo "*btrfs*:stacktrace" >> set_filter_functions
> 
> Would automatically mean that those functions will all generate 
> stacktraces too. Note how safe this API is by default: the filter is used 
> for a narrow scope of functions anwyay. To get it for all kernel functions 
> one would have to do:
> 
>    echo "*:stacktrace" >> set_filter_functions
> 
> Which one cannot do accidentally.
> 
> What do you think?

Now that I see only a 1/2 sec lag, do you still think this is necessary?

Maybe I should go back and see why it was so bad before?

But I do notice that not all functions produce a valid stack trace. Maybe 
it would be better to add that api :-?

-- Steve

