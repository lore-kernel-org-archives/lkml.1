Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbZHTVTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbZHTVTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbZHTVTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:19:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145AbZHTVTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:19:37 -0400
Message-ID: <4A8DBDDB.5080402@redhat.com>
Date: Thu, 20 Aug 2009 17:19:23 -0400
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add minimal support for software performance counters
 for ia64
References: <4A8C2290.3040707@redhat.com> <1250698351.8282.106.camel@twins>	 <4A8C4CAA.5070101@redhat.com> <1250708819.7154.5.camel@laptop>
In-Reply-To: <1250708819.7154.5.camel@laptop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2009-08-19 at 15:04 -0400, William Cohen wrote:
>> Peter Zijlstra wrote:
>>> On Wed, 2009-08-19 at 12:04 -0400, William Cohen wrote:
>>>> +#ifdef __ia64__
>>>> +#include "../../arch/ia64/include/asm/unistd.h"
>>>> +#define rmb()          asm volatile("" ::: "memory")
>>>> +#define cpu_relax()    asm volatile("" ::: "memory");
>>>> +#endif
>>> Surely the itanic has a real memory barrier? The kernel seems to use
>>> something along the lines of mf.
>>>
>>> Also, cpu_relax() seems to end up being asm volatile("hint @pause" :::
>>> "memory"), although we don't seem to have an actual user of cpu_relax()
>>> in perf atm.
>>>
>>>
>>>
>> Peter, thanks for the comment. I took a look at the rmb() and cpu_relax() code
>> in the kernel and revised the patch with the appropriate defines
> 
> Looks good now, thanks!
> 

When looking through the patch today I realized the new perf_counter.h was
placed in include/asm-ia64. It should be placed in
arch/ia64/include/asm/perf_counter.h.

-Will
