Return-Path: <linux-kernel-owner+w=401wt.eu-S1752112AbZL1KmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbZL1KmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZL1KmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:42:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56437 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbZL1KmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:42:08 -0500
Message-ID: <4B388B0D.4000203@cn.fujitsu.com>
Date: Mon, 28 Dec 2009 18:40:13 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/5]: trace_event: export HZ in timer's tracepoint
 format
References: <4B27702F.1080507@cn.fujitsu.com> <20091215142325.GC5833@nowhere> <4B30C2D1.4030006@cn.fujitsu.com> <4B30C3A0.909@cn.fujitsu.com> <20091228075417.GB20039@elte.hu>
In-Reply-To: <20091228075417.GB20039@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:

> 
> I think we can do something slightly different and more efficient: just create 
> a new timer event to report the value of HZ.
> 
> That way we dont clutter the timer_expire_entry record format with a 
> repetitive HZ field. It's an extra 4 bytes overhead: that has to be written, 
> passed along, copied and thrown away in 99.9999% of the cases - such overhead 
> should be avoided.
> 
> If you created a special timer_params event, which would produce precisely one 
> event when triggered via say a new perf ioctl. I.e. add something like this to 
> perf_event.h:
> 
>   #define PERF_EVENT_IOC_INJECT       _IOW('$', 7, __u64)
> 
> and add code to kernel/perf_event.c's perf_ioctl() function that takes that 
> __u64 parameter as an event ID and injects an 'artificial' event.
> 
> Such a new feature would be useful for other things as well: backtesting rare 
> events, injecting other types of 'parameter/query events', etc.
> 
> There might be more details to this, but it would be a useful scheme IMO - and 
> it would still integrate nicely with the whole ftrace event enumeration scheme 
> so tooling support would be easier.
> 
> What do you think?
> 

Sure, this is the better way, i'll fix it address your suggestion in the next version.

Thanks,
Xiao
