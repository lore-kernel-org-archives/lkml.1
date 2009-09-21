Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZIUHMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZIUHMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbZIUHMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:12:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:33798 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbZIUHMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:12:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,423,1249282800"; 
   d="scan'208";a="189772693"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "davem@davemloft.net" <davem@davemloft.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sachin Sant <sachinp@in.ibm.com>,
       "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
Date: Mon, 21 Sep 2009 08:12:12 +0100
Subject: RE: [PATCH] perf_counter/powerpc: Fix compilation after
   perf_counter_overflow change
Thread-Topic: [PATCH] perf_counter/powerpc: Fix compilation after
   perf_counter_overflow change
Thread-Index: Aco6hwYcsAADLPU5RWeJbKdOGGqGtwAAwSpw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC69BA5E0@irsmsx504.ger.corp.intel.com>
References: <19127.8400.376239.586120@drongo.ozlabs.ibm.com>
In-Reply-To: <19127.8400.376239.586120@drongo.ozlabs.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Paul Mackerras [mailto:paulus@samba.org]
>Sent: Monday, September 21, 2009 8:45 AM


>Markus, please take care in future to mention it in the changelog if
>your patches touch definitions used by other architectures.  If you
>could go so far as to use grep a bit more and fix up other
>architectures' callsites for the things you're changing, that would be
>very much appreciated.  Thanks.

I'm sorry I missed that.

There's one more place in arch/sparc/.
The below patch should fix it, but I have no means to test it.

Index: b/arch/sparc/kernel/perf_counter.c
===================================================================
--- a/arch/sparc/kernel/perf_counter.c
+++ b/arch/sparc/kernel/perf_counter.c
@@ -493,7 +493,6 @@ static int __kprobes perf_counter_nmi_ha
 
 	regs = args->regs;
 
-	data.regs = regs;
 	data.addr = 0;
 
 	cpuc = &__get_cpu_var(cpu_hw_counters);
@@ -513,7 +512,7 @@ static int __kprobes perf_counter_nmi_ha
 		if (!sparc_perf_counter_set_period(counter, hwc, idx))
 			continue;
 
-		if (perf_counter_overflow(counter, 1, &data))
+		if (perf_counter_overflow(counter, 1, &data, regs))
 			sparc_pmu_disable_counter(hwc, idx);
 	}


thanks and regards,
markus.

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

