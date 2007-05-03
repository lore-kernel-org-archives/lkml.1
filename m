Return-Path: <linux-kernel-owner+w=401wt.eu-S376303AbXECTLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376303AbXECTLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376310AbXECTLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:11:23 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:55986 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S376303AbXECTLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:11:22 -0400
Date: Thu, 3 May 2007 21:11:20 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.20.1] BUG: soft lockup detected on CPU#1!
Message-ID: <20070503191120.GW7874@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Tue May  1 11:57:23 CEST 2007
X-Message-Flag: www.vanheusden.com
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My P4 with HT and 2GB of ram on an IDE disk succeeded in triggering
another bug:

[273187.872796] usb 7-2: usbfs: USBDEVFS_CONTROL failed cmd newhidups rqt 161 rq 1 len 10 ret -110
[273902.586320] BUG: soft lockup detected on CPU#1!
[273902.586385]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
[273902.586472]  [<c1004d7b>] show_trace+0x12/0x14
[273902.586557]  [<c1004e75>] dump_stack+0x16/0x18
[273902.586636]  [<c104d52b>] softlockup_tick+0xa6/0xc2
[273902.586724]  [<c10267ae>] run_local_timers+0x12/0x14
[273902.586810]  [<c10265dc>] update_process_times+0x72/0xa1
[273902.586893]  [<c1038390>] tick_sched_timer+0x53/0xb6
[273902.586977]  [<c1033ba8>] hrtimer_interrupt+0x16b/0x1c2
[273902.587062]  [<c100e9e2>] local_apic_timer_interrupt+0x55/0x5b
[273902.587147]  [<c100ea12>] smp_apic_timer_interrupt+0x2a/0x39
[273902.587230]  [<c1004a3f>] apic_timer_interrupt+0x33/0x38
[273902.587312]  [<c10020f2>] cpu_idle+0x6b/0x85
[273902.587393]  [<c130b218>] start_secondary+0xe8/0x30a
[273902.587476]  [<00000000>] 0x0
[273902.587568]  =======================
[277740.475464] usb 7-2: usbfs: USBDEVFS_CONTROL failed cmd newhidups rqt 161 rq 1 len 10 ret -110
...
[285799.322391] usb 7-2: usbfs: USBDEVFS_CONTROL failed cmd newhidups rqt 161 rq 1 len 10 ret -110
[286630.885843] BUG: soft lockup detected on CPU#1!
[286630.885901]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
[286630.885988]  [<c1004d7b>] show_trace+0x12/0x14
[286630.886071]  [<c1004e75>] dump_stack+0x16/0x18
[286630.886152]  [<c104d52b>] softlockup_tick+0xa6/0xc2
[286630.886235]  [<c10267ae>] run_local_timers+0x12/0x14
[286630.886323]  [<c10265dc>] update_process_times+0x72/0xa1
[286630.886406]  [<c1038390>] tick_sched_timer+0x53/0xb6
[286630.886488]  [<c1033ba8>] hrtimer_interrupt+0x16b/0x1c2
[286630.886571]  [<c100e9e2>] local_apic_timer_interrupt+0x55/0x5b
[286630.886657]  [<c100ea12>] smp_apic_timer_interrupt+0x2a/0x39
[286630.886741]  [<c1004a3f>] apic_timer_interrupt+0x33/0x38
[286630.886824]  [<c10020f2>] cpu_idle+0x6b/0x85
[286630.886907]  [<c130b218>] start_secondary+0xe8/0x30a
[286630.886991]  [<00000000>] 0x0
[286630.887088]  =======================
[290177.972351] usb 7-2: usbfs: USBDEVFS_CONTROL failed cmd newhidups rqt 161 rq 1 len 10 ret -110

My .config can be found here: http://keetweej.vanheusden.com/~folkert/config-2.6.21.1


Folkert van Heusden

-- 
MultiTail cok yonlu kullanimli bir program, loglari okumak, verilen
kommandolari yerine getirebilen. Filter, renk verme, merge, 'diff-
view', vs.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
