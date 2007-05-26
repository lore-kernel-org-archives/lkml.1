Return-Path: <linux-kernel-owner+w=401wt.eu-S1761360AbXEZPk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761360AbXEZPk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 11:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbXEZPkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 11:40:16 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:45213 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbXEZPkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 11:40:14 -0400
Date: Sat, 26 May 2007 17:40:12 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.21.1] soft lockup when removing netconsole module
Message-ID: <20070526154011.GB3735@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Fri May 25 13:51:59 CEST 2007
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When trying to remove the netconsole module, I got the following kernel
output after a while (couple of minutes iirc):

[525720.117293] BUG: soft lockup detected on CPU#1!
[525720.117353]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
[525720.117439]  [<c1004d7b>] show_trace+0x12/0x14
[525720.117526]  [<c1004e75>] dump_stack+0x16/0x18
[525720.117613]  [<c104dd5b>] softlockup_tick+0xa6/0xc2
[525720.117694]  [<c1026855>] run_local_timers+0x12/0x14
[525720.117738]  [<c1026669>] update_process_times+0x72/0xa1
[525720.117744]  [<c1038673>] tick_sched_timer+0x53/0xb6
[525720.117748]  [<c1033d62>] hrtimer_interrupt+0x189/0x1e3
[525720.117753]  [<c100e9e2>] local_apic_timer_interrupt+0x55/0x5b
[525720.117761]  [<c100ea12>] smp_apic_timer_interrupt+0x2a/0x39
[525720.117766]  [<c1004a3f>] apic_timer_interrupt+0x33/0x38
[525720.117770]  [<c120f4b1>] mutex_lock+0x8/0xa
[525720.117775]  [<c102d2f0>] flush_workqueue+0x2f/0x8f
[525720.117780]  [<c102d7a0>] cancel_rearming_delayed_workqueue+0x29/0x2b
[525720.117785]  [<c102d7b1>] cancel_rearming_delayed_work+0xf/0x11
[525720.117790]  [<c11be143>] netpoll_cleanup+0x75/0xa5
[525720.117794]  [<f893712d>] cleanup_netconsole+0x17/0x1a [netconsole]
[525720.117804]  [<c1041f11>] sys_delete_module+0x12f/0x14f
[525720.117809]  [<c1003f74>] syscall_call+0x7/0xb
[525720.117812]  =======================

Also the rmmod hangs and would not exit even with kill -9. It also
sucks up 100% cpu.


Folkert van Heusden

-- 
MultiTail es una herramienta flexibele para consiguir archivos de log,
y para ejecutar ordenes. Filtrar, añadir colores, merger y vista de
las differencias.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
