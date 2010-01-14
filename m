Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283Ab0ANCwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab0ANCwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615Ab0ANCwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:52:17 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:43019 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab0ANCwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:52:17 -0500
Message-ID: <4B4E8594.4020707@oracle.com>
Date: Thu, 14 Jan 2010 10:46:44 +0800
From: Wenji Huang <wenji.huang@oracle.com>
Reply-To: wenji.huang@oracle.com
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: tracing: Multi definition of TRACE_INCLUDE_FILE
References: <4B443E78.7040704@oracle.com> <20100114024147.GB15301@goodmis.org>
In-Reply-To: <20100114024147.GB15301@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B4E86D1.008E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Steven Rostedt wrote:
> On Wed, Jan 06, 2010 at 03:40:40PM +0800, Wenji Huang wrote:
>> Hi,
>>
>> There are multi definition of TRACE_INCLUDE_FILE on
>> include/trace/events/{syscalls, kvm}.h
>> It will result in compilation error when some
>> out-of-tree tools like Systemtap processes kernel
>> tracepoints in a way to put header files into module.
>>
> 
> Does the following patch fix your issues?
> 

Yes, that could be.

Thanks,
wenji

> -- Steve
> 
> 
> diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
> index dbe1084..532d658 100644
> --- a/include/trace/events/kvm.h
> +++ b/include/trace/events/kvm.h
> @@ -4,6 +4,7 @@
>  #include <linux/tracepoint.h>
>  
>  #undef TRACE_SYSTEM
> +#undef TRACE_INCLUDE_FILE
>  #define TRACE_SYSTEM kvm
>  #define TRACE_INCLUDE_FILE kvm
>  
> diff --git a/include/trace/events/syscalls.h b/include/trace/events/syscalls.h
> index fb726ac..52290bb 100644
> --- a/include/trace/events/syscalls.h
> +++ b/include/trace/events/syscalls.h
> @@ -1,4 +1,5 @@
>  #undef TRACE_SYSTEM
> +#undef TRACE_INCLUDE_FILE
>  #define TRACE_SYSTEM raw_syscalls
>  #define TRACE_INCLUDE_FILE syscalls
>  

