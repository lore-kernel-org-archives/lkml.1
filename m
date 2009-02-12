Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbZBLISa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbZBLISa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 03:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbZBLISS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 03:18:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56126 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbZBLISR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 03:18:17 -0500
Date: Thu, 12 Feb 2009 09:18:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@tglx.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: Re: [Announce] 2.6.29-rc4-rt1
Message-ID: <20090212081801.GA22979@elte.hu>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <20090212005032.GA4788@nowhere> <20090212021257.GB4697@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212021257.GB4697@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> The first one, a lockdep warning:
> 
> [    2.975320]  [<ffffffff8077c7f5>] rt_spin_lock+0x85/0xb0
> [    2.975320]  [<ffffffff802f6823>] ? kfree+0x43/0xc0
> [    2.975320]  [<ffffffff802f6823>] kfree+0x43/0xc0
> [    2.975320]  [<ffffffff8027f2fd>] ? trace_hardirqs_off+0xd/0x10
> [    2.975320]  [<ffffffff8028a156>] generic_smp_call_function_single_interrupt+0x106/0x110
> [    2.975320]  [<ffffffff80227144>] smp_call_function_single_interrupt+0x24/0x40
> [    2.975320]  [<ffffffff80213223>] call_function_single_interrupt+0x13/0x20
> [    2.975320]  <EOI>  [<ffffffff8022df7b>] ? native_safe_halt+0xb/0x10
> [    2.975320]  [<ffffffff8022df79>] ? native_safe_halt+0x9/0x10
> [    2.975320]  [<ffffffff8021a93a>] ? default_idle+0x5a/0x60
> [    2.975320]  [<ffffffff8021136e>] ? cpu_idle+0x7e/0x100
> [    2.975320]  [<ffffffff80775b6c>] ? start_secondary+0x197/0x1eb

hm, that's a complex one - we do kfree() from IPI context, dunno why this
never triggered in our testing of -rt1.

> The second, a sysfs warning:
> 
> [    8.042459] ------------[ cut here ]------------
> [    8.054763] WARNING: at fs/sysfs/dir.c:462 sysfs_add_one+0x51/0x60()
> [    8.066777] Hardware name: AMILO Li 2727                  
> [    8.078555] sysfs: duplicate filename '14:4' can not be created

that should be harmless - unless you only get it under -rt1.

	Ingo
