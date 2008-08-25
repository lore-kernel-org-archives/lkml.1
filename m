Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbYHYLfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbYHYLfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 07:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYHYLfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 07:35:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:52123 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbYHYLfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 07:35:10 -0400
Subject: Re: [BUG] cpufreq: constant cpu_khz
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: cpufreq@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       davej <davej@codemonkey.org.uk>
In-Reply-To: <1219646032.20732.10.camel@twins>
References: <1219646032.20732.10.camel@twins>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 13:35:06 +0200
Message-Id: <1219664106.8515.50.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-25 at 08:33 +0200, Peter Zijlstra wrote:
> Hi,
> 
> 
> I noticed that my sched_clock() was slow on a number of machine, so I
> started looking at cpufreq.

The below seems to fix the problem for me, but I don't have enough clue
to know if its the correct fix, please advise.

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 46af716..2f10f8c 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -314,7 +319,7 @@ static int time_cpufreq_notifier(struct
notifier_block *nb, unsigned long val,
 			mark_tsc_unstable("cpufreq changes");
 	}
 
-	set_cyc2ns_scale(tsc_khz_ref, freq->cpu);
+	set_cyc2ns_scale(tsc_khz, freq->cpu);
 
 	return 0;
 }


