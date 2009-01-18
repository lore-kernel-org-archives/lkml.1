Return-Path: <linux-kernel-owner+w=401wt.eu-S933925AbZARPtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933925AbZARPtq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 10:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932246AbZARPtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 10:49:35 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:40800 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbZARPte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 10:49:34 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12415] WARNING: at drivers/net/wireless/iwlwifi/iwl-sta.c:689
Date: Sun, 18 Jan 2009 16:49:31 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera> <200901121215.31749.borntraeger@de.ibm.com> <200901121347.42799.rjw@sisk.pl>
In-Reply-To: <200901121347.42799.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901181649.32054.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 12 Januar 2009 schrieb Rafael J. Wysocki:
> On Monday 12 January 2009, Christian Borntraeger wrote:
> > Am Sonntag 11 Januar 2009 schrieb Rafael J. Wysocki:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > >
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.28.  Please verify if it still should be listed and let me
> > > know (either way).
> > >
> > >
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12415
> > > Subject		: WARNING: at drivers/net/wireless/iwlwifi/iwl-sta.c:689
> > > Submitter	: Christian Borntraeger <borntraeger@de.ibm.com>
> > > Date		: 2009-01-05 10:36 (7 days old)
> > > References	: http://marc.info/?l=linux-wireless&m=123115178019082&w=4
> >
> > Meanwhile I have updated the device firmware and the kernel level. The
> > problems has disappeared.
>
> Thanks for the update, the bug has been closed.

Since suspend/resume now works I have seen this problem again.
I dont know how to trigger this, but I have made several suspend/resume cycles 
since yesterday:


[11182.292341] WARNING: at drivers/net/wireless/iwlwifi/iwl-sta.c:689 
iwl_set_dynamic_key+0x4be/0x4d0()
[11182.292343] Hardware name: 64575GG
[11182.292344] no space for new kewModules linked in: psmouse
[11182.292349] Pid: 21185, comm: events/1 Not tainted 
2.6.29-rc2-self-00004-g812c74b #164
[11182.292350] Call Trace:
[11182.292355]  [<c014ccb7>] warn_slowpath+0x87/0xe0
[11182.292358]  [<c036c66f>] iwl_send_cmd_async+0x3f/0x90
[11182.292360]  [<c011f69a>] __switch_to+0xca/0x1d0
[11182.292363]  [<c03711ef>] iwl_send_add_sta+0x7f/0x120
[11182.292366]  [<c014666f>] finish_task_switch+0x1f/0xb0
[11182.292369]  [<c05469ed>] schedule_timeout+0xbd/0xf0
[11182.292372]  [<c0370fe0>] iwl_add_sta_callback+0x0/0x70
[11182.292374]  [<c013ab65>] default_spin_lock_flags+0x5/0x10
[11182.292377]  [<c054804d>] _spin_lock_irqsave+0x3d/0x60
[11182.292379]  [<c03720de>] iwl_set_dynamic_key+0x4be/0x4d0
[11182.292381]  [<c013ab65>] default_spin_lock_flags+0x5/0x10
[11182.292383]  [<c054804d>] _spin_lock_irqsave+0x3d/0x60
[11182.292385]  [<c0370e56>] iwl_find_station+0xd6/0x110
[11182.292388]  [<c0373951>] iwl_scan_cancel_timeout+0x21/0x90
[11182.292390]  [<c037576b>] iwl_mac_set_key+0x8b/0x160
[11182.292393]  [<c03756e0>] iwl_mac_set_key+0x0/0x160
[11182.292395]  [<c0530340>] __ieee80211_key_todo+0xd0/0x260
[11182.292398]  [<c015e5b3>] queue_delayed_work_on+0xa3/0xd0
[11182.292400]  [<c05305ef>] ieee80211_key_todo+0xf/0x20
[11182.292403]  [<c015dd8b>] run_workqueue+0x6b/0x130
[11182.292405]  [<c013ab65>] default_spin_lock_flags+0x5/0x10
[11182.292407]  [<c054804d>] _spin_lock_irqsave+0x3d/0x60
[11182.292409]  [<c0530600>] key_todo+0x0/0x10
[11182.292412]  [<c015ded8>] worker_thread+0x88/0xf0
[11182.292414]  [<c01619d0>] autoremove_wake_function+0x0/0x50
[11182.292417]  [<c015de50>] worker_thread+0x0/0xf0
[11182.292419]  [<c0161609>] kthread+0x39/0x70
[11182.292420]  [<c01615d0>] kthread+0x0/0x70
[11182.292423]  [<c01210d3>] kernel_thread_helper+0x7/0x14
[11182.292424] ---[ end trace 94103c51f16e0890 ]---
