Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbYBAOXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbYBAOXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 09:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbYBAOXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 09:23:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38934 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660AbYBAOXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 09:23:12 -0500
Date: Fri, 1 Feb 2008 15:22:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: sleepy linux self-test
Message-ID: <20080201142255.GA26232@elte.hu>
References: <20080130131748.GA3796@elf.ucw.cz> <20080130193626.GA15384@elte.hu> <20080130232606.GB5937@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130232606.GB5937@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> index b8b2de3..222d22d 100644
> --- a/kernel/power/sleepy.c
> +++ b/kernel/power/sleepy.c
> @@ -31,7 +31,8 @@ int ksleepyd(void *data)
>  {
>  	msleep(5000);
>  	while (1) {
> -		set_alarm(5);
> +		if (set_alarm(5))
> +			return -EFAULT;
>  		pm_suspend(PM_SUSPEND_MEM);
>  		msleep(500000);

could you send me a clean patch against mainline please? The above chunk 
didnt apply because there's no ksleepyd (only test_sleep()). Thanks,

	Ingo
