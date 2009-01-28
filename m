Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbZA1WZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbZA1WZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZA1WZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:25:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:51263 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbZA1WZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:25:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,340,1231142400"; 
   d="scan'208";a="426295220"
Message-ID: <4980D9D9.4060706@intel.com>
Date: Wed, 28 Jan 2009 14:19:05 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081103)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       powertop ml <power@bughost.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       "srostedt@redhat.com" <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       "Kok, Auke" <auke@foo-projects.org>
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
References: <497F69A4.2070007@intel.com> <20090127224303.GB5850@nowhere>
In-Reply-To: <20090127224303.GB5850@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2009 22:25:07.0888 (UTC) FILETIME=[4674E300:01C98197]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Jan 27, 2009 at 12:08:04PM -0800, Kok, Auke wrote:
>> This tracer monitors regular file open() syscalls. This is a fast
>> and low-overhead alternative to strace, and does not allow or
>> require to be attached to every process.
>>
>> The tracer only logs succesfull calls, as those are the only ones we
>> are currently interested in, and we can determine the absolute path
>> of these files as we log.
>>
>> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
> 
> 
> Hi Auke,
> 
> Speaking about a global syscall tracer, I made a patch to trace only the syscalls
> with the function-graph-tracer.
> 
> http://lkml.org/lkml/2008/12/30/267
> 
> Its approach and purpose is different than a tracer dedicated only to syscalls.
> The function graph tracer traces execution graph of the functions and is more about
> execution time spent and code flow whereas a syscall tracer can provide more specific
> informations about syscalls.
> 
> So both are not overlaping.
> 
> But the low level part of my patch creates a thread flag _TIF_SYSCALL_TRACE which triggers
> a ptrace hook when set.
> This low-level part can easily be used by all tracers that would like to inspect syscalls.
> 
> Just a change is needed: Steven requested that the part inside syscall_trace_enter become
> a tracepoint, making it totally shareable between tracers and easy to turn on and off.
> 
> And perhaps the parts that set/clear the flag on all tasks can be shared too.
> 
> So we can start with this low-level syscall tracing facility. If you want, I can adapt
> this low-level part and submit a patch this week or the next one to give you this base
> infrastructure.
> 
> 
> Once we have it, I think a syscall tracer can be fed with new syscalls events through
> several patch iterations, starting with the open and close one :-)
> 
> Are you ok with that?

That sounds like a good start. one note of concern is that (for sreadahead) we're
really interested in the _absolute_ path, not the relative ones that are passed to
the syscall by userspace.

This may significantly complicate things when it comes to fs syscalls, and is one
of the reasons I wrote the quick-n-dirty alternative.


Auke
