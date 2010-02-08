Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0BHJrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:47:13 -0500
Received: from mail-qy0-f195.google.com ([209.85.221.195]:54332 "EHLO
	mail-qy0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab0BHJrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:47:12 -0500
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Feb 2010 04:47:11 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=c93EvTmhGgavPTLCtL0x4tFAs2Y/k/hVmSX2PAmK0vGq3UbEf46icyBZFfN3ZBn6iD
         WpvkbknSh1ZDTt672OtfGyi5FqGOE2/VA2gMSFuySOUsb1QaUGiJWnGXoGQObU+c+kiv
         L/uCIzy0ElWRmQ5Z+YMbCDSmJj8pQxLcb3h8M=
MIME-Version: 1.0
In-Reply-To: <20100208071954.GA24721@elte.hu>
References: <1265424425-31562-1-git-send-email-dzickus@redhat.com>
	 <1265424425-31562-4-git-send-email-dzickus@redhat.com>
	 <20100208071954.GA24721@elte.hu>
Date: Mon, 8 Feb 2010 12:39:06 +0300
Message-ID: <aa79d98a1002080139h1d65fd6eq961cdbf040835e76@mail.gmail.com>
Subject: Re: [PATCH 3/3 v2] nmi_watchdog: config option to enable new 
	nmi_watchdog
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>, peterz@infradead.org, aris@redhat.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/10, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Don Zickus <dzickus@redhat.com> wrote:
>
>> +config NMI_WATCHDOG
>> +	bool "Detect Hard Lockups with an NMI Watchdog"
>> +	depends on DEBUG_KERNEL && PERF_EVENTS
>> +	default y
>> +	help
>> +	  Say Y here to enable the kernel to use the NMI as a watchdog
>> +	  to detect hard lockups.  This is useful when a cpu hangs for no
>> +	  reason but can still respond to NMIs.  A backtrace is displayed
>> +	  for reviewing and reporting.
>> +
>> +	  The overhead should be minimal, just an extra NMI every few
>> +	  seconds.
>
> Thought for later patches: I think an architecture should be able to express
> via a Kconfig switch that it actually _has_ NMI events. There's
> architectures
> which dont have a PMU driver and only have software events. There's also
> architectures that have a PMU driver but no NMIs.
>
> Something like ARCH_HAS_NMI_PERF_EVENTS?
>
> Also, i havent checked, but what is the practical effect of the new generic
> watchdog on x86 CPUs that does not have a native PMU driver yet - such as
> P4s?
>

p4 pmu is not yet implemented. I'll try to post on lkml the thnigs
i've done for it today evening, though it's pretty ugly i would say.

> Anyway, i'll create a tip:perf/nmi topic branch for these patches, it
> certainly looks like a useful generalization and a new architecture that has
> perf could easily enable it, without having to write its own NMI watchdog
> implementation. It's also useful for any new watchdog features that people
> might want to add. Plus it makes the x86 PMU code cleaner in the long run as
> well.
>
> Thanks,
>
> 	Ingo
>
