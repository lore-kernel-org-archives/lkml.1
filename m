Return-Path: <linux-kernel-owner+w=401wt.eu-S932535AbXKPTHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbXKPTHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 14:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbXKPTGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 14:06:53 -0500
Received: from rtr.ca ([76.10.145.34]:2182 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbXKPTGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 14:06:52 -0500
Message-ID: <473DEA4A.2030606@rtr.ca>
Date: Fri, 16 Nov 2007 14:06:50 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
References: <4739ADA2.4060604@rtr.ca> <alpine.LFD.0.9999.0711131521590.3265@localhost.localdomain> <4739E347.30406@rtr.ca> <473C7495.40805@rtr.ca> <20071115181418.GA6603@ucw.cz> <473C825E.3030307@rtr.ca> <20071115193424.GA31691@elte.hu> <20071115193612.GA751@elte.hu> <473CC6D4.2010909@rtr.ca> <20071116055531.GA16273@elte.hu> <20071116071522.GA1453@elte.hu>
In-Reply-To: <20071116071522.GA1453@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>>> Is there a version of these that works with 2.6.23.1 ?
>> yes, i've backported it and have uploaded the v2.6.23 version to:
>>
>>   http://redhat.com/~mingo/latency-tracing-patches/latency-tracer-v2.6.23.1-combo.patch
..

> ok, i experimented around with the latency tracer, trying to capture the 
> trace of a full suspend+resume cycle, and it needed the tracer fix below 
> (GTOD clocksource suspend/resume would otherwise confuse the tracer and 
> you'd get no trace output as a result).
> 
> once that tracer bug was fixed, the best method to generate a trace was 
> to do this:
> 
>    echo 1 > /proc/sys/kernel/stackframe_tracing
>    echo 1 > /proc/sys/kernel/syscall_tracing
>    ./trace-cmd bash -c "echo mem > /sys/power/state" > trace.txt
..

I've applied the tracer for 2.6.23.1 patch, plus the bugfix,
and now I just get blinking-LEDs (black screen of death) on resume.

Cheers
