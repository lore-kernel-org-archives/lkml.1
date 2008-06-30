Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbYF3LZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbYF3LZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 07:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756640AbYF3LZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 07:25:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35947 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756778AbYF3LZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 07:25:01 -0400
Date: Mon, 30 Jun 2008 13:19:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Mike Travis <travis@sgi.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Adrian Bunk <bunk@kernel.org>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer
	dereference
Message-ID: <20080630111907.GA16669@elte.hu>
References: <20080622125633.GA8166@damson.getinternet.no> <200806241136.52430.rusty@rustcorp.com.au> <1214294783.25608.75.camel@ymzhang> <200806242314.51656.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200806242314.51656.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Tuesday 24 June 2008 18:06:23 Zhang, Yanmin wrote:

> > In function _cpu_up, the panic happens when calling 
> > __raw_notifier_call_chain at the second time. Kernel doesn't panic 
> > when calling it at the first time. If just say because ﻿of 
> > nr_cpu_ids, that's not right.
> >
> > By checking source codes, I find function do_boot_cpu is the 
> > culprit. Consider below call chain:
> >  _cpu_up=>__cpu_up=>smp_ops.cpu_up=>native_cpu_up=>do_boot_cpu.
> >
> > So ﻿do_boot_cpu is called in the end. In ﻿do_boot_cpu, if 
> > boot_error==true, cpu_clear(cpu, cpu_possible_map) is executed. So 
> > later on, when ﻿_cpu_up calls ﻿__raw_notifier_call_chain at the second 
> > time to report CPU_UP_CANCELED, because this cpu is already cleared 
> > from ﻿cpu_possible_map, get_cpu_sysdev returns NULL.
> >
> > Many resources are related to ﻿cpu_possible_map, so it's better not to
> > change it.
> >
> > Below patch against 2.6.26-rc7 fixes it by removing the bit clearing in
> > ﻿cpu_possible_map.
> >
> > Vegard, would you like to help test it?
> >
> > ﻿﻿﻿Signed-off-by: Zhang Yanmin ﻿<yanmin_zhang@linux.intel.com>
[...]

> Nice catch.  Basically, cpu_possible_map should only be cleared at 
> boot, and probably not even then.
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

applied to tip/x86/urgent for v2.6.26 merging - thanks everyone!

	Ingo
