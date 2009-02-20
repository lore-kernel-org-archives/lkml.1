Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbZBTV66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbZBTV66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 16:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbZBTV6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 16:58:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41833 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbZBTV6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 16:58:48 -0500
Date: Fri, 20 Feb 2009 22:58:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Philippe Grenard <philippe.grenard@laposte.net>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, John Stoffel <john@stoffel.org>
Subject: Re: PROBLEM: cannot get stable system since 2.6.28 kernel (amd64)
Message-ID: <20090220215830.GB30665@elte.hu>
References: <200902131944.56634.philippe.grenard@laposte.net> <200902161925.40256.philippe.grenard@laposte.net> <18842.16695.145336.851447@stoffel.org> <200902202108.55332.philippe.grenard@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902202108.55332.philippe.grenard@laposte.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Philippe Grenard <philippe.grenard@laposte.net> wrote:

> dc1e35c6e95e8923cf1d3510438b63c600fee1e2 is first bad commit
> commit dc1e35c6e95e8923cf1d3510438b63c600fee1e2
> Author: Suresh Siddha <suresh.b.siddha@intel.com>
> Date:   Tue Jul 29 10:29:19 2008 -0700
>
>     x86, xsave: enable xsave/xrstor on cpus with xsave support
[...]
> A bit of googling gave me this :
> http://lkml.org/lkml/2009/1/19/161 
> which exactly corresponds to my problem with 2.6.28 !
> 
> A "solution" proposed was to try to check the bios setting 
> "cpuid value limit" and disable it if enabled. This did help 
> me to boot 2.6.28 or previously failing kernel compiled during 
> git-bisect, but gave me the "random freeze" any way....

Note that the workaround for that BIOS bug is already in the 
latest upstream kernel, i.e. in 2.6.29-rc5.

Could you please try -rc5, whether it works out of box?

If you still see freezes, could you try the "nofxsr" boot 
option? That will turn off the new FPU code both in the hw and 
in the kernel.

	Ingo
