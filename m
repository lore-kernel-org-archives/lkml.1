Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYGQJRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYGQJRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 05:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYGQJRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 05:17:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:57587 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbYGQJRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:17:12 -0400
Subject: Re: Large increase in context switch rate
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Alex Nixon (Intern)" <Alex.Nixon@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>
In-Reply-To: <487E43D9.7080703@goop.org>
References: <487E43D9.7080703@goop.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 11:17:30 +0200
Message-Id: <1216286250.5232.67.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 11:54 -0700, Jeremy Fitzhardinge wrote:
> Hi Ingo,
> 
> We have Alex Nixon doing some profiling of Xen kernels, comparing 
> current pvops Xen and native with the last "official" Xen kernel 
> 2.6.18.8-xen.
> 
> One obvious difference is that the kernbench context switch rate is way 
> up, from about 30k to 110k.  Also, the user time went up from about 375s 
> to 390s - and that's comparing pvops native to 2.6.18.8-xen (pvops Xen 
> was more or less identical).
> 
> I wonder if the user time increase is related to the context switch 
> rate, because the actual context switch time itself is accounted to the 
> process, or because of secondary things like cache and tlb misses.  Or 
> perhaps the new scheduler accounts for things differently?
> 
> Anyway, I'm wondering:
> 
>     * is the increased context switch rate expected?
>     * what tunables are there so we can try and make them have
>       comparable context switch rates?
> 
> This is an issue because the Xen/pvops kernel is showing a fairly large 
> overall performance regression, and the context switches a specifically 
> slow compared to the old Xen kernel, and the high switch rate is 
> presumably compounding the problem.  It would be nice to have some knobs 
> to turn to see what the underlying performance characteristics are.

Is this specific to Xen?, as a native kernel doesn't do more than ~3k
cs/s with make -j3 on my dual core.



