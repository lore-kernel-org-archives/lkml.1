Return-Path: <linux-kernel-owner+w=401wt.eu-S933502AbXCaFEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502AbXCaFEm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 01:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965131AbXCaFEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 01:04:42 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:38534 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933502AbXCaFEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 01:04:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=6auas7OYJX7PdPuwVGpBwT4ZNWSjPtMGmspO0J7OIkvhQafNjUPEkzGV/nKDBP3y/wRP1MNScDH3UU2BYCb23pCOe/J0dxB2DkH8wS8HzXcEwkQlmD0rWwNt9osvjVwguGrY7Bj66I+12WIzIAzVBD2ivrnPDl4UrrVxeoJTC7E=  ;
X-YMail-OSG: 4RoftYsVM1m72.6zP5l26aYcaWfriAEdusCBXXMQjS1IEj8PnEuRhJL0Pu9F3s2rduqf3Po3AhuWvuYr2NkLIa6Cuf_ELR4X3Rn5gzpGF6P_qp_wNhE-
Message-ID: <460DEBDA.1050403@yahoo.com.au>
Date: Sat, 31 Mar 2007 15:04:26 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Xenofon Antidides <xantidides@yahoo.gr>
CC: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [test] hackbench.c interactivity results: vanilla versus SD/RSDL
References: <325618.89505.qm@web26701.mail.ukl.yahoo.com>
In-Reply-To: <325618.89505.qm@web26701.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xenofon Antidides wrote:
> ----- Original Message ----
> From: Ingo Molnar <mingo@elte.hu>
> To: Con Kolivas <kernel@kolivas.org>
> Cc: linux list <linux-kernel@vger.kernel.org>; Andrew Morton <akpm@linux-foundation.org>; Mike Galbraith <efault@gmx.de>
> Sent: Thursday, March 29, 2007 9:22:49 PM
> Subject: [test] hackbench.c interactivity results: vanilla versus SD/RSDL
> 
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> 
>>* Con Kolivas <kernel@kolivas.org> wrote:
>>
>>
>>>I'm cautiously optimistic that we're at the thin edge of the bugfix 
>>>wedge now.
> 
> [...]
> 
> 
>>and the numbers he posted:
>>
>> http://marc.info/?l=linux-kernel&m=117448900626028&w=2
> 
> 
> We been staring at these numbers for while now and we come to the conclusion they wrong.
> 
> The test is f is 3 tasks, two on different and one on same cpu as sh here:
> virgin 2.6.21-rc3-rsdl-smp
> top - 13:52:50 up 7 min, 12 users,  load average: 3.45, 2.89, 1.51
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
>  6560 root      31   0  2892 1236 1032 R   82  0.1   1:50.24 1 sh
>  6558 root      28   0  1428  276  228 S   42  0.0   1:00.09 1 f
>  6557 root      30   0  1424  280  228 R   35  0.0   1:00.25 0 f
>  6559 root      39   0  1424  276  228 R   33  0.0   0:58.36 0 f
> 
> 6560 sh is asking for 100% cpu on cpu number 1
> 6558 f is asking for 50% cpu on cpu number 1
> 6557 f is asking for 50% cpu on cpu number 0
> 6559 f is asking for 50% cpu on cpu number 0
> 
> So if 6560 and 6558 are asking for cpu from cpu number 1:
> 6560 wants 100% and 6558 wants 50%.
> 6560 should get 2/3 cpu 6558 should get 1/3 cpu

I don't think you can say that. If the 50% task alternated between
long periods of running and sleeping, then the end result should
approach a task that is sleeping for 50% of the time, and on the
CPU 25% of the time. As the periods get shorter, then the schedulers
will favour the 50% task relatively more, but details will depend on
implementation.

You could have an implementation that always gives runs the 50% task
when it becomes runnable, because it is decided that its priority is
higher because it has been sleeping.

The only thing you can really say is that the 50% task should get
between 25% and 50% (inclusive) CPU time.

-- 
SUSE Labs, Novell Inc.
