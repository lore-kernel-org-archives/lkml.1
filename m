Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbYENWI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbYENWI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYENWIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:08:50 -0400
Received: from main.gmane.org ([80.91.229.2]:40513 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbYENWIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:08:49 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: BUG: sleeping function called from invalid context when hibernating
Date: Wed, 14 May 2008 22:08:34 +0000 (UTC)
Message-ID: <g0fnt2$5cr$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: Pan/0.129 (Benson & Hedges Moscow Gold)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the linux-next kernel from 13 May 2008 I see the following in 
the logs when resuming from hibernate (system is Ubuntu 7.10):

[ 3283.928033] BUG: sleeping function called from invalid context at kernel/rwsem.c:21
[ 3283.928033] in_atomic():0, irqs_disabled():1
[ 3283.928033] 3 locks held by hibernate.sh/5892:
[ 3283.928033]  #0:  (&buffer->mutex){--..}, at: [<c01958e3>] sysfs_write_file+0x25/0xdf
[ 3283.928033]  #1:  (pm_mutex){--..}, at: [<c013d6c1>] hibernate+0x10/0x177
[ 3283.928033]  #2:  (pm_sleep_rwsem){--..}, at: [<c021c32f>] device_suspend+0x2a/0x1c7
[ 3283.928033] irq event stamp: 461790
[ 3283.928033] hardirqs last  enabled at (461789): [<c0298283>] __mutex_unlock_slowpath+0xd6/0xde
[ 3283.928033] hardirqs last disabled at (461790): [<c013d5fa>] hibernation_snapshot+0xab/0x162
[ 3283.928033] softirqs last  enabled at (461166): [<c011e1de>] __do_softirq+0x8f/0x94
[ 3283.928033] softirqs last disabled at (461161): [<c011e20d>] do_softirq+0x2a/0x42
[ 3283.928033] Pid: 5892, comm: hibernate.sh Not tainted 2.6.25skw #25
[ 3283.928033]  [<c0114aad>] __might_sleep+0xb8/0xbf
[ 3283.928033]  [<c0298835>] down_read+0x19/0x68
[ 3283.928033]  [<c01c5152>] pci_get_subsys+0x48/0xc5
[ 3283.928033]  [<c01c51dd>] pci_get_device+0xe/0x10
[ 3283.928033]  [<c01c41eb>] quirk_vialatency+0x1b/0xac
[ 3283.928033]  [<c01c3fe0>] pci_fixup_device+0x70/0x7c
[ 3283.928033]  [<c01c4ae5>] pci_device_resume_early+0x17/0x2e
[ 3283.928033]  [<c021c154>] dpm_power_up+0x66/0x94
[ 3283.928033]  [<c021c4d9>] device_power_up+0xd/0xf
[ 3283.928033]  [<c013d66f>] hibernation_snapshot+0x120/0x162
[ 3283.928033]  [<c013d771>] hibernate+0xc0/0x177
[ 3283.928033]  [<c013c5ce>] ? state_store+0x0/0xaa
[ 3283.928033]  [<c013c613>] state_store+0x45/0xaa
[ 3283.928033]  [<c013c5ce>] ? state_store+0x0/0xaa
[ 3283.928033]  [<c01b0c3d>] kobj_attr_store+0x1a/0x22
[ 3283.928033]  [<c019596b>] sysfs_write_file+0xad/0xdf
[ 3283.928033]  [<c01958be>] ? sysfs_write_file+0x0/0xdf
[ 3283.928033]  [<c0164afd>] vfs_write+0x88/0xf8
[ 3283.928033]  [<c0164f76>] sys_write+0x3b/0x60
[ 3283.928033]  [<c01047a2>] sysenter_past_esp+0x5f/0xa5
[ 3283.928033]  =======================
[ 3283.928033] pci 0000:00:07.0: Disabling VIA external APIC routing

-- 
Sitsofe | http://sucs.org/~sits/

