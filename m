Return-Path: <linux-kernel-owner+w=401wt.eu-S1759701AbYD3GEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701AbYD3GEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 02:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369AbYD3GEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 02:04:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40362 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757293AbYD3GEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 02:04:36 -0400
Date: Wed, 30 Apr 2008 08:04:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] x86: fix remove cpu_pda table patch
Message-ID: <20080430060417.GA2408@elte.hu>
References: <20080428210906.348866000@polaris-admin.engr.sgi.com> <20080428214541.GA16153@elte.hu> <48175CF8.4010105@sgi.com> <48176EA6.8060506@sgi.com> <20080429214401.GB2302@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429214401.GB2302@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Mike Travis <travis@sgi.com> wrote:
> 
> > -	prev_nmi_count = kmalloc(NR_CPUS * sizeof(int), GFP_KERNEL);
> > +	prev_nmi_count = kmalloc(nr_cpu_ids * sizeof(int), GFP_KERNEL);
> 
> yeah, that makes sense ... i'll reinstate your patches and check.

they crashed after about 3 randconfig iterations with:

  early res: 4 [8000-afff] PGTABLE
  early res: 5 [b000-b87f] MEMNODEMAP
PANIC: early exception 0e rip 10:ffffffff8077a150 error 2 cr2 37
Pid: 0, comm: swapper Not tainted 2.6.25-sched-devel.git-x86-latest.git #14

Call Trace:
 [<ffffffff81466196>] early_idt_handler+0x56/0x6a
 [<ffffffff8077a150>] ? numa_set_node+0x30/0x60
 [<ffffffff8077a129>] ? numa_set_node+0x9/0x60
 [<ffffffff8147a543>] numa_init_array+0x93/0xf0
 [<ffffffff8147b039>] acpi_scan_nodes+0x3b9/0x3f0
 [<ffffffff8147a496>] numa_initmem_init+0x136/0x150
 [<ffffffff8146da5f>] setup_arch+0x48f/0x700
 [<ffffffff802566ea>] ? clockevents_register_notifier+0x3a/0x50
 [<ffffffff81466a87>] start_kernel+0xd7/0x440
 [<ffffffff81466422>] x86_64_start_kernel+0x222/0x280

RIP 0x10


 http://redhat.com/~mingo/misc/log-Wed_Apr_30_00_28_09_CEST_2008.bad
 http://redhat.com/~mingo/misc/config-Wed_Apr_30_00_28_09_CEST_2008.bad

	Ingo
