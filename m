Return-Path: <linux-kernel-owner+w=401wt.eu-S1751448AbZHSJNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbZHSJNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbZHSJNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:13:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62610 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbZHSJNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:13:45 -0400
Message-ID: <4A8BC301.3080404@cn.fujitsu.com>
Date: Wed, 19 Aug 2009 17:16:49 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Re: [RFC PATCH] Add timer-source of walltime for ftrace
References: <alpine.DEB.2.00.0907272218480.30108@gandalf.stny.rr.com> <4A89213C.5090109@cn.fujitsu.com> <20090818215620.A63C.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0908181454090.727@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0908181454090.727@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 19 Aug 2009, KOSAKI Motohiro wrote:
> 
>>> +u64 notrace trace_clock_walltime(void)
>>> +{
>>> +	u32 remainder;
>>> +	return base_walltime.tv_sec + div_u64_rem(
>>> +			trace_clock() + base_walltime.tv_nsec,
>>> +			NSEC_PER_SEC, &remainder);
>>> +}
>> Why do we need calculate walltime at ring-buffer recordng phase?
>> IOW, Why can't we calculate this at displaing time?
> 
> Right! We should have something like this:
> 
> 	return (u64)base_walltime.tv_sec * NSEC_PER_SEC +
> 		trace_clock() + base_walltime.tv_nsec;
> 
> And then we could divide it out later.
> 
> And then we could even show more fields in the output and not limit 
> ourselves to seconds.
> 
> -- Steve

Hello, Steven, Kosaki-san:

Thanks for your good suggestion,
I'll fix it in next version.

Thanks
Zhaolei

