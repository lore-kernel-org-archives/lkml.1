Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbZEKPlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbZEKPlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbZEKPkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:40:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36110 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbZEKPkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:40:52 -0400
Date: Mon, 11 May 2009 17:40:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/xen] x86: use flush_tlb_others to implement
	flush_tlb_all, fix
Message-ID: <20090511154034.GA30361@elte.hu>
References: <1241797927.15972.51.camel@zakaz.uk.xensource.com> <tip-636afdbe85d50d9b88f5283b5e6d0f8518431aac@git.kernel.org> <20090511131230.GA32693@elte.hu> <1242054041.29990.88.camel@zakaz.uk.xensource.com> <20090511151151.GA3267@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511151151.GA3267@elte.hu>
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


sigh:

BUG: using smp_processor_id() in preemptible [00000000] code: S99local/1903
caller is flush_tlb_others_ipi+0x1b/0xc0
Pid: 1903, comm: S99local Not tainted 
2.6.30-rc5-tip-01485-g1304846-dirty #40905
Call Trace:
 [<40a9e184>] ? printk+0x1d/0x1f
 [<4066d2e6>] debug_smp_processor_id+0xc6/0xd0
 [<40422dab>] flush_tlb_others_ipi+0x1b/0xc0
 [<40422e5d>] native_flush_tlb_others+0xd/0x10
 [<40422ea9>] flush_tlb_all+0x19/0x60
 [<4041e972>] zap_low_mappings+0x52/0x60
 [<40a9b080>] native_cpu_up+0x156/0x220
 [<40a9ca42>] _cpu_up+0xb0/0x151
 [<40a9cb66>] cpu_up+0x83/0x8d
 [<40a68b90>] store_online+0x60/0xa0
 [<40a68b30>] ? store_online+0x0/0xa0
 [<4072ed8a>] sysdev_store+0x2a/0x40
 [<40522511>] sysfs_write_file+0xa1/0xf0
 [<404d9d44>] vfs_write+0xa4/0x130
 [<4065fcec>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<40522470>] ? sysfs_write_file+0x0/0xf0
 [<404d9ea2>] sys_write+0x42/0x70
 [<40403bc8>] sysenter_do_call+0x12/0x3c
CPU0 attaching NULL sched-domain.

	Ingo
