Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZC3Obr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZC3Obr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbZC3Oay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:30:54 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:39922 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbZC3Oav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:30:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=ez2NdbZ+UKokoy4H3mbpwUeVHtDDfznvD6XMr9imkb310ld7XJ6FheHgkhcNTKq3uw
         ta5uk+RjFSERuu6RKT7Rc6yURmPWGNQzu1RiCjzFrWPN1O5687evhYx7ECBuyMeFUe0O
         ZeOZTWaYSBdvTMoW3cbG5S4uGgaK1NE+UP2IQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] IDE updates part 2
Date: Mon, 30 Mar 2009 16:33:19 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090327-dirty; KDE/4.2.1; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200903271302.56379.bzolnier@gmail.com>
In-Reply-To: <200903271302.56379.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903301633.19485.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 March 2009, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> More "uninteresting" IDE changes:
> 
> - make all host drivers use struct ide_port_info
> - sanitize command/request completion API
> - replace ide_task_t by struct ide_cmd
> - improve debugging scheme (from Borislav Petkov)
> - misc fixes/cleanups

ping?

These changes are not _that_ uninteresting to not apply them. ;)

More importantly they are holding back "part 3"...

> Linus, please pull from:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/
> 
> to receive the following updates:
> 
>  arch/m68k/include/asm/ide.h |   73 -------
>  drivers/ide/alim15x3.c      |    9 +-
>  drivers/ide/at91_ide.c      |   70 ++++----
>  drivers/ide/au1xxx-ide.c    |   39 +---
>  drivers/ide/buddha.c        |   11 +-
>  drivers/ide/cmd64x.c        |    6 +-
>  drivers/ide/cs5536.c        |    2 +-
>  drivers/ide/delkin_cb.c     |    1 +
>  drivers/ide/dtc2278.c       |    3 +-
>  drivers/ide/falconide.c     |   45 ++++-
>  drivers/ide/gayle.c         |    7 +-
>  drivers/ide/hpt366.c        |    6 +-
>  drivers/ide/icside.c        |   24 +--
>  drivers/ide/ide-4drives.c   |    3 +-
>  drivers/ide/ide-acpi.c      |   10 +-
>  drivers/ide/ide-atapi.c     |  123 +++++++-----
>  drivers/ide/ide-cd.c        |  155 ++++++++-------
>  drivers/ide/ide-cd.h        |    4 +-
>  drivers/ide/ide-cs.c        |    1 +
>  drivers/ide/ide-devsets.c   |    4 +-
>  drivers/ide/ide-disk.c      |  171 ++++++++---------
>  drivers/ide/ide-disk_proc.c |   28 ++--
>  drivers/ide/ide-dma-sff.c   |   37 ++---
>  drivers/ide/ide-dma.c       |   39 ++--
>  drivers/ide/ide-eh.c        |   30 ++-
>  drivers/ide/ide-floppy.c    |  156 ++++++---------
>  drivers/ide/ide-gd.c        |   10 +-
>  drivers/ide/ide-gd.h        |    4 +-
>  drivers/ide/ide-generic.c   |    8 +-
>  drivers/ide/ide-h8300.c     |   66 ++++----
>  drivers/ide/ide-io-std.c    |   73 ++++----
>  drivers/ide/ide-io.c        |  285 ++++++++++-----------------
>  drivers/ide/ide-ioctls.c    |   44 ++--
>  drivers/ide/ide-iops.c      |   66 +++----
>  drivers/ide/ide-lib.c       |   20 +-
>  drivers/ide/ide-park.c      |   19 +-
>  drivers/ide/ide-pm.c        |   42 +++--
>  drivers/ide/ide-pnp.c       |    6 +-
>  drivers/ide/ide-probe.c     |   95 ++++------
>  drivers/ide/ide-proc.c      |   16 +-
>  drivers/ide/ide-tape.c      |  123 +++++--------
>  drivers/ide/ide-taskfile.c  |  448 ++++++++++++++++++++-----------------------
>  drivers/ide/ide_arm.c       |    6 +-
>  drivers/ide/it821x.c        |    2 +-
>  drivers/ide/macide.c        |    7 +-
>  drivers/ide/ns87415.c       |   36 ++--
>  drivers/ide/palm_bk3710.c   |   13 +-
>  drivers/ide/pdc202xx_old.c  |    4 +-
>  drivers/ide/pmac.c          |   32 +---
>  drivers/ide/q40ide.c        |   15 +-
>  drivers/ide/sc1200.c        |    2 +-
>  drivers/ide/scc_pata.c      |  115 +++++------
>  drivers/ide/setup-pci.c     |    4 +
>  drivers/ide/sgiioc4.c       |   30 +--
>  drivers/ide/siimage.c       |    2 +-
>  drivers/ide/sl82c105.c      |    2 +-
>  drivers/ide/tc86c001.c      |    2 +-
>  drivers/ide/trm290.c        |   15 +-
>  drivers/ide/tx4938ide.c     |   68 ++++----
>  drivers/ide/tx4939ide.c     |  109 +++++------
>  include/linux/ide.h         |  239 ++++++++++++-----------
>  61 files changed, 1418 insertions(+), 1667 deletions(-)
> 
> 
> Bartlomiej Zolnierkiewicz (67):
>       icside: use struct ide_port_info also for PCB version 5 (v2)
>       ide_arm: use struct ide_port_info
>       ide-generic: use struct ide_port_info
>       ide-pnp: use struct ide_port_info
>       buddha: use struct ide_port_info
>       macide: use struct ide_port_info
>       ide: move ->rqsize init from init_irq() to ide_init_port()
>       ide: remove IDE_ARCH_INTR (v2)
>       ide: remove IDE_ARCH_LOCK (v2)
>       ide: make m68k host drivers use IDE_HFLAG_MMIO
>       ide: cleanup <asm-m68k/ide.h>
>       at91_ide: use readsw()/writesw() directly
>       ide: include <asm/ide.h> only when needed
>       scc_pata: remove DECLARE_SCC_DEV() macro (v2)
>       ide: fix memleak on failure in probe_for_drive()
>       ide: fix error message in pre_task_out_intr()
>       ide: allow host drivers to specify IRQ flags
>       ide: remove now superfluous check from ide_host_register()
>       ide: add IDE_HFLAG_DTC2278 host flag
>       ide: add IDE_HFLAG_4DRIVES host flag
>       ide: add "flagged" taskfile flags to struct ide_taskfile (v2)
>       ide: complete power step in ide_complete_pm_request()
>       ide: factor out completion of taskfile from ide_end_drive_cmd()
>       ide: move request type specific code from ide_end_drive_cmd() to callers (v3)
>       ide: no need to read Status and Error registers for "empty" taskfile requests
>       ide: remove ->data_phase field from ide_hwif_t
>       ide: move smart_enable() call out from get_smart_data()
>       icside: icside_dma_setup() fixes
>       trm290: trm290_dma_setup() fix
>       au1xxx-ide: auide_dma_end() cleanup
>       ide: remove no longer needed PC_FLAG_TIMEDOUT packet command flag
>       ide-floppy: remove superfluous check from ide_floppy_end_request()
>       ide-tape: remove superfluous tape->lock
>       ide: move ->failed_pc to ide_drive_t
>       ide: use ->end_request only for private device driver requests
>       ide-{floppy,tape}: cleanup ide*_end_request()
>       ide: remove ->end_request method
>       ide: return request status from ->pc_callback method
>       ide: use blk_fs_request() check in ide-taskfile.c
>       ide: call ide_build_sglist() prior to ->dma_setup (v2)
>       ide: remove ide_task_t typedef
>       ide: pass command instead of request to ide_pio_datablock()
>       ide: move command related fields from ide_hwif_t to struct ide_cmd
>       ide: set IDE_TFLAG_WRITE basing on data phase used in ide_taskfile_ioctl()
>       ide: use ata_tf_protocols enums
>       ide: merge task_{in,out}_intr()
>       ide: inline task_in_unexpected() into task_pio_intr()
>       ide: unify exit paths in task_pio_intr()
>       ide: task_error() -> task_error_cmd()
>       ide: use ide_complete_cmd() for head unload commands
>       ide: use ide_complete_cmd() for REQ_UNPARK_HEADS
>       ide: sanitize ide_finish_cmd()
>       ide: make ide_special_rq() BUG() on unknown requests
>       ide: add ide_end_rq() (v2)
>       ide: sanitize ide_end_rq()
>       ide: pass error value to ide_complete_rq()
>       ide: move rq->errors quirk out from ide_end_request()
>       ide: remove BUG() from ide_complete_rq()
>       ide: pass number of bytes to complete to ide_complete_rq()
>       ide: use ide_end_rq() in ide_complete_rq()
>       ide: remove ide_end_request()
>       ide: pass command to ide_map_sg()
>       ide: use do_rw_taskfile() for ATA_CMD_PACKET commands
>       ide: set hwif->expiry prior to calling [__]ide_set_handler()
>       ide: add ->dma_timer_expiry method and remove ->dma_exec_cmd one (v2)
>       ide: remove ide_execute_pkt_cmd() (v2)
>       ide: keep track of number of bytes instead of sectors in struct ide_cmd
> 
> Borislav Petkov (2):
>       ide: improve debugging scheme
>       ide-cd: use ide_drive_t's rq in cdrom_queue_request_sense
> 
> Kevin Hilman (1):
>       IDE: palm_bk3710: use ioremap instead of arch-specific IO_ADDRESS()

[...]
