Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbXJYTXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbXJYTXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 15:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbXJYTWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 15:22:51 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:26000 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbXJYTWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 15:22:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=VEakg1gwHHEB7OMppSzsYEhmQG1YTL4yf2YDxVqC0gTdn8Min4e51qH5/6L19o9Lc2WaaGzSY6nrWjiegKpqphCjLRU578LxQYQvZlDJ0wvNzQOcQoL5b+tx7fNNQaPu+1Dd6/MQMhsxnBYj5nCzVSoQkUdmzpf8adrZ29RTbgI=
Date: Thu, 25 Oct 2007 21:22:40 -0700
To: Paul Mundt <lethal@linux-sh.org>
Cc: linuxsh <linuxsh-dev@lists.sourceforge.net>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: [SUPERH / PATA / SCSI] Unable to do start userland after kernel
 boot
Message-Id: <20071025212240.a50c18b6.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I know I'm being annoying about this, but kinda a show stopper for hp6xx currently.
I compaired a bootlog (good kernel vs bad kernel), and they are identical apart from this stuff

The bottom line seems to be that it fails to attach scsi sg0. It explains why it doesn't work, but not why it stopped working. And this has nothing to do with the current kernel config, I've been over that the last 4 days. It all started when I synced my jlime-current.git repository with linux-2.6.git. As you can see I had 2.6.23-rc6 and then synced up to 2.6.23-rc8/rc9 and thats when the troubles started.

Any scsi/libata gurus giving feedback on this would be appreciated.

Best wishes
Kristoffer Ericson

[BAD KERNEL]
(Linux version 2.6.23-gbc53c3a1-dirty (kristoffer@Wolverine) (gcc version 3.4.5) #2 Tue Oct 23 19:34:27 PDT 2007)
scsi0 : pata_platform
ata1: PATA max PIO0 mmio cmd 0x150001f0 ctl 0x150001fe irq 77  <-- "mmio cmd" + ""
ata1.00: CFA: Hitachi XX.V.3.5.0.0, Rev 0.00, max PIO4
ata1.00: 2002896 sectors, multi 0: LBA
ata1.00: configured for PIO
scsi 0:0:0:0: Direct-Access     ATA      Hitachi XX.V.3.5 Rev  PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 2002896 512-byte hardware sectors (1025 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 2002896 512-byte hardware sectors (1025 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI removable disk
.........
.........
........
EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
VFS: Mounted root (ext2 filesystem).
Freeing unused kernel memory: 128k freed
Failed to execute /bin/sh.  Attempting defaults...
Kernel panic - not syncing: No init found.  Try passing init= option to kernel.


[GOOD KERNEL]
(Linux version 2.6.23-rc6-gab762e2c-dirty (rafa@nodo3) (gcc version 3.4.4) #51 Sun Oct 21 15:23:19 ART 2007)
scsi0 : pata_platform
ata1: PATA max PIO0 cmd 0xb50001f0 ctl 0xb50001fe bmdma 0x00000000 irq 77 <--- "cmd" + "bmdma"
ata1.00: CFA: Hitachi XX.V.3.5.0.0, Rev 0.00, max PIO4
ata1.00: 2002896 sectors, multi 0: LBA
ata1.00: configured for PIO
ata1: EH pending after completion, repeating EH (cnt=4)
scsi 0:0:0:0: Direct-Access     ATA      Hitachi XX.V.3.5 Rev  PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 2002896 512-byte hardware sectors (1025 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 2002896 512-byte hardware sectors (1025 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI removable disk
sd 0:0:0:0: Attached scsi generic sg0 type 0   <---- Only here, missing from bad kernel.
............
...........
.............
EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
VFS: Mounted root (ext2 filesystem).
Freeing unused kernel memory: 140k freed
/bin/sh: can't access tty; job control turned off       (init=/bin/sh was used as bootparam)
/ $ 
