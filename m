Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbZAFPN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbZAFPN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 10:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbZAFPNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 10:13:17 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:61856 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZAFPNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 10:13:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=appXVj5VDgsCWfnnxepE00IDlpzoKdG6n8CGaGv6+Rgsluh3JHCKrEmosDx3F0G9PB
         NpTU72xcFi2c4PeiUTw8WnulJi/sMg8LHOekrFi0oG0kbHRDvdvkrlzteG6/2H+IXnzp
         ZA78oAFlMhHwiVscXU4pIgihwuW2ivetko5Pc=
Message-ID: <c4e36d110901060713w28a6e3acq47e91ec53b4b6344@mail.gmail.com>
Date: Tue, 6 Jan 2009 16:13:14 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: kvm poweroff deadlock
Cc: "Avi Kivity" <avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

While testing latest  2.6.29-rc  inside qemu-kvm guest I've got this
deadlock while executing poweroff:

sd 0:0:0:0: [sda] Stopping disk

ACPI: Preparing to enter system sleep state S5

Disabling non-boot CPUs ...

BUG: spinlock lockup on CPU#0, halt/2389, ffff88001dc0c3c0

Pid: 2389, comm: halt Not tainted 2.6.28 #103

Call Trace:

 [<ffffffff803aa3f8>] _raw_spin_lock+0x158/0x170

 [<ffffffff80538924>] _spin_lock_irqsave+0x64/0x90

 [<ffffffff80259268>] ? __queue_work+0x18/0x90

 [<ffffffff80259268>] __queue_work+0x18/0x90

 [<ffffffff8025936d>] queue_work_on+0x4d/0x60

 [<ffffffff80286ca7>] __stop_machine+0xe7/0x140

 [<ffffffff80523930>] _cpu_down+0x120/0x2f0

 [<ffffffff802469da>] disable_nonboot_cpus+0x8a/0x120

 [<ffffffff802571d1>] kernel_power_off+0x21/0x50

 [<ffffffff802574b0>] sys_reboot+0x110/0x230

 [<ffffffff8023c11f>] ? finish_task_switch+0x5f/0x120

 [<ffffffff8023c0c0>] ? finish_task_switch+0x0/0x120

 [<ffffffff8053540b>] ? thread_return+0x3d/0x702

 [<ffffffff80254509>] ? sys_kill+0xd9/0x200

 [<ffffffff802544ad>] ? sys_kill+0x7d/0x200

 [<ffffffff805380dc>] ? lockdep_sys_exit_thunk+0x35/0x67

 [<ffffffff80538066>] ? trace_hardirqs_on_thunk+0x3a/0x3f

 [<ffffffff80231a48>] sysenter_dispatch+0x7/0x2c

 [<ffffffff80538066>] ? trace_hardirqs_on_thunk+0x3a/0x3f



Zdenek
