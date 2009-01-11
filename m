Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbZAKV2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbZAKV2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZAKV2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:28:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:21342 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZAKV2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:28:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=X3ihhYul+CaVQr/09SZL3GTaWMzTylTY1Yye0NSPdqpK+ZhybgD+XHMvEebnZVA3gg
         fjUuUw5CgQbQz7dt+NvXS9+uYyTTaOCpEqMs+EmKSMhkr3NtH2p67zsKhA9WQKJN6BK2
         RBNHBeb3BWsccpaOvm7DP6Yxi6BW6GsYUSg98=
Message-ID: <8db1092f0901111328m5bf74c8bh6361f8845f767d45@mail.gmail.com>
Date: Sun, 11 Jan 2009 22:28:17 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jeff Garzik" <jgarzik@pobox.com>
Subject: Re: Linux 2.6.29-rc1
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During booting system stops on this message:
http://unixy.pl/maciek/download/kernel/2.6.29-rc1/laptop/img_0001.jpg

Probably I have two separate problems: warning (fragment is visible on
top) and freeze of system. I try bisect, but I have problem:

root@gumis:/usr/src/git/linux-2.6# git bisect start
root@gumis:/usr/src/git/linux-2.6# git bisect bad
root@gumis:/usr/src/git/linux-2.6# git bisect good v2.6.28
Bisecting: 4660 revisions left to test after this
[590cf28580c999c8ba70dc39b40bab09d69e2630] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
root@gumis:/usr/src/git/linux-2.6# git bisect good
Bisecting: 2293 revisions left to test after this
[5e07878787ad07361571150230cc3a8d522ae046] debugfs: add helpers for
exporting a size_t simple value
root@gumis:/usr/src/git/linux-2.6# git bisect good
Bisecting: 1158 revisions left to test after this
[a3a798c88a14b35e5d4ca30716dbc9eb9a1ddfe2] Merge branch 'release' of
git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6
root@gumis:/usr/src/git/linux-2.6# git bisect good
Bisecting: 579 revisions left to test after this
[e7a84565bcdb239caad29ccbe559ef978090ac7e] Btrfs: Add btree locking to
the tree defragmentation code
root@gumis:/usr/src/git/linux-2.6# ls -la
razem 16
drwxr-xr-x 4 root root 4096 sty 11 22:07 .
drwxr-xr-x 3 root root 4096 sty 11 21:47 ..
drwxr-xr-x 3 root root 4096 sty 11 22:07 fs
drwxr-xr-x 8 root root 4096 sty 11 22:07 .git

I have only "fs" and ".git" directory after last "git bisect good".
How to avoid this problem?

During bisect, when I can boot i saw full warning from top of the picture:
[    1.669554]  sda: sda1 sda2 sda3 sda4 < sda5 sda6<4>------------[
cut here ]------------
[    1.720412] WARNING: at drivers/ata/libata-sff.c:1017
ata_sff_hsm_move+0x694/0x830()
[    1.720412] Hardware name: HP Compaq nx6310 (EY501ES#AKD)
[    1.720412] Modules linked in:
[    1.720412] Pid: 0, comm: swapper Not tainted 2.6.28 #1
[    1.720412] Call Trace:
[    1.720412]  [<c012e967>] warn_slowpath+0x87/0xe0
[    1.720412]  [<c0120f0a>] place_entity+0x7a/0xf0
[    1.720412]  [<c0123aef>] enqueue_entity+0x11f/0x190
[    1.720412]  [<c012406e>] enqueue_task_fair+0x2e/0x70
[    1.720412]  [<c0121ad8>] activate_task+0x28/0x50
[    1.720412]  [<c0128b8f>] try_to_wake_up+0x10f/0x190
[    1.720412]  [<c02d1a60>] scsi_eh_scmd_add+0x70/0xb0
[    1.720412]  [<c02f13ab>] ata_sff_data_xfer32+0x7b/0xd0
[    1.720412]  [<c02f0c84>] ata_sff_hsm_move+0x694/0x830
[    1.720412]  [<c02d2e70>] scsi_next_command+0x30/0x50
[    1.720412]  [<c02f10fe>] ata_sff_interrupt+0x15e/0x260
[    1.720412]  [<c016aa38>] handle_IRQ_event+0x28/0x50
[    1.720412]  [<c016bec9>] handle_edge_irq+0x99/0x110
[    1.720412]  [<c0105623>] do_IRQ+0x43/0x90
[    1.720412]  [<c0103967>] common_interrupt+0x27/0x2c
[    1.720412]  [<c02968e0>] acpi_idle_enter_simple+0x190/0x1fe
[    1.720412]  [<c01486c5>] sched_clock_idle_wakeup_event+0x15/0x20
[    1.720412]  [<c030b995>] menu_select+0x35/0xf0
[    1.720412]  [<c030ac5f>] cpuidle_idle_call+0x6f/0xc0
[    1.720412]  [<c01022e0>] cpu_idle+0x60/0xc0
[    1.720412]  [<c04a0865>] start_kernel+0x2b5/0x318
[    1.720412]  [<c04a037d>] unknown_bootoption+0x0/0x1e5
[    1.720412] ---[ end trace fd2c7b706ba402fc ]---
[    2.052419]  sda7 >

full dmesg:
http://unixy.pl/maciek/download/kernel/2.6.29-rc1/laptop/dmesg-2.6.29-rc1-during_bisect.txt

Config from 2.6.29-rc1:
http://unixy.pl/maciek/download/kernel/2.6.29-rc1/laptop/config-2.6.29-rc1

dmesg from 2.6.28 (not from 2.6.29-rc1):
http://unixy.pl/maciek/download/kernel/2.6.29-rc1/laptop/dmesg-2.6.28.txt

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
