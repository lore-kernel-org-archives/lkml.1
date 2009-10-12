Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbZJLM3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbZJLM3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 08:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755658AbZJLM3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 08:29:45 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:46059 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbZJLM3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 08:29:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=tN3UAIEHyk9CJBsYdLhsXUh1vRS/Gouw5AOc6rWX+WGoEFyfalES94oGTWHe631ye/
         4eypq/A0Jc6db2YHcLSqlrvuT2fXVJVgA5q5hpWME3gIfyoQs1HrEeKNJul0wcAls3U4
         s7MGfFE+AD/i+Y61tGLAah0kZF5kreYBLSeEs=
MIME-Version: 1.0
Date: Mon, 12 Oct 2009 08:28:36 -0400
Message-ID: <a44ae5cd0910120528h6d8992fcn8b6592ee799fbfc5@mail.gmail.com>
Subject: 2.6.32-rc4-git1 -- INFO: possible circular locking dependency 
	detected
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[  823.466853] [ INFO: possible circular locking dependency detected ]
[  823.466866] 2.6.32-rc4-git1 #2
[  823.466873] -------------------------------------------------------
[  823.466884] swapper/0 is trying to acquire lock:
[  823.466893]  (&sta->lock){+.-...}, at: [<f857bda4>]
sta_addba_resp_timer_expired+0x1b/0x50 [mac80211]
[  823.466940]
[  823.466943] but task is already holding lock:
[  823.466953]
(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer){+.-...}, at:
[<c1032f22>] run_timer_softirq+0x125/0x1e5
[  823.466984]
[  823.466987] which lock already depends on the new lock.
[  823.466991]
[  823.467000]
[  823.467002] the existing dependency chain (in reverse order) is:
[  823.467013]
[  823.467015] -> #1 (&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer){+.-...}:
[  823.467037]        [<c104ac2c>] __lock_acquire+0x9fb/0xb6d
[  823.467056]        [<c104adfa>] lock_acquire+0x5c/0x73
[  823.467072]        [<c10336b8>] del_timer_sync+0x29/0x6c
[  823.467089]        [<f857bceb>]
ieee80211_process_addba_resp+0x49/0xa0 [mac80211]
[  823.467121]        [<f8584585>] ieee80211_rx_h_action+0xeb/0x335 [mac80211]
[  823.467157]        [<f8585654>]
ieee80211_invoke_rx_handlers+0xe50/0x10d8 [mac80211]
[  823.467193]        [<f8585d46>]
__ieee80211_rx_handle_packet+0x46a/0x497 [mac80211]
[  823.467229]        [<f8586475>] ieee80211_rx+0x4d1/0x530 [mac80211]
[  823.467263]        [<f89936e3>] ath_rx_send_to_mac80211+0xa0/0xa8 [ath9k]
[  823.467302]        [<f899439e>] ath_rx_tasklet+0x7b6/0x7f5 [ath9k]
[  823.467338]        [<f8992115>] ath9k_tasklet+0x47/0xc7 [ath9k]
[  823.467373]        [<c102f4a1>] tasklet_action+0x8e/0xe1
[  823.467391]        [<c102f95b>] __do_softirq+0x8d/0x117
[  823.467409]
[  823.467412] -> #0 (&sta->lock){+.-...}:
[  823.467430]        [<c104ab2e>] __lock_acquire+0x8fd/0xb6d
[  823.467447]        [<c104adfa>] lock_acquire+0x5c/0x73
[  823.467464]        [<c132526f>] _spin_lock_bh+0x2a/0x39
[  823.467481]        [<f857bda4>]
sta_addba_resp_timer_expired+0x1b/0x50 [mac80211]
[  823.467514]        [<c1032f6d>] run_timer_softirq+0x170/0x1e5
[  823.467531]        [<c102f95b>] __do_softirq+0x8d/0x117
[  823.467548]
[  823.467551] other info that might help us debug this:
[  823.467555]
[  823.467566] 1 lock held by swapper/0:
[  823.467574]  #0:
(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer){+.-...}, at:
[<c1032f22>] run_timer_softirq+0x125/0x1e5
[  823.467604]
[  823.467607] stack backtrace:
[  823.467619] Pid: 0, comm: swapper Not tainted 2.6.32-rc4-git1 #2
[  823.467628] Call Trace:
[  823.467643]  [<c13233c8>] ? printk+0xf/0x11
[  823.467659]  [<c1049ef5>] print_circular_bug+0x8a/0x96
[  823.467675]  [<c104ab2e>] __lock_acquire+0x8fd/0xb6d
[  823.467694]  [<c104adfa>] lock_acquire+0x5c/0x73
[  823.467725]  [<f857bda4>] ? sta_addba_resp_timer_expired+0x1b/0x50 [mac80211]
[  823.467742]  [<c132526f>] _spin_lock_bh+0x2a/0x39
[  823.467772]  [<f857bda4>] ? sta_addba_resp_timer_expired+0x1b/0x50 [mac80211]
[  823.467803]  [<f857bda4>] sta_addba_resp_timer_expired+0x1b/0x50 [mac80211]
[  823.467820]  [<c1032f6d>] run_timer_softirq+0x170/0x1e5
[  823.467836]  [<c1032f22>] ? run_timer_softirq+0x125/0x1e5
[  823.467866]  [<f857bd89>] ? sta_addba_resp_timer_expired+0x0/0x50 [mac80211]
[  823.467885]  [<c102f95b>] __do_softirq+0x8d/0x117
[  823.467901]  [<c102f8ce>] ? __do_softirq+0x0/0x117
[  823.467911]  <IRQ>  [<c102faf5>] ? irq_exit+0x38/0x75
[  823.467939]  [<c10045b1>] ? do_IRQ+0x88/0x9c
[  823.467954]  [<c1003175>] ? common_interrupt+0x35/0x3c
[  823.467971]  [<c104007b>] ? sched_clock_tick+0x31/0x77
[  823.467989]  [<c11b84ff>] ? acpi_idle_enter_bm+0x233/0x25e
[  823.468008]  [<c125c232>] ? cpuidle_idle_call+0x65/0x9b
[  823.468023]  [<c1001cd1>] ? cpu_idle+0xb9/0xe8
[  823.468041]  [<c131708b>] ? rest_init+0x67/0x69
[  823.468058]  [<c14e28e8>] ? start_kernel+0x3a3/0x3aa
[  823.468076]  [<c14e2098>] ? i386_start_kernel+0x98/0x9f
