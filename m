Return-Path: <linux-kernel-owner+w=401wt.eu-S1757751AbXLGWx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751AbXLGWx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 17:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbXLGWxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 17:53:50 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:49031 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbXLGWxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 17:53:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=GI+GTaqd6Zl7rpO+IWCwR0zoltBaiT6wR4mBmWlB0KNV6s9O9YsJGSD0hAYpJwm+2C1umhXrTFykfQKEx17lxFg6K7F5ZjXH2Bqajug1WHryOtspEVBYbptCqfP/pW99PkeilxmnnbyuBT3/3Q6lItP0jSHszLAXxqkE0a5XYW4=
Message-ID: <82e4877d0712071453h38795e36of26324a4b123fa6c@mail.gmail.com>
Date: Fri, 7 Dec 2007 17:53:47 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: BUG: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Cc: "Andrew Morton" <akpm@linux-foundation.org>, venkatesh.pallipadi@intel.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got this on today's git (2.6.24-rc4) while compiling  stuff - Looks
like it is related to CpuIdle stuff.
I chose CONFIG_CPU_IDLE for the first time so I don't know when this
was introduced.

This is on x86_32, SMP.

BUG: soft lockup - CPU#1 stuck for 15s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #3)
EIP: 0060:[<c0603e22>] EFLAGS: 00000202 CPU: 1
EIP is at _spin_lock_irqsave+0x16/0x27
EAX: c06b4110 EBX: 00000001 ECX: f7873808 EDX: 00000293
ESI: 00000005 EDI: f7873808 EBP: 00000000 ESP: f7829f10
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 004f5960 CR3: 372c5000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c0438233>] tick_broadcast_oneshot_control+0x10/0xda
 [<c0437c82>] tick_notify+0x1d4/0x2eb
 [<c04281b4>] get_next_timer_interrupt+0x143/0x1b4
 [<c0605819>] notifier_call_chain+0x2a/0x47
 [<c04345a0>] raw_notifier_call_chain+0x17/0x1a
 [<c04378b7>] clockevents_notify+0x19/0x4f
 [<c0533cc3>] acpi_idle_enter_simple+0x183/0x1d0
 [<c058cea3>] cpuidle_idle_call+0x53/0x78
 [<c058ce50>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
