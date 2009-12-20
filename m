Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbZLTBOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbZLTBOJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 20:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbZLTBOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 20:14:08 -0500
Received: from slowhand.arndnet.de ([88.198.19.76]:57538 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754784AbZLTBOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 20:14:07 -0500
X-Greylist: delayed 1746 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Dec 2009 20:14:07 EST
Message-ID: <4B2D7388.9030002@nets.rwth-aachen.de>
Date: Sun, 20 Dec 2009 01:44:56 +0100
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-geode@bombadil.infradead.org
Subject: 2.6.33-rc1: WARNING: at kernel/mutex-debug.c:78 (geode hw rng?)
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

not so sure if it is geode related.
While starting rngd on 2.6.33-rc1 on a geode machine, I got this warning:

[   19.545852] ------------[ cut here ]------------
[   19.547554] WARNING: at kernel/mutex-debug.c:78
debug_mutex_unlock+0x78/0xb8()
[   19.547554] Modules linked in: ipt_LOG iptable_nat nf_nat
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 arc4 ecb ath5k ehci_hcd
ohci_hcd mac80211 ath
[   19.547554] Pid: 2509, comm: rngd Not tainted 2.6.33-rc1-ah0 #2
[   19.547554] Call Trace:
[   19.547554]  [<c102d86c>] ? debug_mutex_unlock+0x78/0xb8
[   19.547554]  [<c10168bd>] warn_slowpath_common+0x60/0x77
[   19.547554]  [<c10168e1>] warn_slowpath_null+0xd/0x10
[   19.547554]  [<c102d86c>] debug_mutex_unlock+0x78/0xb8
[   19.547554]  [<c1273314>] __mutex_unlock_slowpath+0x7b/0xa3
[   19.547554]  [<c1273344>] mutex_unlock+0x8/0xa
[   19.547554]  [<c116de8c>] rng_dev_read+0x13b/0x156
[   19.547554]  [<c116dd51>] ? rng_dev_read+0x0/0x156
[   19.547554]  [<c105ac23>] vfs_read+0x8a/0x11a
[   19.547554]  [<c105af18>] sys_read+0x3b/0x60
[   19.547554]  [<c127426d>] syscall_call+0x7/0xb
[   19.547554] ---[ end trace cd1825d2e719f82e ]---

however, the system seems stable, and the hwrng seems to work fine...

Best regards,
Arnd
