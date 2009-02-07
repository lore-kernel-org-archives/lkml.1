Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbZBGCeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbZBGCeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 21:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZBGCeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 21:34:04 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:58535 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbZBGCeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 21:34:03 -0500
To: frederik.deweerdt@xprog.eu, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: [Bug #12409] NULL pointer dereference at get_stats()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
	<cX2gZ6Cy9nC.A.N0B.pJRdJB@chimera>
	<20090121161828.GA2739@gambetta>
In-Reply-To: <20090121161828.GA2739@gambetta>
Message-Id: <200902071133.AJJ09378.MOHLFFtOSOVQFJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 7 Feb 2009 11:34:00 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Mon, Jan 19, 2009 at 10:45:43PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12409
> Subject		: NULL pointer dereference at get_stats()
> Submitter	: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Date		: 2008-12-30 12:53 (21 days old)
> References	: http://marc.info/?l=linux-kernel&m=123064167008695&w=4
> Handled-By	: Frederik Deweerdt <frederik.deweerdt@xprog.eu>

This bug happens when "nolapic" option is given.
This bug exists in 2.6.27.15 and 2.6.28.4 .
This bug does not exist in 2.6.26.8 and 2.6.29-rc3-git10 .

How to reproduce:
(1) Prepare x86 machine with 2 cpus.
(2) Add "nolapic" and "init=/bin/sh" options at the kernel command line.
(3) Do "cat /sys/class/net/lo/statistics/rx_packets".

If you apply a patch at http://lkml.org/lkml/2009/1/5/557 , you will notice
"lb_stats == NULL for CPU 1" message.
I think "nolapic" option causes for_each_possible_cpu() to reach CPU 1
by some error.

Frederik Deweerdt wrote:
> Hello Rafael,
> 
> Not sure what the status should be for that one, it sure seems vmware
> related, and I don't have one handy.
> 
> Regards,
> Frederik

I think this bug will happen in native environment too.
http://lkml.org/lkml/2009/1/4/349
But due to driver initialization failure caused by "nolapic" option,
I can't reach /sbin/init on native ThinkPad X60 environment.

Regards.
