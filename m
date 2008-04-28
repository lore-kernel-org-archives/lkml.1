Return-Path: <linux-kernel-owner+w=401wt.eu-S936528AbYD1VqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936528AbYD1VqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934434AbYD1Vp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:45:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46051 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933398AbYD1Vp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:45:58 -0400
Date: Mon, 28 Apr 2008 23:45:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] x86: fix remove cpu_pda table patch
Message-ID: <20080428214541.GA16153@elte.hu>
References: <20080428210906.348866000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428210906.348866000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Mike Travis <travis@sgi.com> wrote:

> [Ingo - please replace "PATCH 07/11" with this one.]
> 
>     *	Remove 544k bytes from the kernel by removing the boot_cpu_pda
> 	array from the data section and allocating it during startup.
> 
> 	Fixed panic in setup_per_cpu_areas when HOTPLUG_CPU not set.
> 
> For inclusion into sched-devel/latest tree.

sched-devel.git randconfig testing found another crash with your queue:

[    0.111060] Brought up 1 CPUs
[    0.111986] Total of 1 processors activated (4022.73 BogoMIPS).
[    0.112987] Testing NMI watchdog ... <1>BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
[    0.114982] IP: [<ffffffff8180d4a0>] check_nmi_watchdog+0xb0/0x210
[    0.114982] PGD 0
[    0.114982] Oops: 0000 [1] SMP
[    0.114982] CPU 0
[............]

 http://redhat.com/~mingo/misc/config-Mon_Apr_28_23_25_25_CEST_2008.bad
 http://redhat.com/~mingo/misc/log-Mon_Apr_28_23_25_25_CEST_2008.bad

	Ingo
