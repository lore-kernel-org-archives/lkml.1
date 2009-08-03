Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbZHCTtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbZHCTtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbZHCTtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:49:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:39060 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235AbZHCTtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:49:03 -0400
Message-ID: <4A773EBD.3050707@windriver.com>
Date: Mon, 03 Aug 2009 14:47:09 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Christoph Hellwig <hch@infradead.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Dave Anderson <anderson@redhat.com>, crash-utility@redhat.com,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <clark.williams@gmail.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Jason Baron <jbaron@redhat.com>, srostedt@redhat.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE][RFC][PATCH] Crash-utility, tracing: enable crash to
 analyze tracing from core-file (make tracing can act as a flight recorder)
References: <4A76F8A1.30503@cn.fujitsu.com>	 <20090803151420.GA8712@infradead.org> <1249312875.7924.106.camel@twins>
In-Reply-To: <1249312875.7924.106.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Aug 2009 19:47:11.0819 (UTC) FILETIME=[3186C1B0:01CA1473]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-08-03 at 11:14 -0400, Christoph Hellwig wrote:
>   
>> Nice!  Now the only thing missing is gettind kdb in mainline and a trace
>> reader in kdb ;-)
>>
>> Any idea how easy it is to reuse the crash/gdb code for looking at crash
>> dumps through kgdb?
>>     
>
> It was suggested a while ago to implement kdb as an in-kernel consumer
> of kgdb or something. No idea what happened there..
>   

With respect to kdb for the mainline, this is still largely a work in
progress, but there is a prototype implementation of kdb which is hooked
up to the kdb backend.  There is a new prototype pushed to the kgdb
development tree every couple of weeks.   The prototype #4 will be
pushed sometime this week.

If there is a nice API to call for the trace piece, it is pretty trivial
to add additional kdb commands which would allow you to print your trace
buffers as needed.  The unified kdb/kgdb prototype also supports calling
kdb commands through gdb's "monitor" command.  It is not clear if that
satisfies the need that Christoph asked about, or if he had some other
data analysis in mind.

In no particular order, tracing, kernel probes, profiling data display,
kdump, disassembly and kernel mode setting were some of the pieces that
are on the wish list for integration with the kdb prototype.  Kernel
mode setting is presently the highest priority on the wish list for a
new feature.

I will gladly accept patches into the kdb prototype if people have any. :-)

Jason.

Prototype #3 is at:

http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=shortlog;h=kdb_prototype3

There had not been any further posts about the kdb -> kgdb integration
outside the first because the project is still pretty young and there is
a significant amount of clean up required to the original kdb code base
in order bring it closer to consideration for any kind of lkml
scrutiny.  The nice thing about the kdb prototype is that it is almost
entirely arch independent.  The goal of this project is to make such
that any arch that makes use of the kgdb core today, could make use of
the generic kdb interface.
