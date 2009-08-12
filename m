Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbZHLIUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbZHLIUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbZHLIUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:20:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48712 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbZHLIUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:20:43 -0400
Date: Wed, 12 Aug 2009 10:13:52 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip 0/1] posix-cpu-timers: fix CPUCLOCK_{PROF,VIRT}
 periodic tics precision
Message-ID: <20090812101352.22569b5a@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <1250001100-3936-1-git-send-email-sgruszka@redhat.com>
References: <1250001100-3936-1-git-send-email-sgruszka@redhat.com>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009 16:31:39 +0200
Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> POSIX 1.b cpu timers where clockid is based on CPUCLOCK_PROF and CPUCLOCK_VIRT,
> have systematic timer error, the same as had itimers. Error can be showed by
> program [1]. Results for unpatched and patched kernel are below:
> 
> Unpatched kernel:
> 
> CLK_PROF
> Period 10000:	counted time 14.51 , real time 15.99 , error -9.2 %
> Period 9998:	counted time 15.95 , real time 15.96 , error -0.1 %
> Period 1000:	counted time 7.99 , real time 15.98 , error -50.0 %
> Period 11111:	counted time 14.77 , real time 15.96 , error -7.5 %
> Period 21315:	counted time 15.45 , real time 15.96 , error -3.1 %
> Period 1500:	counted time 11.98 , real time 15.98 , error -25.0 %
> Period 15000:	counted time 14.96 , real time 15.96 , error -6.3 %
> Period 50000:	counted time 15.60 , real time 15.95 , error -2.2 %
> Period 777777:	counted time 15.56 , real time 15.95 , error -2.5 %
> Period 212341:	counted time 15.71 , real time 15.95 , error -1.5 %
> Period 10001:	counted time 14.50 , real time 15.96 , error -9.1 %
> Period 1002:	counted time 8.01 , real time 15.98 , error -49.9 %
> Period 999000:	counted time 14.98 , real time 15.95 , error -6.1 %
> Period 2222:	counted time 11.83 , real time 15.97 , error -26.0 %
> Period 500:	counted time 8.01 , real time 16.02 , error -50.0 %
> CLK_VIRT
> Period 10000:	counted time 14.50 , real time 15.96 , error -9.2 %
> Period 9998:	counted time 15.95 , real time 15.96 , error -0.1 %
> Period 1000:	counted time 7.99 , real time 15.98 , error -50.0 %
> Period 11111:	counted time 14.77 , real time 15.97 , error -7.5 %
> Period 21315:	counted time 15.45 , real time 15.96 , error -3.2 %
> Period 1500:	counted time 11.99 , real time 15.99 , error -25.0 %
> Period 15000:	counted time 14.96 , real time 15.96 , error -6.3 %
> Period 50000:	counted time 15.60 , real time 15.96 , error -2.2 %
> Period 777777:	counted time 15.56 , real time 15.95 , error -2.5 %
> Period 212341:	counted time 15.71 , real time 15.96 , error -1.5 %
> Period 10001:	counted time 14.50 , real time 15.96 , error -9.1 %
> Period 1002:	counted time 8.01 , real time 15.99 , error -49.9 %
> Period 999000:	counted time 14.98 , real time 15.95 , error -6.1 %
> Period 2222:	counted time 11.83 , real time 15.98 , error -26.0 %
> Period 500:	counted time 8.01 , real time 16.01 , error -50.0 %
> 
> Patched kernel:
> 
> CLK_PROF
> Period 10000:	counted time 16.05 , real time 16.06 , error -0.1 %
> Period 9998:	counted time 16.30 , real time 16.30 , error -0.0 %
> Period 1000:	counted time 16.45 , real time 16.45 , error -0.0 %
> Period 11111:	counted time 15.99 , real time 16.00 , error -0.1 %
> Period 21315:	counted time 15.99 , real time 15.99 , error -0.1 %
> Period 1500:	counted time 16.03 , real time 16.03 , error -0.0 %
> Period 15000:	counted time 15.99 , real time 16.00 , error -0.0 %
> Period 50000:	counted time 15.95 , real time 15.99 , error -0.3 %
> Period 777777:	counted time 15.56 , real time 15.99 , error -2.7 %
> Period 212341:	counted time 16.35 , real time 16.37 , error -0.1 %
> Period 10001:	counted time 15.99 , real time 16.00 , error -0.0 %
> Period 1002:	counted time 16.05 , real time 16.05 , error -0.0 %
> Period 999000:	counted time 15.98 , real time 15.99 , error -0.1 %
> Period 2222:	counted time 16.02 , real time 16.02 , error -0.0 %
> Period 500:	counted time 8.02 , real time 16.05 , error -50.0 %
> CLK_VIRT
> Period 10000:	counted time 15.99 , real time 16.00 , error -0.1 %
> Period 9998:	counted time 16.02 , real time 16.03 , error -0.1 %
> Period 1000:	counted time 16.04 , real time 16.05 , error -0.1 %
> Period 11111:	counted time 15.99 , real time 16.00 , error -0.1 %
> Period 21315:	counted time 16.39 , real time 16.40 , error -0.1 %
> Period 1500:	counted time 16.02 , real time 16.03 , error -0.0 %
> Period 15000:	counted time 15.97 , real time 16.00 , error -0.1 %
> Period 50000:	counted time 15.95 , real time 16.00 , error -0.3 %
> Period 777777:	counted time 15.56 , real time 16.00 , error -2.8 %
> Period 212341:	counted time 16.14 , real time 16.34 , error -1.2 %
> Period 10001:	counted time 15.98 , real time 16.00 , error -0.1 %
> Period 1002:	counted time 16.04 , real time 16.05 , error -0.0 %
> Period 999000:	counted time 15.98 , real time 16.00 , error -0.1 %
> Period 2222:	counted time 16.01 , real time 16.02 , error -0.1 %
> Period 500:	counted time 8.02 , real time 16.05 , error -50.0 %
> 
> Even if probably nobody use these timers, I think we should fix them
> because we have this API in kernel and the timers perform bad. Patch
> is against Ingo's -tip (-sched-devel) tree where are my previous itmiers
> patches.

