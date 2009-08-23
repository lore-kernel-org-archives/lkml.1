Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbZHWHgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbZHWHgL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 03:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbZHWHgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 03:36:10 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:53276 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbZHWHgJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 03:36:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qDUeGahiitQquuL/ED6ba5YtnzTp93OxGCWbI1S3nrkNpypAUtKRFKBKjIC1Qpu3iz
         LeRu6x6DVumu3aiRuOCBmjHmR8N3nqcs33q1LE+IkdP0HfQomifr5DzXFW8xwiofwqod
         SGVix0JLizM8t/yo3SdCkfbUmtSANK9VwUWa4=
MIME-Version: 1.0
In-Reply-To: <e2e108260908230034k7fc0c1f4g3163a65fdfc26e8a@mail.gmail.com>
References: <e2e108260908230034k7fc0c1f4g3163a65fdfc26e8a@mail.gmail.com>
Date: Sun, 23 Aug 2009 09:36:10 +0200
Message-ID: <e2e108260908230036x6e0bfa63y66675c55131a8008@mail.gmail.com>
Subject: 2.6.31-rc3: lockdep warning triggered by dup_fd
From: Bart Van Assche <bart.vanassche@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Roland Dreier <rdreier@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The backtrace below has been observed once with a kernel compiled from
an unmodified infiniband git tree
(http://git.kernel.org/?p=linux/kernel/git/roland/infiniband.git). Has
anyone observed similar behavior before ? Is this a known issue that
has already been fixed in a more recent release candidate of the
2.6.31 kernel ?

Bart.

------------[ cut here ]------------
WARNING: at kernel/lockdep.c:732 register_lock_class+0x149/0x450()
Hardware name: P5Q DELUXE
Modules linked in: af_packet cpufreq_conservative cpufreq_userspace
cpufreq_powersave acpi_cpufreq fuse md_mod dm_mod coretemp hwmon
8250_pnp 8250 pcspkr serial_core button mlx4_core sky2 sr_mod sg
sd_mod uhci_hcd ehci_hcd usbcore ext3 mbcache jbd fan ide_pci_generic
ide_core ata_generic ata_piix thermal processor pata_jmicron ahci
Pid: 2595, comm: ifup Tainted: G        W  2.6.31-rc3-default #1
Call Trace:
 [<ffffffff8106f939>] ? register_lock_class+0x149/0x450
 [<ffffffff81046cb8>] warn_slowpath_common+0x78/0xd0
 [<ffffffff81046d1f>] warn_slowpath_null+0xf/0x20
 [<ffffffff8106f939>] register_lock_class+0x149/0x450
 [<ffffffff81072c2a>] __lock_acquire+0x49a/0x1230
 [<ffffffff81071ea4>] ? debug_check_no_locks_freed+0x94/0x160
 [<ffffffff81071dad>] ? trace_hardirqs_on_caller+0x14d/0x1a0
 [<ffffffff81073a16>] lock_acquire+0x56/0x80
 [<ffffffff810ddc2d>] ? dup_fd+0xbd/0x380
 [<ffffffff81314ef1>] _spin_lock+0x31/0x70
 [<ffffffff810ddc2d>] ? dup_fd+0xbd/0x380
 [<ffffffff810ddc2d>] dup_fd+0xbd/0x380
 [<ffffffff8103a41c>] ? set_task_cpu+0x5c/0x210
 [<ffffffff81045746>] copy_process+0x956/0x13d0
 [<ffffffff81046247>] do_fork+0x87/0x3f0
 [<ffffffff810713b5>] ? lock_release_holdtime+0x35/0x1b0
 [<ffffffff81071dad>] ? trace_hardirqs_on_caller+0x14d/0x1a0
 [<ffffffff81071e0d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81314cab>] ? _spin_unlock_irq+0x2b/0x40
 [<ffffffff8100b4dc>] ? sysret_check+0x27/0x62
 [<ffffffff81009c03>] sys_clone+0x23/0x30
 [<ffffffff8100b813>] stub_clone+0x13/0x20
 [<ffffffff8100b4ab>] ? system_call_fastpath+0x16/0x1b
---[ end trace 7491f358a793e951 ]---
