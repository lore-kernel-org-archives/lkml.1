Return-Path: <linux-kernel-owner+w=401wt.eu-S1422811AbXCOFjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422811AbXCOFjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422813AbXCOFjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:39:20 -0400
Received: from mail26.syd.optusnet.com.au ([211.29.133.167]:46273 "EHLO
	mail26.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422811AbXCOFjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:39:19 -0400
From: Con Kolivas <kernel@kolivas.org>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: RSDL v0.30 cpu scheduler for mainline kernels
Date: Thu, 15 Mar 2007 17:05:13 +1100
User-Agent: KMail/1.9.5
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
References: <200703121058.11966.kernel@kolivas.org> <20070315023102.GL30596@linux-os.sc.intel.com>
In-Reply-To: <20070315023102.GL30596@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703151705.13761.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 March 2007 13:31, Siddha, Suresh B wrote:
> Con,
>
> On Mon, Mar 12, 2007 at 10:58:11AM +1100, Con Kolivas wrote:
> > There are updated patches for 2.6.20, 2.6.20.2, 2.6.21-rc3 and
> > 2.6.21-rc3-mm2 to bring RSDL up to version 0.30 for download here:
>
> I tried this on a Core 2 Quad cpu system(system has 4 cores on a single
> package). When I run SPECjbb2000 with number of threads varying from 1-8,
> I see ~4.5% perf regression with RSDL (compared to native 2.6.21-rc3) in
> the 8 threads case. This I think, is coming from increased number of
> context switches, when we have more than one thread(at same user priority)
> on the same logical cpu.
>
> Just to see the % increase in number of context switches, I ran 8 infinite
> loops (simple while(1); 's) and with 2.6.21-rc3 I see ~70 context switches
> every second, whereas with RSDL I see ~530 context switches.

Thanks. If it's just that then scaling rr interval with cpus somewhat would
help. If you could, the following patch just to test might confirm that.

---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-rc3-mm2/kernel/sched.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/kernel/sched.c	2007-03-15 17:03:17.000000000 +1100
+++ linux-2.6.21-rc3-mm2/kernel/sched.c	2007-03-15 17:03:30.000000000 +1100
@@ -104,7 +104,7 @@ unsigned long long __attribute__((weak))
  * This is the time all tasks within the same priority round robin.
  * Set to a minimum of 6ms.
  */
-#define RR_INTERVAL		((6 * HZ / 1001) + 1)
+#define RR_INTERVAL		((12 * HZ / 1001) + 1)
 #define DEF_TIMESLICE		(RR_INTERVAL * 20)
 
 #ifdef CONFIG_SMP

-- 
-ck
