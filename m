Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbZD1Udq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbZD1Udq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbZD1Udg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:33:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:25597 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbZD1Ude (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:33:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,262,1239001200"; 
   d="scan'208";a="407729522"
Subject: Re: mmotm 2009-04-27-15-45 uploaded - iwl3945 oops
From: reinette chatre <reinette.chatre@intel.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Zhu, Yi" <yi.zhu@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <25818.1240938876@turing-police.cc.vt.edu>
References: <200904272305.n3RN51mu031395@imap1.linux-foundation.org>
	 <25818.1240938876@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 13:39:44 -0700
Message-Id: <1240951184.1207.11.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 10:14 -0700, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 27 Apr 2009 15:46:07 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2009-04-27-15-45 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> Saw this while booting at home, out of range of any access points I was
> configured to associate with (there *are* 4 APs owned by neighbors that I can
> see via kismet, but wpa_supplicant isn't configured to use them).  Didn't
> happen this morning at my office, when there's APs in range.
> 
> This didn't happen in mmotm-0424, so it's something new in the last few days.

A recent patch that is related is ...

commit 4583f7455c6b668a4e9cab154b5a7b6c583b288a
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Thu Apr 23 10:45:04 2009 +0200

    iwlwifi: notify on scan completion even when shutting down

    Under certain circumstances iwlwifi can get stuck and will no
    longer accept scan requests, because the core code (cfg80211)
    thinks that it's still processing one. This fixes one of the
    points where it can happen, but I've still seen it (although
    only with my radio-off-when-idle patch).
    
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Acked-by: Reinette Chatre <reinette.chatre@intel.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>


Could you please revert this and test again?

If this does not help, could you please bisect?

Thank you

Reinette


> 
> [  519.180281] iwl3945 0000:0c:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
> [  519.680281] iwl3945 0000:0c:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
> [  519.926455] ------------[ cut here ]------------
> [  519.926461] WARNING: at net/mac80211/scan.c:282 warn_slowpath_null+0xd/0xf()
> [  519.926465] Hardware name: Latitude D820                   
> [  519.926476] BUG: unable to handle kernel NULL pointer dereference at (null)
> [  519.926485] IP: [<ffffffff802384ff>] warn_slowpath_fmt+0x7d/0xd0
> [  519.926494] PGD 7ead4067 PUD 7f8e3067 PMD 0 
> [  519.926504] Oops: 0000 [#1] PREEMPT SMP 
> [  519.926512] last sysfs file: /sys/devices/platform/dock.0/docked
> [  519.926518] CPU 1 
> [  519.926522] Modules linked in: sunrpc nvidia(P) [last unloaded: microcode]
> [  519.926536] Pid: 649, comm: iwl3945 Tainted: P           2.6.30-rc3-mmotm0427 #1 Latitude D820                   
> [  519.926541] RIP: 0010:[<ffffffff802384ff>]  [<ffffffff802384ff>] warn_slowpath_fmt+0x7d/0xd0
> [  519.926551] RSP: 0018:ffff88007e7e3c70  EFLAGS: 00010286
> [  519.926555] RAX: 0000000000000042 RBX: 000000000000011a RCX: 00000000ffffffff
> [  519.926560] RDX: ffff8800010f1000 RSI: ffffffff8064d3b3 RDI: ffffffff80239038
> [  519.926564] RBP: ffff88007e7e3dd0 R08: 0000000000000082 R09: 0000000000000000
> [  519.926569] R10: 0000000000000005 R11: 0000000000000000 R12: ffffffff8082531c
> [  519.926574] R13: 0000000000000000 R14: ffff88007e7e3c70 R15: ffff8800010f0100
> [  519.926579] FS:  0000000000000000(0000) GS:ffff8800010f1000(0000) knlGS:0000000000000000
> [  519.926584] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [  519.926589] CR2: 0000000000000000 CR3: 000000007ead5000 CR4: 00000000000006e0
> [  519.926593] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  519.926598] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  519.926604] Process iwl3945 (pid: 649, threadinfo ffff88007e7e2000, task ffff88007e794500)
> [  519.926608] Stack:
> [  519.926611]  6f6c735f6e726177 756e5f6874617077 302f6478302b6c6c ffffffff80006678
> [  519.926620]  ffff880000000000 ffff88007f8008c0 ffff88007e7e3d20 0000000000000046
> [  519.926631]  0000000000000002 0000000000000000 ffffffff8046e959 0000000000000000
> [  519.926643] Call Trace:
> [  519.926647]  [<ffffffff8046e959>] ? iwl_rx_queue_update_write_ptr+0x2d/0xd8
> [  519.926657]  [<ffffffff80259a62>] ? trace_hardirqs_off_caller+0x1f/0xa2
> [  519.926667]  [<ffffffff8064fd91>] ? _spin_unlock_irqrestore+0x5b/0x69
> [  519.926677]  [<ffffffff8046e9f2>] ? iwl_rx_queue_update_write_ptr+0xc6/0xd8
> [  519.926684]  [<ffffffff80473c3e>] ? iwl_bg_scan_completed+0x0/0x65
> [  519.926692]  [<ffffffff8023855f>] warn_slowpath_null+0xd/0xf
> [  519.926699]  [<ffffffff80612dc9>] ieee80211_scan_completed+0x4d/0x367
> [  519.926709]  [<ffffffff80473c3e>] ? iwl_bg_scan_completed+0x0/0x65
> [  519.926716]  [<ffffffff80473c76>] iwl_bg_scan_completed+0x38/0x65
> [  519.926723]  [<ffffffff802488e0>] worker_thread+0x251/0x369
> [  519.926731]  [<ffffffff80248887>] ? worker_thread+0x1f8/0x369
> [  519.926738]  [<ffffffff8064fd70>] ? _spin_unlock_irqrestore+0x3a/0x69
> [  519.926745]  [<ffffffff8024cb21>] ? autoremove_wake_function+0x0/0x34
> [  519.926753]  [<ffffffff8024868f>] ? worker_thread+0x0/0x369
> [  519.926760]  [<ffffffff8024c728>] kthread+0x55/0x80
> [  519.926767]  [<ffffffff8020c1ba>] child_rip+0xa/0x20
> [  519.926774]  [<ffffffff802305ac>] ? finish_task_switch+0x7f/0xc9
> [  519.926782]  [<ffffffff8020bb80>] ? restore_args+0x0/0x30
> [  519.926790]  [<ffffffff8024c6d3>] ? kthread+0x0/0x80
> [  519.926796]  [<ffffffff8020c1b0>] ? child_rip+0x0/0x20
> [  519.926802] Code: 77 a5 7b 80 31 c0 e8 98 4e 41 00 bf 05 00 00 00 e8 e7 ad 2a 00 48 85 c0 74 11 48 89 c6 48 c7 c7 92 a5 7b 80 31 c0 e8 78 4e 41 00 <41> 80 7d 00 00 74 23 48 8d 45 10 48 8d 75 90 48 89 45 98 c7 45 
> [  519.926904] RIP  [<ffffffff802384ff>] warn_slowpath_fmt+0x7d/0xd0
> [  519.926912]  RSP <ffff88007e7e3c70>
> Apr 28 01:50:28 turing-police kernel: [  519.926915] CR2: 0000000000000000
> Apr 28 01:50:28 turing-police kernel: [  519.926920] ---[ end trace 00d0bec46e95e015 ]---
> 



