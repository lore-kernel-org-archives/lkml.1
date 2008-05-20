Return-Path: <linux-kernel-owner+w=401wt.eu-S933071AbYETOya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071AbYETOya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758409AbYETOyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:54:15 -0400
Received: from smtp.innovsys.com ([66.115.232.196]:40400 "EHLO
	mail.innovsys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753548AbYETOyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:54:14 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Broken highmem support with preempt-rt
Date: Tue, 20 May 2008 09:48:00 -0500
Message-ID: <DCEAAC0833DD314AB0B58112AD99B93B046E72B2@ismail.innsys.innovsys.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Broken highmem support with preempt-rt
Thread-Index: Aci6iH/wNvYOvwJ8TY+0/UIyatuI4g==
From: "Rune Torgersen" <runet@innovsys.com>
To: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
When booting v2.6.25.4-rt1 (PREEMPT-RT) on my 8280 CPU with 1 GB RAM, I
get the following oopses.
They both are caused by a BUG_ON in kmap_atomic
(include/asm-powerpc/highmem.h).

If I boot with mem=512M or mem=768M they do not appear.

Any help is greatly appreciated.


Oops: Exception in kernel mode, sig: 5 [#1]
PREEMPT Innovative Systems ApMax
Modules linked in:
NIP: c005e780 LR: c005e758 CTR: 00000000
REGS: ef2c1d20 TRAP: 0700   Not tainted  (2.6.25.4-rt1)
MSR: 00029032 <EE,ME,IR,DR>  CR: 48222482  XER: 20000000
TASK = ef2a1a90[98] 'S21initenv' THREAD: ef2c0000
GPR00: 3ffcf581 ef2c1dd0 ef2a1a90 00000000 c02cae8c 00000002 00000001
3ffcf580
GPR08: 00000000 c0370000 00000000 c037000c 28222484 1009ecc0 00000000
100a5838
GPR16: 10090000 10090000 00000000 00000000 10090000 ef2a7100 3ee38385
100955ac
GPR24: 00000000 ef2a4ef0 00000000 c27dc700 c27dcb80 00000003 ef359040
c0334f88
NIP [c005e780] do_wp_page+0x650/0xc2c
LR [c005e758] do_wp_page+0x628/0xc2c
Call Trace:
[ef2c1dd0] [c005e758] do_wp_page+0x628/0xc2c (unreliable)
[ef2c1e10] [c0012420] do_page_fault+0x338/0x4b4
[ef2c1f40] [c0010120] handle_page_fault+0xc/0x80
--- Exception: 301 at 0x100322e0
    LR = 0x100322dc
Instruction dump:
409e0594 4810f2e1 3d20c035 1fa3000f 8129b140 3bbd0003 57ab103a 7c0b482e
7d6b4a14 540007fa 30e0ffff 7cc70110 <0f060000> 3d20c035 3d40c035
8129b480
Oops: Exception in kernel mode, sig: 5 [#2]
PREEMPT Innovative Systems ApMax
Modules linked in:
NIP: c005db0c LR: c005dae4 CTR: 00000000
REGS: ef29fd00 TRAP: 0700   Tainted: G      D   (2.6.25.4-rt1)
MSR: 00029032 <EE,ME,IR,DR>  CR: 48002482  XER: 20000000
TASK = ef26e070[102] 'sed' THREAD: ef29e000
GPR00: 3ee2d581 ef29fdb0 ef26e070 00000000 c02cae8c 00000000 00000001
3ee2d580
GPR08: 00000000 c0370000 00000000 c037000c 00000722 1009ecc0 4802dfa4
4802d878
GPR16: 0014f73c 00000000 00000000 00000003 4802cce0 00000000 00000001
02000000
GPR24: ef3592e0 0ffece1c ef3592e0 ef2a50fc ef2a4df4 00000003 c27dcfe0
c27ff4c0
NIP [c005db0c] __do_fault+0x1e0/0x804
LR [c005dae4] __do_fault+0x1b8/0x804
Call Trace:
[ef29fdb0] [c005dae4] __do_fault+0x1b8/0x804 (unreliable)
[ef29fe10] [c0012420] do_page_fault+0x338/0x4b4
[ef29ff40] [c0010120] handle_page_fault+0xc/0x80
--- Exception: 301 at 0x48017b10
    LR = 0x48007ac8
Instruction dump:
409e060c 4810ff55 3d20c035 1fa3000f 8129b140 3bbd0003 57ab103a 7c0b482e
7d6b4a14 540007fa 30e0ffff 7cc70110 <0f060000> 3d20c035 3d40c035
8129b480

