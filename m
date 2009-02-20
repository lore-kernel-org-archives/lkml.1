Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbZBTR2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbZBTR2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZBTR2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:28:37 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:65137 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbZBTR2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:28:36 -0500
Message-ID: <499EE865.40708@oracle.com>
Date: Fri, 20 Feb 2009 09:29:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
References: <499edf47.1818d00a.060b.2b8d@mx.google.com> <499EE162.4050008@oracle.com> <20090220172241.GF24538@elte.hu>
In-Reply-To: <20090220172241.GF24538@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.499EE82F.0160:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>>> This is what happens on the following build error:
>>>
>>> kernel/built-in.o: In function `marker_update_probe_range':
>>> (.text+0x52f64): undefined reference to `tracepoint_probe_register_noupdate'
>>> kernel/built-in.o: In function `marker_update_probe_range':
>>> (.text+0x52f74): undefined reference to `tracepoint_probe_unregister_noupdate'
>>> kernel/built-in.o: In function `marker_update_probe_range':
>>> (.text+0x52fb9): undefined reference to `tracepoint_probe_unregister_noupdate'
>>> kernel/built-in.o: In function `marker_update_probes':
>>> marker.c:(.text+0x530ba): undefined reference to `tracepoint_probe_update_all'
>>>
>>> CONFIG_KVM_TRACE will select CONFIG_MARKER, but the latter 
>>> depends on CONFIG_TRACEPOINTS which will not be selected.
>>>
>>> A temporary fix is to make CONFIG_MARKER select 
>>> CONFIG_TRACEPOINTS, though it doesn't fix the source KConfig 
>>> dependency handling problem.
>>>
>>> Reported-by: Ingo Molnar <mingo@elte.hu>
>>> Cc: Roman Zippel <zippel@linux-m68k.org>
>>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>>> ---
>>>  init/Kconfig |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/init/Kconfig b/init/Kconfig
>>> index b6400a5..a93f957 100644
>>> --- a/init/Kconfig
>>> +++ b/init/Kconfig
>>> @@ -975,7 +975,7 @@ config TRACEPOINTS
>>>  
>>>  config MARKERS
>>>  	bool "Activate markers"
>>> -	depends on TRACEPOINTS
>>> +	select TRACEPOINTS
>>>  	help
>>>  	  Place an empty function call at each marker site. Can be
>>>  	  dynamically changed for a probe function.
>> but using "select" instead of "depends on" just causes the 
>> kind of problem that you described, whereas using "depends on" 
>> does follow dependency chains.
> 
> Well, as long as the secondary selects are 'expanded' along the 
> line of dependencies, it should still be fine. With an 

Agreed.

> increasing number of dependencies it quickly becomes ugly 
> though. This might be one of the cases where it works.

Agreed.

> Eventually we should eliminate markers, their uses can either be 
> converted to new-style tracepoints, or to ftrace_printk().


Thanks,
-- 
~Randy
