Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbZKDCPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbZKDCPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbZKDCP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:15:29 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:39948 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbZKDCP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:15:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xCuXQx5d0odPcN2DhH+azFqz46jYN6/NsULMqMJlRVscaARXPChA2FOEvtvVh3uStt
         lsnm4OBWLY8CA8DCVmxhJ0FSZxbrRhuSGSeSY/rViGr52KGDCwHqfdK2hR8/pKghwQ/Q
         eHxPhGkxXt7tq+8/6CqcuD/hxsAzD5+svqpCg=
Date: Wed, 4 Nov 2009 03:15:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip perf/probes 0/5] perf-probe and kprobe-tracer
	updates
Message-ID: <20091104021532.GC5092@nowhere>
References: <20091104001204.3454.75999.stgit@harusame>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104001204.3454.75999.stgit@harusame>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 07:12:04PM -0500, Masami Hiramatsu wrote:
> Hi,
> 
> Here are some updates according to previous LKML threads.
>  - Update perf-probe document.
>  - Improve error messages.
>  - Fall back to non-dwarf mode if possible.
>  - Change group name to probe.
>  - Rename kprobe-tracer to kprobe-event.
> 
> BTW, I think perf-probe and kprobe-event might better share
> similar syntax for not confusing users. And for that purpose,
> perf-probe syntax should introduce event/group specifier,
> for example,


I personally more imagine the debugfs kprobe-event interface as
something used by higher level applications rather than users.

I've tried to use kprobe events directly by the past to do
some debugging, and once I wanted to go further a simple function
probe, like fetching a variable or putting a probe in a given branch,
it rapidly grew into a pain: I had to read assembly code, guess
which register was matching which variable, etc... It works, but
it takes too much time, and printk() rapidly becomes a temptation :)

It too low-level, but its use through perf brings all that to the
human dimension.

So, I'm not sure we really need to have such tight syntax between
both, since the debugfs more likely behaves as a gateway, something
I don't imagine to be used broadly as an end-user interface but mostly
as a kernel interface.

Especially we shouldn't break the perf probe syntax simplicity
just because we want both syntaxes to be tight.

(Nothing related to the event/group feature itself, it's just an
opinion about the need of this similarity between two interfaces).


>  perf probe "newgroup:newevnt=func:10 arg1 arg2"
> 
> adds the newevent under newgroup. On the other hand, ftrace
> users can also add a new event as below;
> 
>  echo 'newgroup:newevent=func+0x18 arg1=$a1 arg2=$a2' > kprobe_events
> 
> Any thoughts?


Yeah, that would probably be nice, especially once we have a good
collection of probes to handle and to organize in a sensical output.

But it would be better to have that as an optional thing:

	perf probe "[group:name=]func...."


so that we keep the simplicity of:

	perf probe func

I guess you meant it as optional already, but just in case... :)

Thanks.

