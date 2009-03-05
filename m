Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbZCESdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbZCESdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 13:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZCESdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 13:33:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:46398 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbZCESdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 13:33:08 -0500
Subject: Re: [PATCH] perfcounters: IRQ and NMI support on AMD CPUs
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1236273633.5187.286.camel@laptop>
References: <1236273633.5187.286.camel@laptop>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 00:02:39 +0530
Message-Id: <1236277959.3316.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

Ahh, so that day you was getting triple fault in this ?

On Thu, 2009-03-05 at 18:20 +0100, Peter Zijlstra wrote:
> Subject: perfcounters: IRQ and NMI support on AMD CPUs
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu Mar 05 18:08:27 CET 2009
> 
> The below completes the K7+ performance counter support.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/kernel/cpu/perf_counter.c |  272 +++++++++++++++++++++++++++++++------
>  1 file changed, 228 insertions(+), 44 deletions(-)
> 

It was in my TODO list, but I am glad that you finished it :-)

Any how with this patch on my 64 bit AMD box I am getting:

[jaswinder@hpdv5 perfcounters]$ ./perfstat -e 0,1,2,3 ls > /dev/null 

 Performance counter stats for 'ls':

perfstat: perfstat.c:415: main: Assertion `res == sizeof(single_count)'
failed.
Aborted
[jaswinder@hpdv5 perfcounters]$ 

[root@hpdv5 perfcounters]# ./kerneltop 
KernelTop refresh period: 2 seconds
kerneltop: kerneltop.c:883: main: Assertion `res == sizeof(ip)' failed.
Aborted
[root@hpdv5 perfcounters]#

Thanks,
--
JSR


