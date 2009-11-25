Return-Path: <linux-kernel-owner+w=401wt.eu-S934801AbZKYRQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934801AbZKYRQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933774AbZKYRQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:16:48 -0500
Received: from bar.sig21.net ([80.81.252.164]:36449 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934784AbZKYRQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:16:45 -0500
Date: Wed, 25 Nov 2009 18:16:46 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: latencytop vs. SCHED_DEBUG log spamming
Message-ID: <20091125171646.GA20163@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.052,BAYES_05=-1.11 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

a minor issue I noticed on a Samsung N130 (Atom N270):

I enabled CONFIG_LATENCYTOP which selects CONFIG_SCHED_DEBUG.
When the netbook is running on battery the BIOS apparently
changes the available C-states frequently (or something like that),
which causes the log to spammed with messages like:

[ 2126.226152] Monitor-Mwait will be used to enter C-3 state
[ 2126.269062] CPU0 attaching NULL sched-domain.
[ 2126.269078] CPU1 attaching NULL sched-domain.
[ 2126.280191] CPU0 attaching sched-domain:
[ 2126.280222]  domain 0: span 0-1 level SIBLING
[ 2126.280238]   groups: 0 (cpu_power = 589) 1 (cpu_power = 589)
[ 2126.280272]   domain 1: span 0-1 level MC
[ 2126.280286]    groups: 0-1 (cpu_power = 1178)
[ 2126.280313] CPU1 attaching sched-domain:
[ 2126.280325]  domain 0: span 0-1 level SIBLING
[ 2126.280339]   groups: 1 (cpu_power = 589) 0 (cpu_power = 589)
[ 2126.280370]   domain 1: span 0-1 level MC
[ 2126.280384]    groups: 0-1 (cpu_power = 1178)
[ 2126.471828] CPU0 attaching NULL sched-domain.
[ 2126.471842] CPU1 attaching NULL sched-domain.
[ 2126.480353] CPU0 attaching sched-domain:
[ 2126.480368]  domain 0: span 0-1 level SIBLING
[ 2126.480381]   groups: 0 (cpu_power = 589) 1 (cpu_power = 589)
[ 2126.480406]   domain 1: span 0-1 level MC
[ 2126.480416]    groups: 0-1 (cpu_power = 1178)
[ 2126.480438] CPU1 attaching sched-domain:
[ 2126.480447]  domain 0: span 0-1 level SIBLING
[ 2126.480457]   groups: 1 (cpu_power = 589) 0 (cpu_power = 589)
[ 2126.480481]   domain 1: span 0-1 level MC
[ 2126.480491]    groups: 0-1 (cpu_power = 1178)
[ 2129.784288] CPU0 attaching NULL sched-domain.
[ 2129.784301] CPU1 attaching NULL sched-domain.
[ 2129.796112] CPU0 attaching sched-domain:
[ 2129.796122]  domain 0: span 0-1 level SIBLING
[ 2129.796131]   groups: 0 (cpu_power = 589) 1 (cpu_power = 589)
[ 2129.796148]   domain 1: span 0-1 level MC
[ 2129.796155]    groups: 0-1 (cpu_power = 1178)
[ 2129.796169] CPU1 attaching sched-domain:
[ 2129.796175]  domain 0: span 0-1 level SIBLING
[ 2129.796182]   groups: 1 (cpu_power = 589) 0 (cpu_power = 589)
[ 2129.796198]   domain 1: span 0-1 level MC
[ 2129.796204]    groups: 0-1 (cpu_power = 1178)
[ 2319.551963] CPU0 attaching NULL sched-domain.
[ 2319.551976] CPU1 attaching NULL sched-domain.
[ 2319.561358] CPU0 attaching sched-domain:
[ 2319.561370]  domain 0: span 0-1 level SIBLING
[ 2319.561380]   groups: 0 (cpu_power = 589) 1 (cpu_power = 589)
[ 2319.561401]   domain 1: span 0-1 level MC
[ 2319.561409]    groups: 0-1 (cpu_power = 1178)
[ 2319.561426] CPU1 attaching sched-domain:
[ 2319.561433]  domain 0: span 0-1 level SIBLING
[ 2319.561442]   groups: 1 (cpu_power = 589) 0 (cpu_power = 589)
[ 2319.561460]   domain 1: span 0-1 level MC
[ 2319.561468]    groups: 0-1 (cpu_power = 1178)
[ 2338.499309] CPU0 attaching NULL sched-domain.
[ 2338.499324] CPU1 attaching NULL sched-domain.
[ 2338.508161] CPU0 attaching sched-domain:
[ 2338.508174]  domain 0: span 0-1 level SIBLING
[ 2338.508184]   groups: 0 (cpu_power = 589) 1 (cpu_power = 589)
[ 2338.508204]   domain 1: span 0-1 level MC
[ 2338.508213]    groups: 0-1 (cpu_power = 1178)
[ 2338.508230] CPU1 attaching sched-domain:
[ 2338.508237]  domain 0: span 0-1 level SIBLING
[ 2338.508245]   groups: 1 (cpu_power = 589) 0 (cpu_power = 589)
[ 2338.508264]   domain 1: span 0-1 level MC
[ 2338.508272]    groups: 0-1 (cpu_power = 1178)

etc. pp.

It would be nice if sched_domain_debug() output
could be decoupled from CONFIG_LATENCYTOP.


Thanks,
Johannes
