Return-Path: <linux-kernel-owner+w=401wt.eu-S1758082AbZJHNJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082AbZJHNJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 09:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758011AbZJHNJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 09:09:43 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:64685 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758009AbZJHNJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 09:09:43 -0400
From: Frans Pop <elendil@planet.nl>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for CPU"
Date: Thu, 8 Oct 2009 15:09:04 +0200
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
References: <200910051500.55875.elendil@planet.nl> <200910072034.57511.elendil@planet.nl> <1255001062.7500.1.camel@marge.simson.net>
In-Reply-To: <1255001062.7500.1.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910081509.05394.elendil@planet.nl>
X-OriginalArrivalTime: 08 Oct 2009 13:09:05.0693 (UTC) FILETIME=[838CACD0:01CA4818]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 October 2009, Mike Galbraith wrote:
> Care to try a patch?
>
> latencytop: only account on-runqueue wait time as being scheduler
> latency.
>
> Latencytop was accounting uninterruptible and interruptible sleep time
> up to 5ms, which is not the latency the user is looking for.  Account
> time waiting on-runqueue instead.  Also add a clock update to
> update_curr() for the case where there's nobody home.  When coming out
> of idle with NO_HZ, not updating the clock leads to bogus max latency
> report.

With this patch the high values for iwlagn and phy0 are gone. The values 
now match roughly with the output of your script.

If (un)interruptible sleep is worth displaying in latencytop then maybe it 
should be identified as a separate cause instead of lumped under "waiting 
for CPU"?

> TODO: Figure out where the heck empty braces come from.

I also see these lines with "[]" sometimes; looks to come from 'sleep'.

And I still see lines with only a "." as the cause; this seems specific to 
targets marked with the penguin (work queues?).

> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Arjan van de Ven <arjan@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>

If Arjan is happy with the patch, please add my:

Reported-and-tested-by: Frans Pop <elendil@planet.nl>

Thanks,
FJP
