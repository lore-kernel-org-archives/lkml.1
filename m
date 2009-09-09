Return-Path: <linux-kernel-owner+w=401wt.eu-S1751679AbZIIEML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbZIIEML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 00:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbZIIEMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 00:12:10 -0400
Received: from kroah.org ([198.145.64.141]:41373 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbZIIEMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 00:12:08 -0400
Date: Tue, 8 Sep 2009 21:08:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.32
Message-ID: <20090909040829.GA9657@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.32 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.31 and 2.6.27.32

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |    2 
 arch/x86/kvm/mmu.c                    |   63 +++++++-------
 arch/x86/kvm/svm.c                    |    1 
 arch/x86/kvm/vmx.c                    |   25 ++++-
 arch/x86/kvm/vmx.h                    |    1 
 arch/x86/kvm/x86.c                    |  146 +++++++++++++++++++++++-----------
 drivers/char/mxser.c                  |    2 
 drivers/char/nozomi.c                 |    1 
 drivers/net/ehea/ehea_main.c          |    3 
 drivers/parport/share.c               |   13 ++-
 drivers/scsi/sr_ioctl.c               |    5 +
 drivers/usb/serial/cyberjack.c        |    7 -
 drivers/usb/serial/cypress_m8.c       |    4 
 drivers/usb/serial/empeg.c            |    6 -
 drivers/usb/serial/garmin_gps.c       |    8 -
 drivers/usb/serial/generic.c          |    6 -
 drivers/usb/serial/io_edgeport.c      |    8 -
 drivers/usb/serial/io_ti.c            |    8 -
 drivers/usb/serial/ipaq.c             |    6 -
 drivers/usb/serial/ipw.c              |    3 
 drivers/usb/serial/iuu_phoenix.c      |    1 
 drivers/usb/serial/kobil_sct.c        |    6 -
 drivers/usb/serial/mos7720.c          |    7 -
 drivers/usb/serial/mos7840.c          |    6 -
 drivers/usb/serial/option.c           |    3 
 drivers/usb/serial/sierra.c           |    3 
 drivers/usb/serial/ti_usb_3410_5052.c |   17 ---
 drivers/usb/serial/visor.c            |    8 -
 fs/ocfs2/aops.c                       |   64 ++++++++++----
 include/asm-x86/kvm_host.h            |   10 ++
 include/linux/parport.h               |    4 
 include/linux/sunrpc/xprt.h           |    1 
 kernel/fork.c                         |   21 +---
 kernel/kthread.c                      |    2 
 kernel/signal.c                       |   15 +--
 net/appletalk/ddp.c                   |    1 
 net/can/raw.c                         |    1 
 net/econet/af_econet.c                |    1 
 net/irda/af_irda.c                    |    1 
 net/llc/af_llc.c                      |    1 
 net/netrom/af_netrom.c                |    1 
 net/rose/af_rose.c                    |    1 
 net/sunrpc/clnt.c                     |    1 
 net/sunrpc/xprt.c                     |    6 -
 net/sunrpc/xprtsock.c                 |   37 +++++++-
 sound/core/pcm_lib.c                  |   39 +--------
 sound/pci/hda/patch_realtek.c         |   36 +++++---
 virt/kvm/kvm_main.c                   |   57 ++++++++-----
 48 files changed, 362 insertions(+), 307 deletions(-)


Alan Cox (1):
      parport: quickfix the proc registration bug

Avi Kivity (14):
      KVM: VMX: Change cs reset state to be a data segment
      KVM: VMX: Change segment dpl at reset to 3
      KVM: Load real mode segments correctly
      KVM: Allocate guest memory as MAP_PRIVATE, not MAP_SHARED
      KVM: Don't call get_user_pages(.force = 1)
      KVM: MMU: Add locking around kvm_mmu_slot_remove_write_access()
      KVM: MMU: Flush tlbs after clearing write permission when accessing dirty log
      KVM: MMU: Fix setting the accessed bit on non-speculative sptes
      KVM: VMX: Don't allow uninhibited access to EFER on i386
      KVM: SVM: Remove port 80 passthrough
      KVM: Make EFER reads safe when EFER does not exist
      KVM: VMX: Handle vmx instruction vmexits
      KVM: Make paravirt tlb flush also reload the PAE PDPTRs
      KVM: Fix PDPTR reloading on CR4 writes

Chuck Ebbert (1):
      Remove low_latency flag setting from nozomi and mxser drivers

Clemens Ladisch (1):
      sound: pcm_lib: fix unsorted list constraint handling

Dave Hansen (4):
      KVM: Reduce kvm stack usage in kvm_arch_vm_ioctl()
      KVM: Reduce stack usage in kvm_vcpu_ioctl()
      KVM: Reduce stack usage in kvm_arch_vcpu_ioctl()
      KVM: Reduce stack usage in kvm_pv_mmu_op()

Eric Dumazet (6):
      appletalk: fix atalk_getname() leak
      can: Fix raw_getname() leak
      econet: Fix econet_getname() leak
      irda: Fix irda_getname() leak
      netrom: Fix nr_getname() leak
      rose: Fix rose_getname() leak

Glauber Costa (1):
      KVM: Don't destroy vcpu in case vcpu_setup fails

Gleb Natapov (1):
      KVM: MMU: do not free active mmu pages in free_mmu_pages()

Greg Kroah-Hartman (1):
      Linux 2.6.27.32

Hannes Hering (1):
      ehea: Fix napi list corruption on ifconfig down

Izik Eidus (1):
      KVM: Fix dirty bit tracking for slots with large pages

Jiri Slaby (1):
      NET: llc, zero sockaddr_llc struct

Joerg Roedel (1):
      KVM: add MC5_MISC msr read support

Linus Torvalds (1):
      do_sigaltstack: avoid copying 'stack_t' as a structure to user space

Marcelo Tosatti (4):
      KVM: set debug registers after "schedulable" section
      KVM: MMU: increase per-vcpu rmap cache alloc size
      KVM: x86: check for cr3 validity in mmu_alloc_roots
      KVM: MMU: protect kvm_mmu_change_mmu_pages with mmu_lock

Oleg Nesterov (2):
      clone(): fix race between copy_process() and de_thread()
      kthreads: fix kthread_create() vs kthread_stop() race

Oliver Neukum (1):
      USB: removal of tty->low_latency hack dating back to the old serial code

Peter Jones (1):
      SCSI: sr: report more accurate drive status after closing the tray.

Sheng Yang (1):
      KVM: VMX: Set IGMT bit in EPT entry

Sunil Mushran (2):
      ocfs2: Initialize the cluster we're writing to in a non-sparse extend
      ocfs2: ocfs2_write_begin_nolock() should handle len=0

Takashi Iwai (2):
      ALSA: hda - Fix MacBookPro 3,1/4,1 quirk with ALC889A
      ALSA: hda - Add missing vmaster initialization for ALC269

Trond Myklebust (2):
      SUNRPC: Fix rpc_task_force_reencode
      SUNRPC: Fix tcp reconnection

