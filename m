Return-Path: <linux-kernel-owner+w=401wt.eu-S1762763AbYEYM1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762763AbYEYM1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 08:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760330AbYEYM1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 08:27:30 -0400
Received: from smtp-01.datacomm.ch ([212.40.2.26]:60798 "EHLO
	smtp-01.datacomm.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760100AbYEYM13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 08:27:29 -0400
Subject: SB600 AHCI: Hard Disk Corruption
From: Patrick <ragamuffin@datacomm.ch>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Sun, 25 May 2008 14:10:35 +0200
Message-Id: <1211717435.6038.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello (Tejun Heo *)

I've got an annoying problem with my athlon 64bit, 4gb ram, ﻿asus m2a-vm
(->SB600 AHCI controller), SAMSUNG HD501LJ SATA Disk. I'm using kernel
2.6.26-rc3. Everything works fine, expect for standby/suspend/hibernate.
Standby freezes, hibernate, I acually ﻿haven't tested lately cause I
want suspend to ram to work first.

"echo mem > /sys/power/state; vbetool post;" (on text console)
successfully suspends the system and it resumes as well, BUT: After
resuming, things quickly turn bad: "file not fonund", kernel reports
ext2 errors on root (lvm) partition. After a (hard) reboot the root
fileystem won't even be recognized again by mount and e2fschk can harldy
recover it (thousands of inodes go to lost+found, have to restore
backups to make the system work again). This happend even when the
partition was mounted _readonly_ and it happens to ALL partitions
mounted during suspend. ** I'm testing now by appending break=init to
the kernel command line, getting to a busybox on the initramfs, and then
unmounting "root" before suspending. From there i can dmesg to see
what's happening (though the dmesg buffer is quiet small...can i
increase that in proc somewhere?). I'd be willing to test and send
whatever logs you need to get this fixed.

Some additional infos: Upgrading from 2.6.24, I hoped the
AHCI_HFLAG_NO_MSI in drivers/ata/ahci.c might solve the issue - no luck.
All the other sb600 workarounds: obviousley no luck as well.
irqpoll: slightly different behaviour when unloading sd_mod and ahci
modules before suspending:
without irqpoll, the disk ([sda]) doesn't show up again after "modprobe
ahci; modprobe sd_mod" and I get ﻿"ata5.00: failed to IDENTIFY [...]
err_mask=0x80" "failed to restore some devices [...]" errors
with irqpoll, disk shows up again and no errors, but "there is different
data" on each read (head -c10000) from /dev/sda. Though the disk is not
changed, after rebooting it contains the original data. I just wonder
how the data is "created" - it seems to be disk content from different
locations (not beginning) on the disk - if i "dd if=/dev/sda
of=/dev/null", i hear the disk reading data....

Well - I hope you might be able to make some sense of that and tell me
what logs and dumps exactly you need to fix it...

Greets - Patrick



* I read many threads in which Tejun provided patches for the SB600 AHCI
Controller which seems to be seriously broken - if only i knew that in
advance... Maybe he can fix this issue as well - last ressort. Otherwise
I'll burn that mobo!

﻿** After my firs install and configuring the system for a day, trying
out suspend to ram smashed it with no backups, since then i didn't learn
my lesson and smashed it again 2-3 times, this time with backups at hand
though, ...



