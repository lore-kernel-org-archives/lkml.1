Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbZG2JAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbZG2JAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 05:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZG2JAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 05:00:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54593 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbZG2JAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 05:00:36 -0400
Message-ID: <4A700F8A.6000505@garzik.org>
Date: Wed, 29 Jul 2009 04:59:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu,
       paulus@samba.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       linux-tip-commits@vger.kernel.org
Subject: Re: perf_counter: hook up the tracepoint events
References: <20090319194233.744044174@chello.nl>	 <tip-ee78a855ff4d8d3d77b46696994dca393228bb8a@git.kernel.org>	 <4A6F9F51.4010107@garzik.org> <1248856508.6987.3041.camel@twins>
In-Reply-To: <1248856508.6987.3041.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2009-07-28 at 21:01 -0400, Jeff Garzik wrote:
>> Peter Zijlstra wrote:
>>> diff --git a/init/Kconfig b/init/Kconfig
>>> index 8a38443..761129a 100644
>>> --- a/init/Kconfig
>>> +++ b/init/Kconfig
>>> @@ -945,6 +945,11 @@ config PERF_COUNTERS
>>>  
>>>  	  Say Y if unsure.
>>>  
>>> +config EVENT_PROFILE
>>> +	bool "Tracepoint profile sources"
>>> +	depends on PERF_COUNTERS && EVENT_TRACER
>>> +	default y
>>> +
>>>  endmenu
>> Adding help text would be... helpful.   :)
>>
>> The net result in this case was the addition of a completely-unexplained 
>> Kconfig option late in 2.6.31-rc.
>>
>> Maybe the x86 maintainers could help see that they don't push 
>> unexplained Kconfig options upstream -- particularly ones we are asked 
>> to enable by default?
> 
> You're right. Johannes Berg made the same complaint yesterday.
> 
> Is the below any good?
> 
> ---
> Subject: perf_counter: Add help text to CONFIG_EVENT_PROFILE
> 
> Explain what tracepoint profile sources is about.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  init/Kconfig |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 13473ac..ffae67c 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -957,6 +957,12 @@ config EVENT_PROFILE
>  	bool "Tracepoint profile sources"
>  	depends on PERF_COUNTERS && EVENT_TRACING
>  	default y
> +	help
> +	 Allow the use of tracepoints as software performance counters.
> +
> +	 When this is enabled, you can create perf counters based on
> +	 tracepoints using PERF_TYPE_TRACEPOINT and the tracepoint ID
> +	 found in debugfs://tracing/events/*/*/id.

Thanks.  Is this feature useful w/out debugfs?

If yes, ACK.

	Jeff




