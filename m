Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbZA1WLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbZA1WLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbZA1WL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:11:26 -0500
Received: from mga03.intel.com ([143.182.124.21]:31690 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbZA1WLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:11:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,339,1231142400"; 
   d="scan'208";a="104778593"
Message-ID: <4980D6A0.9030004@intel.com>
Date: Wed, 28 Jan 2009 14:05:20 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081103)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       powertop ml <power@bughost.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       "srostedt@redhat.com" <srostedt@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       "Kok, Auke" <auke@foo-projects.org>
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
References: <497F69A4.2070007@intel.com> <20090127205137.GD15877@ghostprotocols.net> <20090127211452.GA5850@nowhere>
In-Reply-To: <20090127211452.GA5850@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2009 22:11:24.0089 (UTC) FILETIME=[5B6F2290:01C98195]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Jan 27, 2009 at 06:51:37PM -0200, Arnaldo Carvalho de Melo wrote:
>> Em Tue, Jan 27, 2009 at 12:08:04PM -0800, Kok, Auke escreveu:
>>> This tracer monitors regular file open() syscalls. This is a fast
>>> and low-overhead alternative to strace, and does not allow or
>>> require to be attached to every process.
>>>
>>> The tracer only logs succesfull calls, as those are the only ones we
>>> are currently interested in, and we can determine the absolute path
>>> of these files as we log.
>>>
>>> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
>> <SNIP>
>>  
>>> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
>>> index 4d3d381..24c17d2 100644
>>> --- a/kernel/trace/trace.h
>>> +++ b/kernel/trace/trace.h
>>> @@ -30,6 +30,7 @@ enum trace_type {
>>>         TRACE_USER_STACK,
>>>         TRACE_HW_BRANCHES,
>>>         TRACE_POWER,
>>> +       TRACE_OPEN,
>> Why not a TRACE_VFS or TRACE_SYSCALL and then multiplex there open,
>> close, etc? trace_assign_type will get humongous in no time this way.
> 
> 
> That's what I was about to answer too.
> That would be sad to find one tracer for open, one for read, one for write...
> 
>  
>> TRACE_BLK does multiplexing, as does TRACE_PROCESS that Frank just
>> posted too, and I'm working on a plugin for the patch that Neil
>> submitted for the socket layer that also will need an entry there for
>> its tracepoints.
>>
>> Frederic, it seems that discussion about subtypes has to continue :-)
> 
> 
> Indeed, that becomes serious :-)
> 

I totally agree - this tracer was purely made quick-and-dirty to get sreadahead to
the next level. The in-kernel syscall trace facility is extremely potent and I
don't doubt that my patch may have been found slightly absurd by some :)

In all it was not productive to write a giant trace facility just to get
sreadahead one tracer type. Now that the code works and the benefit is proven, I'm
happy to see if we can work on making a decent long-term non-specialistic solution.

Auke

