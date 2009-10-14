Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbZJNR5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbZJNR5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 13:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbZJNR5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:57:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46658 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbZJNR5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:57:04 -0400
Date: Wed, 14 Oct 2009 19:56:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: x86@kernel.org, yinghai@kernel.org, macro@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] x86,apic: limit apic dumping, introduce show_lapic
	setup option
Message-ID: <20091014175616.GA3403@elte.hu>
References: <20091013200702.019870576@openvz.org> <20091013201022.926793122@openvz.org> <20091014071217.GL784@elte.hu> <20091014150904.GA5259@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014150904.GA5259@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


btw., i'm getting this warning on a test-box:

[    0.290000] Initializing cgroup subsys net_cls
[    0.300000] ------------[ cut here ]------------
[    0.300000] WARNING: at arch/x86/kernel/apic/apic_noop.c:42 warn_apic_enabled+0x5d/0x80()
[    0.310000] Hardware name: System Product Name
[    0.320000] APIC: Called for NOOP operation with apic enabled
[    0.320000] Modules linked in:
[    0.330000] Pid: 0, comm: swapper Not tainted 2.6.32-rc4-tip-01511-g59b4c9d-dirty #1741
[    0.330000] Call Trace:
[    0.340000]  [<79061fa5>] warn_slowpath_common+0x65/0xa0
[    0.340000]  [<7903d84d>] ? warn_apic_enabled+0x5d/0x80
[    0.350000]  [<7906203f>] warn_slowpath_fmt+0x2f/0x50
[    0.350000]  [<7903d84d>] warn_apic_enabled+0x5d/0x80
[    0.360000]  [<7903da96>] noop_default_phys_pkg_id+0x16/0x30
[    0.360000]  [<79af1514>] generic_identify+0xa3/0x176
[    0.370000]  [<79af165f>] identify_cpu+0x78/0x1fd
[    0.370000]  [<792c8d7d>] ? __init_rwsem+0x4d/0x70
[    0.380000]  [<79abcb54>] identify_boot_cpu+0xd/0x1e
[    0.380000]  [<79abcdae>] check_bugs+0x16/0xe5
[    0.390000]  [<79ab6b39>] start_kernel+0x31d/0x342
[    0.390000]  [<79ab60aa>] i386_start_kernel+0xaa/0xc2
[    0.400000] ---[ end trace a7919e7f17c0a725 ]---
[    0.400000] Checking 'hlt' instruction... OK.
[    0.440000] SMP alternatives: switching to UP code
[    0.450000] debug: unmapping init memory 79c7a000..79c80000

noop_default_phys_pkg_id() should return 0 i guess, and not generate a 
warning?

	Ingo
