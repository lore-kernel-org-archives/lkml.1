Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbZFQQDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbZFQQDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbZFQQDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:03:42 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:49182 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbZFQQDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:03:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=EIg2dpeHRUKhPyTWGEzxGzRsu9t8pHYY7F0ZyEmbKWs8vBNWAbHCRcwdmnDpRZp5mn
         8wONcKju5vyYkqFwxSCIEf06LZQwfA1k5fMldJMeTZq5DsaJrQk6pZWUULL3ega/cyyQ
         dzIPrq+T8w5UZV36ESZ9fsJ3xryS6mUyajcUU=
MIME-Version: 1.0
Date: Wed, 17 Jun 2009 23:55:26 +0800
Message-ID: <b6a2187b0906170855t5dc7c0c1q48b3c7dca4254594@mail.gmail.com>
Subject: 2.6.30 - kernel BUG at lib/kernel_lock.c:126!
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Executing "mount -o remount -r" on a busy reiserfs filesystem causes
the following oops.

Sync will just hang after this oops. Happens on 2.6.30.

If there's no activity on the partition, sync, sync, and remount as
read-only will be ok. No oops.

Bisect?

Thanks,
Jeff.


------------[ cut here ]------------
kernel BUG at lib/kernel_lock.c:126!
invalid opcode: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_max_freq
Modules linked in: 8250 serial_core sr_mod cdrom vmnet vmmon vmci
iwlagn iwlcore mac80211 cfg80211 [last unloaded: vmci]

Pid: 12074, comm: mount Not tainted (2.6.30 #2) 7676A24
EIP: 0060:[<c13bbae3>] EFLAGS: 00010286 CPU: 0
EIP is at unlock_kernel+0x10/0x3c
EAX: 00000000 EBX: f32d7400 ECX: f32d7494 EDX: f77b9810
ESI: f32d7400 EDI: 00000000 EBP: f2918f20 ESP: f2918f20
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process mount (pid: 12074, ti=f2918000 task=f77b9810 task.ti=f2918000)
Stack:
 f2918f38 c107522d 00000001 00000021 f32d7400 00000000 f2918f88 c1085f9b
 00000000 f2a40000 00000048 f32d743c 00000001 f15ec000 00000000 f2918f64
 00000021 f2918f90 c1084d00 f2a59000 00001000 f6d59880 f72da4c8 00000000
Call Trace:
 [<c107522d>] ? do_remount_sb+0x63/0xaa
 [<c1085f9b>] ? do_mount+0x1f8/0x63c
 [<c1084d00>] ? copy_mount_options+0x27/0x10d
 [<c108643e>] ? sys_mount+0x5f/0x96
 [<c1002990>] ? sysenter_do_call+0x12/0x2c
Code: 00 88 5a c1 0f 94 c2 0f b6 c2 85 c0 74 b8 64 a1 00 10 60 c1 89
70 14 5b 5e 5d c3 55 64 8b 15 00 10 60 c1 83 7a 14 00 89 e5 79 04 <0f>
0b eb fe 8b 42 14 48 85 c0 89 42 14 79 1b fe 05 00 88 5a c1
EIP: [<c13bbae3>] unlock_kernel+0x10/0x3c SS:ESP 0068:f2918f20
