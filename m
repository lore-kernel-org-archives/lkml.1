Return-Path: <linux-kernel-owner+w=401wt.eu-S1758387AbYGAJdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387AbYGAJdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 05:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYGAJc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 05:32:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44040 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043AbYGAJcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 05:32:54 -0400
Date: Tue, 1 Jul 2008 11:31:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] CFS vs cpu hotplug
Message-ID: <20080701093124.GC31309@elte.hu>
References: <20080619161949.GA11062@osiris.ibm.com> <b647ffbd0806251512i3ab6efedv75a5bddd865ef618@mail.gmail.com> <b647ffbd0806281516i57392230idf06f99ff02d22cf@mail.gmail.com> <20080630090744.GB6598@osiris.boeblingen.de.ibm.com> <20080630091711.GA26637@elte.hu> <4869F770.6050103@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4869F770.6050103@cn.fujitsu.com>
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


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> The following oops still occurred whether this patch is applied or not.

>  [<ffffffff8059372c>] notifier_call_chain+0x33/0x5b
>  [<ffffffff802476a9>] __raw_notifier_call_chain+0x9/0xb
>  [<ffffffff802476ba>] raw_notifier_call_chain+0xf/0x11
>  [<ffffffff805736d6>] _cpu_down+0x191/0x256
>  [<ffffffff805737c1>] cpu_down+0x26/0x36
>  [<ffffffff805749c1>] store_online+0x32/0x75
>  [<ffffffff803d1982>] sysdev_store+0x24/0x26
>  [<ffffffff802d2551>] sysfs_write_file+0xe0/0x11c
>  [<ffffffff80290e6b>] vfs_write+0xae/0x137
>  [<ffffffff802913d3>] sys_write+0x47/0x70
>  [<ffffffff8020b1eb>] system_call_after_swapgs+0x7b/0x80

hm, there were multiple problems in this area and a lot of dormant bugs. 
Do you have this recent upstream commit in your tree:

| commit fcb43042ef55d2f46b0efa5d7746967cef38f056
| Author: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
| Date:   Tue Jun 24 16:06:23 2008 +0800
|
|    x86: fix cpu hotplug crash
|
|    Vegard Nossum reported crashes during cpu hotplug tests:
|
|      http://marc.info/?l=linux-kernel&m=121413950227884&w=4

?

	Ingo
