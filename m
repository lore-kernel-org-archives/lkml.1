Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbYIJIKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbYIJIKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 04:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYIJIKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 04:10:25 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:47361 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYIJIKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 04:10:23 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: warn_on regression after 2.6.27-rc5
Date: Wed, 10 Sep 2008 10:08:40 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101008.40973.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

this commit 

commit 1fb9b7d29d8e85ba3196eaa7ab871bf76fc98d36
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Wed Sep 3 21:37:14 2008 +0000

    clockevents: prevent endless loop lockup


causes the following warning on my Thinkpad T61p:

CE: __tick_program_event of hpet is stuck 7416220944 7416221ccc
CE: increasing min_delta_ns 5000 to 10000 nsec
------------[ cut here ]------------
WARNING: at kernel/time/tick-oneshot.c:52 tick_dev_program_event+0xd6/0x120()
Modules linked in: kvm_intel kvm fan iptable_nat nf_nat iptable_mangle 
ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables 
x_tables ctr blowfish rmd160 sha256_generic crypto_null nls_utf8 ntfs fuse 
acpi_cpufreq usbhid pcmcia snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm 
snd_timer snd_page_alloc snd_hwdep snd yenta_socket iwlagn rsrc_nonstatic 
pcmcia_core soundcore ehci_hcd uhci_hcd e1000e thermal evdev video battery 
usbcore ac bay processor button
Pid: 0, comm: swapper Not tainted 2.6.27-rc5-00319-g7686ad5 #15
 [<c012e32f>] warn_on_slowpath+0x5f/0xa0
 [<c026f950>] vt_console_print+0x0/0x330
 [<c03f0554>] _spin_lock_irqsave+0x34/0x50
 [<c012eb71>] release_console_sem+0x191/0x1c0
 [<c012f0ce>] vprintk+0x32e/0x3a0
 [<c01487d1>] getnstimeofday+0x41/0xf0
 [<c0114d88>] lapic_next_event+0x18/0x30
 [<c01487d1>] getnstimeofday+0x41/0xf0
 [<c014bd73>] clockevents_program_event+0xa3/0x160
 [<c014cfe6>] tick_dev_program_event+0xd6/0x120
 [<c014c81d>] tick_broadcast_oneshot_control+0x10d/0x120
 [<c014c3a5>] tick_notify+0x295/0x3c0
 [<c0146df6>] notifier_call_chain+0x36/0x70
 [<c0146ee7>] raw_notifier_call_chain+0x17/0x20
 [<c014bbbe>] clockevents_notify+0x1e/0x70
 [<f884f087>] acpi_idle_enter_bm+0x15e/0x2c2 [processor]
 [<c031fed3>] cpuidle_idle_call+0x73/0xd0
 [<c010249d>] cpu_idle+0x6d/0x140
 =======================
---[ end trace c7d6f2472868c172 ]---

While I agree with doubling the time, I am not sure if a WARN_ON is 
appropriate. After all the code is able to fix the timer setting.

Christian
