Return-Path: <linux-kernel-owner+w=401wt.eu-S1762842AbXKIMgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762842AbXKIMgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 07:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbXKIMgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 07:36:17 -0500
Received: from web32607.mail.mud.yahoo.com ([68.142.207.234]:31804 "HELO
	web32607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753363AbXKIMgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 07:36:16 -0500
X-YMail-OSG: T1yG5HkVM1kZtVof9uttRNDgqkwDpzcaJUE2uYqnmcAuy8FJyZWq_t8rJk1R1Aoa6zd02ERXDiubCyQ3YmmNEQT18w--
X-Mailer: YahooMailRC/818.27 YahooMailWebService/0.7.152
Date: Fri, 9 Nov 2007 04:36:14 -0800 (PST)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: iozone write 50% regression in kernel 2.6.24-rc1
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, a.p.zijlstra@chello.nl
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <337294.80877.qm@web32607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----
> From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
> To: a.p.zijlstra@chello.nl
> Cc: LKML <linux-kernel@vger.kernel.org>
> Sent: Friday, November 9, 2007 10:47:52 AM
> Subject: iozone write 50% regression in kernel 2.6.24-rc1
> 
> Comparing with 2.6.23, iozone sequential write/rewrite (512M) has
> 50%
> 
 regression
> in kernel 2.6.24-rc1. 2.6.24-rc2 has the same regression.
> 
> My machine has 8 processor cores and 8GB memory.
> 
> By bisect, I located patch
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=
> 04fbfdc14e5f48463820d6b9807daa5e9c92c51f.
> 
> 
> Another behavior: with kernel 2.6.23, if I run iozone for many
> times
> 
 after rebooting machine,
> the result looks stable. But with 2.6.24-rc1, the first run of
> iozone
> 
 got a very small result and
> following run has 4Xorig_result.
> 
> What I reported is the regression of 2nd/3rd run, because first run
> has
> 
 bigger regression.
> 
> I also tried to change
> /proc/sys/vm/dirty_ratio,dirty_backgroud_ratio
> 
 and didn't get improvement.
> 
> -yanmin
> -
Hi Yanmin,

 could you tell us the exact iozone command you are using? I would like to repeat it on my setup, because I definitely see the opposite behaviour in 2.6.24-rc1/rc2. The speed there is much better than in 2.6.22 and before (I skipped 2.6.23, because I was waiting for the per-bdi changes). I definitely do not see the difference between 1st and subsequent runs. But then, I do my tests with 5GB file sizes like:

iozone3_283/src/current/iozone -t 5 -F /scratch/X1 /scratch/X2 /scratch/X3 /scratch/X4 /scratch/X5 -s 5000M -r 1024 -c -e -i 0 -i 1

Kind regards
Martin



