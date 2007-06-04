Return-Path: <linux-kernel-owner+w=401wt.eu-S1759066AbXFDR3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066AbXFDR3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbXFDR3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:29:42 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:54016 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394AbXFDR3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:29:42 -0400
Date: Mon, 4 Jun 2007 19:29:38 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.21.1] soft lockup detected on CPU#1 - timers
Message-ID: <20070604172938.GO30199@vanheusden.com>
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
Reply-By: Fri Jun  1 23:33:08 CEST 2007
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.15+20070515 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Suddenly out of the blue (NO powertop was running or so) my system threw
a message in the logging about a soft lockup:

[330718.331426] BUG: soft lockup detected on CPU#1!
[330718.331483]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
[330718.331574]  [<c1004d7b>] show_trace+0x12/0x14
[330718.331661]  [<c1004e75>] dump_stack+0x16/0x18
[330718.331747]  [<c104dd77>] softlockup_tick+0xa6/0xc2
[330718.331834]  [<c1026855>] run_local_timers+0x12/0x14
[330718.331923]  [<c1026669>] update_process_times+0x72/0xa1
[330718.332009]  [<c103867b>] tick_sched_timer+0x53/0xb6
[330718.332094]  [<c1033d6a>] hrtimer_interrupt+0x189/0x1e3
[330718.332180]  [<c100e9e2>] local_apic_timer_interrupt+0x55/0x5b
[330718.332268]  [<c100ea12>] smp_apic_timer_interrupt+0x2a/0x39
[330718.332354]  [<c1004a3f>] apic_timer_interrupt+0x33/0x38
[330718.332441]  [<c10020f2>] cpu_idle+0x6b/0x85
[330718.332526]  [<c130e218>] start_secondary+0xe8/0x30a
[330718.333480]  [<00000000>] 0x0
[330718.333579]  =======================

I'm a little puzzled why cpu_idle is called anyway as the load of the
system is on average at least 2.5 (see
http://keetweej.vanheusden.com/load.png ).


Folkert van Heusden

-- 

Multitail - gibkaja utilita po sledovaniju log-fajlov i vyvoda
kommand. Fil'trovanie, raskrašivanie, slijanie, vizual'noe sravnenie,
i t.d.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
