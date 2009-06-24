Return-Path: <linux-kernel-owner+w=401wt.eu-S1759585AbZFXOZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585AbZFXOZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZFXOZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:25:00 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:47325 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZFXOY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:24:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bPk6egCpSPBFb1bqFwDa11oLDCWhTXu8/jEjQNgqnxVLIYUQMcf0Pgi0aQs/vREDpP
         QGjyFMtpIdsGnRTS8KPzoAAEpIAp1/6Er9tSzI7WYAVW6slzyzV5S+6LbdK7efJ+/J0e
         9DeknWIs8IAbiph2etr+3/QoYZBY8pyHLcB2g=
MIME-Version: 1.0
Date: Wed, 24 Jun 2009 16:25:01 +0200
Message-ID: <87271a2c0906240725s538b608asd7ea6467962b320@mail.gmail.com>
Subject: Unionfs BUG: null pointer dereference unionfs_setattr
From: Bart van der Meulen <bartvdrmeulen@gmail.com>
To: unionfs@filer.fsl.cs.sunysb.edu, linux-kernel@vger.kernel.org
Cc: ezk@cs.sunysb.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following stack trace occurs when using the vacuum command on a
database within sqlite 3.6.15

Kernel is an 2.6.24.7-rt27 build with unionfs 2.5.2 applied

Does somebody recognized this or known how to solve it?


BUG: unable to handle kernel NULL pointer dereference at virtual
address 000000dc
printing eip: c02062a9 *pde = 00000000
Oops: 0000 [#1] PREEMPT SMP
Modules linked in: fschmd i2c_i801 i2c_core usb_storage ehci_hcd uhci_hcd

Pid: 2923, comm: sqlite.bin Not tainted (2.6.24-RGL_1.2.1 #1)
EIP: 0060:[<c02062a9>] EFLAGS: 00010202 CPU: 0
EIP is at unionfs_setattr+0x199/0x400
EAX: 00000000 EBX: f779af28 ECX: 00000000 EDX: f6d553e0
ESI: f779af20 EDI: f7780520 EBP: f6a4dee8 ESP: f6a4de98
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 preempt:00000001
Process sqlite.bin (pid: 2923, ti=f6a4c000 task=f788edb0 task.ti=f6a4c000)
Stack: f6d6e440 f68dc0f8 00000000 00000000 00000000 00000000 f6a4df28 f77805c8
       f6a4ded8 00000000 f779ade8 f74345fc 00000000 00000000 f6a4df28 00002068
       f77804dc f6a4df28 00002068 f7780520 f6a4df20 c019f07a c01505a2 00000000
Call Trace:
 [<c01064aa>] show_trace_log_lvl+0x1a/0x30
 [<c0106576>] show_stack_log_lvl+0xb6/0xe0
 [<c0106664>] show_registers+0xc4/0x1f0
 [<c01068ab>] die+0x11b/0x230
 [<c0120b14>] do_page_fault+0x224/0x5c0
 [<c04bc302>] error_code+0x72/0x78
 [<c019f07a>] notify_change+0x2da/0x310
 [<c0188b37>] do_truncate+0x67/0x90
 [<c0188cb5>] do_sys_ftruncate+0x155/0x170
 [<c0188ceb>] sys_ftruncate64+0x1b/0x20
 [<c0105412>] sysenter_past_esp+0x5f/0x85
 =======================
Code: 8b 55 e4 8b 46 6c 85 d2 0f 88 7c 02 00 00 8b 80 68 02 00 00 8b
50 40 8b 45 e4 c1 e0 04 f6 44 10 08 02 0f 84 5c 01 00 00 8b 4d e0 <8b>
81 dc 0000 00 f6 40 30 01 0f 85 49 01 00 00 8b 45 c8 f6 00
EIP: [<c02062a9>] unionfs_setattr+0x199/0x400 SS:ESP 0068:f6a4de98
---[ end trace b0cab3a2f24f8544 ]---
