Return-Path: <linux-kernel-owner+w=401wt.eu-S1760107AbZC3Wld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107AbZC3Wld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbZC3WlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:41:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:65151 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbZC3WlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:41:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=VCrPmSZPeSE6dbC4+60mxN/dLqBaxt1JrD6WNv/vMSk9M2npyEP6d+dwUDZzmZoyu5
         5SlWkZR/NkVD1luK3HU7U9XQfdIWqwQm2WDY7MU+JbQ35cJCjTb6kCMEfybebC54JcRa
         kFnexNSG0nrTvwCNysOw/7CMqDxTGjhi7W+7s=
Date: Tue, 31 Mar 2009 02:48:44 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org, jlayton@redhat.com
Subject: [GIT] /proc update
Message-ID: <20090330224844.GA19892@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc.git proc-linus
to get
a) long pending struct proc_dir_entry::owner removal
b) /proc/uptime change back to seqfiles now that pread(2) on seqfiled
   files works
c) minor stuff

Alexey Dobriyan (3):
      proc 1/2: do PDE usecounting even for ->read_proc, ->write_proc
      proc 2/2: remove struct proc_dir_entry::owner
      Revert "proc: revert /proc/uptime to ->read_proc hook"

Milind Arun Choudhary (1):
      proc: fix sparse warnings in pagemap_read()

Randy Dunlap (1):
      proc: move fs/proc/inode-alloc.txt comment into a source file

 Documentation/DocBook/procfs_example.c  |    9 ----
 arch/alpha/kernel/srm_env.c             |    5 --
 arch/blackfin/mm/sram-alloc.c           |    1 -
 arch/ia64/kernel/palinfo.c              |    2 -
 arch/ia64/sn/kernel/sn2/prominfo_proc.c |    9 +---
 arch/powerpc/kernel/rtas_flash.c        |    1 -
 arch/sparc/kernel/led.c                 |    1 -
 arch/x86/kernel/cpu/mtrr/if.c           |   10 +----
 drivers/acpi/ac.c                       |    1 -
 drivers/acpi/battery.c                  |    1 -
 drivers/acpi/button.c                   |    3 -
 drivers/acpi/fan.c                      |    2 -
 drivers/acpi/processor_core.c           |    2 -
 drivers/acpi/sbs.c                      |    1 -
 drivers/acpi/thermal.c                  |    2 -
 drivers/acpi/video.c                    |    5 --
 drivers/block/ps3vram.c                 |    2 -
 drivers/char/ipmi/ipmi_msghandler.c     |   12 ++----
 drivers/char/ipmi/ipmi_si_intf.c        |    6 +-
 drivers/input/input.c                   |    2 -
 drivers/isdn/hardware/eicon/divasi.c    |    1 -
 drivers/media/video/cpia.c              |    4 +-
 drivers/message/i2o/i2o_proc.c          |    2 -
 drivers/net/bonding/bond_main.c         |   35 +----------------
 drivers/net/irda/vlsi_ir.c              |    7 ---
 drivers/net/wireless/airo.c             |    1 -
 drivers/platform/x86/asus_acpi.c        |    3 -
 drivers/platform/x86/thinkpad_acpi.c    |    2 -
 drivers/platform/x86/toshiba_acpi.c     |    3 -
 drivers/rtc/rtc-proc.c                  |   10 +----
 drivers/s390/block/dasd_proc.c          |    2 -
 drivers/scsi/scsi_devinfo.c             |    2 -
 drivers/scsi/scsi_proc.c                |    3 -
 drivers/video/via/viafbdev.c            |    5 --
 fs/afs/proc.c                           |    1 -
 fs/cifs/cifs_debug.c                    |    1 -
 fs/jfs/jfs_debug.c                      |    1 -
 fs/nfs/client.c                         |    2 -
 fs/proc/generic.c                       |   63 ++++++++++++++++++++++++++-----
 fs/proc/inode-alloc.txt                 |   14 -------
 fs/proc/inode.c                         |   21 ++--------
 fs/proc/internal.h                      |    1 +
 fs/proc/proc_tty.c                      |    1 -
 fs/proc/task_mmu.c                      |    8 ++--
 fs/proc/uptime.c                        |   38 +++++++++----------
 fs/reiserfs/procfs.c                    |    5 +--
 include/linux/ipmi_smi.h                |    2 +-
 include/linux/proc_fs.h                 |    4 --
 net/appletalk/atalk_proc.c              |    1 -
 net/atm/mpoa_proc.c                     |    1 -
 net/atm/proc.c                          |    1 -
 net/can/bcm.c                           |    4 --
 net/can/proc.c                          |    2 -
 net/core/pktgen.c                       |    1 -
 net/irda/irproc.c                       |    1 -
 net/llc/llc_proc.c                      |    1 -
 net/sctp/protocol.c                     |    8 +---
 net/sunrpc/cache.c                      |    4 --
 net/sunrpc/stats.c                      |   10 +----
 sound/core/info.c                       |   31 +--------------
 60 files changed, 103 insertions(+), 281 deletions(-)
 delete mode 100644 fs/proc/inode-alloc.txt
