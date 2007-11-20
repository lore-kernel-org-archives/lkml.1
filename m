Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbXKTGN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbXKTGN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbXKTGNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:13:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47326 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbXKTGNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:13:14 -0500
Date: Tue, 20 Nov 2007 07:13:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David <david@livux.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3,
	v2.6.23.8,v2.6.22.13, v2.6.21.7
Message-ID: <20071120061302.GH20436@elte.hu>
References: <200711191925.12072.david@livux.com> <200711192051.44095.david@livux.com> <20071119205000.GB25142@elte.hu> <200711192239.51301.david@livux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200711192239.51301.david@livux.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David <david@livux.com> wrote:

> El Lunes, 19 de Noviembre de 2007, Ingo Molnar escribió:
> > * David <david@livux.com> wrote:
> > > I have removed all other patches, and applied only cfs v24 above
> > > 2.6.23.8, and the compiler ran into (with CONFIG_FAIR_GROUP_SCHED
> > > enabled):
> >
> > does the patch below help?
> >
> > 	Ingo
> 
> Yes, now sched.c compile without errors, but linking fails at:
> 
> 
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> kernel/built-in.o:(.data+0x4a8): undefined reference to `sysctl_sched_min_bal_int_shares'
> kernel/built-in.o:(.data+0x4d4): undefined reference to `sysctl_sched_max_bal_int_shares'
> make: *** [.tmp_vmlinux1] Error 1

does the patch below do the trick?

	Ingo

Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -309,7 +309,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 644,
 		.proc_handler	= &proc_dointvec,
 	},
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_min_bal_int_shares",
