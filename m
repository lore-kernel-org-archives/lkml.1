Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbZAEKg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbZAEKg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 05:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZAEKgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 05:36:19 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:59575 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbZAEKgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 05:36:18 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-wireless@vger.kernel.org
Subject: 2.6.28-git: WARNING: at drivers/net/wireless/iwlwifi/iwl-sta.c:689
Date: Mon, 5 Jan 2009 11:36:13 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901051136.13519.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

on my Thinkpad T61p I get several of the following warnings. The warning seems to happen on some reassociations 
(like after resume) but not on all. I have never seen this message with 2.6.28-rc9. Since I cannot reliably trigger 
this warning I am unable to bisect it...

Christian

[ 3850.807734] Restarting tasks ... done.
[ 3858.346160] wlan0: deauthenticated (Reason: 7)
[ 3859.345135] wlan0: direct probe to AP .. try 1
[ 3859.347476] wlan0 direct probe responded
[ 3859.347483] wlan0: authenticate with AP ...
[ 3859.349471] wlan0: authenticated
[ 3859.349476] wlan0: associate with AP ..
[ 3859.351984] wlan0: RX ReassocResp from .. (capab=0x431 status=0 aid=1)
[ 3859.351990] wlan0: associated
[ 3861.347111] ------------[ cut here ]------------
[ 3861.347119] WARNING: at drivers/net/wireless/iwlwifi/iwl-sta.c:689 iwl_set_dynamic_key+0x48e/0x4a0()
[ 3861.347125] Hardware name: 64575GG
[ 3861.347129] no space for new kewModules linked in: psmouse
[ 3861.347142] Pid: 16225, comm: events/1 Not tainted 2.6.28-self-05692-g7d3b56b #64
[ 3861.347148] Call Trace:
[ 3861.347159]  [<c014c7d3>] warn_slowpath+0x73/0xd0
[ 3861.347169]  [<c036b99f>] ? iwl_send_cmd_async+0x3f/0x90
[ 3861.347178]  [<c0146219>] ? finish_task_switch+0x29/0xc0
[ 3861.347186]  [<c036bd15>] ? iwl_send_cmd+0x15/0x20
[ 3861.347193]  [<c037047d>] ? iwl_send_add_sta+0x6d/0x110
[ 3861.347204]  [<c016cbe3>] ? tick_dev_program_event+0x33/0xb0
[ 3861.347212]  [<c013a7c8>] ? default_spin_lock_flags+0x8/0x10
[ 3861.347222]  [<c053ce8e>] ? _spin_lock_irqsave+0x3e/0x50
[ 3861.347230]  [<c03712ee>] iwl_set_dynamic_key+0x48e/0x4a0
[ 3861.347237]  [<c053d288>] ? _spin_unlock_irq+0x8/0x40
[ 3861.347244]  [<c03700fa>] ? iwl_find_station+0xda/0x120
[ 3861.347252]  [<c03735c8>] ? iwl_scan_cancel_timeout+0x18/0x80
[ 3861.347261]  [<c03749b3>] iwl_mac_set_key+0xf3/0x130
[ 3861.347269]  [<c0525337>] __ieee80211_key_todo+0xd7/0x260
[ 3861.347277]  [<c015df34>] ? queue_delayed_work_on+0xb4/0xe0
[ 3861.347284]  [<c03748c0>] ? iwl_mac_set_key+0x0/0x130
[ 3861.347291]  [<c05255d2>] ieee80211_key_todo+0x12/0x20
[ 3861.347298]  [<c05255e8>] key_todo+0x8/0x10
[ 3861.347307]  [<c015d6c1>] run_workqueue+0x81/0x150
[ 3861.347313]  [<c05255e0>] ? key_todo+0x0/0x10
[ 3861.347321]  [<c015d818>] worker_thread+0x88/0xf0
[ 3861.347329]  [<c0161490>] ? autoremove_wake_function+0x0/0x40
[ 3861.347337]  [<c015d790>] ? worker_thread+0x0/0xf0
[ 3861.347344]  [<c01610bc>] kthread+0x3c/0x70
[ 3861.347351]  [<c0161080>] ? kthread+0x0/0x70
[ 3861.347359]  [<c0120d13>] kernel_thread_helper+0x7/0x14
[ 3861.347365] ---[ end trace 0f088f1dccf29d2c ]---
