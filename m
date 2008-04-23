Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbYDWXAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbYDWXAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 19:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbYDWXAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 19:00:36 -0400
Received: from rv-out-0708.google.com ([209.85.198.249]:46272 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752084AbYDWXAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 19:00:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=J6AhDVpHqvcnpd+2hgi/7bbH9iHegkUc6lZ/OIO4+CRc5s7po4AGMNTrSnugvqLpV85RFkoNx2nMrAZ7XWsd7cnza+Gk2FwN5vy6VNMVDKRuh1c4eAOBGGWqt27VBUHnsSwuxJQ1E2jzR3/XFEdI4m3aSIZt1rxk1275/jhH5Cw=
Message-ID: <c4e36d110804231600l4b540a3ka637dedca0d7687b@mail.gmail.com>
Date: Thu, 24 Apr 2008 01:00:34 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: BUG: bad unlock balance detected iwl3945/1438 is trying to release lock
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

This stacktrace is with git
8876b8ed5fc9e996918cac4a553b8bc40d5605d7
(compiled few minutes ago)

(Unsure how it's related to other bugs around iwl driver)

Happens when wifi network is enabled/disabled

Zdenek


 ACPI: PCI interrupt for device 0000:03:00.0 disabled
 ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
 PM: Writing back config space on device 0000:03:00.0 at offset 1 (was
100102, writing 100106)

 =====================================
 [ BUG: bad unlock balance detected! ]
 -------------------------------------
 iwl3945/1438 is trying to release lock (&priv->mutex) at:
 [<ffffffff812ed439>] mutex_unlock+0x9/0x10
 but there are no more locks to release!

 other info that might help us debug this:
 2 locks held by iwl3945/1438:
  #0:  ((name)){--..}, at: [<ffffffff8105107a>] run_workqueue+0xaa/0x230
  #1:  (&ifsta->work){--..}, at: [<ffffffff8105107a>] run_workqueue+0xaa/0x230

 stack backtrace:
 Pid: 1438, comm: iwl3945 Not tainted 2.6.25 #61

 Call Trace:
  [<ffffffff810669d5>] print_unlock_inbalance_bug+0x105/0x130
  [<ffffffff81013458>] ? native_sched_clock+0x78/0x80
  [<ffffffff81065434>] ? __lock_acquire+0x364/0x11d0
  [<ffffffff81065434>] ? __lock_acquire+0x364/0x11d0
  [<ffffffff81066b18>] lock_release_non_nested+0x118/0x1a0
  [<ffffffff812ed439>] ? mutex_unlock+0x9/0x10
  [<ffffffff81066c66>] lock_release+0xc6/0x230
  [<ffffffff812ed336>] __mutex_unlock_slowpath+0x86/0x180
  [<ffffffff812ed439>] mutex_unlock+0x9/0x10
  [<ffffffffa0189d34>] :iwl3945:iwl3945_mac_config_interface+0x44/0x420
  [<ffffffff81062aca>] ? get_lock_stats+0x2a/0x70
  [<ffffffffa014ac46>] :mac80211:__ieee80211_if_config+0x86/0xe0
  [<ffffffffa014b67a>] :mac80211:ieee80211_if_config+0x3a/0x70
  [<ffffffffa0151f52>] :mac80211:ieee80211_sta_set_bssid+0xb2/0xd0
  [<ffffffffa01577be>] :mac80211:ieee80211_sta_work+0x158e/0x19b0
  [<ffffffff81062aca>] ? get_lock_stats+0x2a/0x70
  [<ffffffff81062aca>] ? get_lock_stats+0x2a/0x70
  [<ffffffff81062b1e>] ? put_lock_stats+0xe/0x30
  [<ffffffff81059311>] ? hrtimer_start+0xe1/0x1a0
  [<ffffffff81013458>] ? native_sched_clock+0x78/0x80
  [<ffffffff81065434>] ? __lock_acquire+0x364/0x11d0
  [<ffffffff81062b1e>] ? put_lock_stats+0xe/0x30
  [<ffffffff8105107a>] ? run_workqueue+0xaa/0x230
  [<ffffffff8105107a>] ? run_workqueue+0xaa/0x230
  [<ffffffffa0156230>] ? :mac80211:ieee80211_sta_work+0x0/0x19b0
  [<ffffffff810510c6>] run_workqueue+0xf6/0x230
  [<ffffffff810512a7>] worker_thread+0xa7/0x120
  [<ffffffff81055810>] ? autoremove_wake_function+0x0/0x40
  [<ffffffff81051200>] ? worker_thread+0x0/0x120
  [<ffffffff81055479>] kthread+0x49/0x90
  [<ffffffff8100d548>] child_rip+0xa/0x12
  [<ffffffff8100cc33>] ? restore_args+0x0/0x30
  [<ffffffff81055430>] ? kthread+0x0/0x90
  [<ffffffff8100d53e>] ? child_rip+0x0/0x12
