Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbZJZLi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbZJZLi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 07:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbZJZLi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 07:38:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48136 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbZJZLiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 07:38:24 -0400
Date: Mon, 26 Oct 2009 12:38:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: nooiwa <nooiwa@miraclelinux.com>
Cc: roland@redhat.com, akpm@linux-foundation.org, oleg@redhat.com,
       LKML <linux-kernel@vger.kernel.org>, h-shimamoto@ct.jp.nec.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] show message when exceeded rlimit of pending signals
Message-ID: <20091026113800.GA9503@elte.hu>
References: <4AE1804A.2050404@miraclelinux.com> <20091023114600.GG5886@elte.hu> <4AE2A6A1.1070904@miraclelinux.com> <4AE2C151.8070006@miraclelinux.com> <20091024085848.GA23215@elte.hu> <4AE57745.8080701@miraclelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE57745.8080701@miraclelinux.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* nooiwa <nooiwa@miraclelinux.com> wrote:

> +++ b/kernel/sysctl.c
> @@ -67,6 +67,7 @@ static int deprecated_sysctl_warning(struct __sysctl_args *args);
>  /* External variables not in a header file. */
>  extern int C_A_D;
>  extern int print_fatal_signals;
> +extern int print_reach_rlimit_sigpending;

Ooiwa-san, Roland, Andrew - what do you think about just making this 
part of the existing print_fatal_signals flag, instead of adding a new 
one?

Signal queue overflows are a 'fatal', signal-related condition as well - 
we lose a signal in essence. The patch would be smaller as well.

	Ingo