I tested my patch on ppc64 and sadly it is broken. I get this output
for patched kernel:

CLK_PROF
Period 10000:   counted time 46.24 , real time 41.63 , error 11.1 %
Period 9998:    counted time 46.24 , real time 41.63 , error 11.1 %
Period 1000:    counted time 42.01 , real time 42.50 , error -1.2 %
Period 11111:   counted time 45.72 , real time 41.63 , error 9.8 %
Period 21315:   counted time 43.65 , real time 41.62 , error 4.9 %
Period 1500:    counted time 63.26 , real time 42.48 , error 48.9 %
Period 15000:   counted time 44.53 , real time 41.59 , error 7.1 %
Period 50000:   counted time 42.40 , real time 41.58 , error 2.0 %
Period 777777:  counted time 41.22 , real time 41.57 , error -0.8 %
Period 212341:  counted time 41.62 , real time 41.57 , error 0.1 %
Period 10001:   counted time 46.22 , real time 41.62 , error 11.1 %
Period 1002:    counted time 42.52 , real time 42.46 , error 0.1 %
Period 999000:  counted time 40.96 , real time 41.63 , error -1.6 %
Period 2222:    counted time 76.01 , real time 42.31 , error 79.6 %
Period 500:     counted time 21.16 , real time 42.46 , error -50.2 %
CLK_VIRT
Period 10000:   counted time 45.68 , real time 41.65 , error 9.7 %
Period 9998:    counted time 45.66 , real time 41.77 , error 9.3 %
Period 1000:    counted time 41.89 , real time 42.40 , error -1.2 %
Period 11111:   counted time 45.17 , real time 41.63 , error 8.5 %
Period 21315:   counted time 43.10 , real time 41.60 , error 3.6 %
Period 1500:    counted time 63.10 , real time 42.57 , error 48.2 %
Period 15000:   counted time 44.04 , real time 41.62 , error 5.8 %
Period 50000:   counted time 41.90 , real time 41.61 , error 0.7 %
Period 777777:  counted time 40.44 , real time 41.62 , error -2.8 %
Period 212341:  counted time 41.19 , real time 41.60 , error -1.0 %
Period 10001:   counted time 45.66 , real time 41.64 , error 9.7 %
Period 1002:    counted time 41.74 , real time 42.52 , error -1.8 %
Period 999000:  counted time 40.96 , real time 41.70 , error -1.8 %
Period 2222:    counted time 75.50 , real time 42.32 , error 78.4 %
Period 500:     counted time 21.11 , real time 42.56 , error -50.4 %

Signals are generated more frequent than should. I guess I'm doing something
wrong with cputime_to_jiffies() and/or jiffies_to_cputime(), but as far I'm
not sure were the bug is.

Anyway, please forgot about the patch as long as I figure this out.
