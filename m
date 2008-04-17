Return-Path: <linux-kernel-owner+w=401wt.eu-S1764080AbYDQJL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764080AbYDQJL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757466AbYDQJKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:10:54 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58866
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420AbYDQJKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:10:52 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/45] KVM updates for the 2.6.26 merge window (part III)
Date: Thu, 17 Apr 2008 12:10:05 +0300
Message-Id: <1208423450-29415-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Third batch of the pending kvm updates.  This one contains the s390
and ia64 ports.  ppc will follow in part IV (and last).

Note that a few arch preparation patches are expected to be merged through
the arch trees; I will drop them before submitting.

 Documentation/ia64/kvm.txt     |   82 ++
 Documentation/s390/kvm.txt     |  125 +++
 MAINTAINERS                    |   10 +
 arch/ia64/Kconfig              |    3 +
 arch/ia64/Makefile             |    1 +
 arch/ia64/kernel/mca.c         |   49 +
 arch/ia64/kernel/mca_asm.S     |    5 +
 arch/ia64/kernel/smp.c         |   82 ++
 arch/ia64/kvm/Kconfig          |   46 +
 arch/ia64/kvm/Makefile         |   61 ++
 arch/ia64/kvm/asm-offsets.c    |  251 +++++
 arch/ia64/kvm/kvm-ia64.c       | 1789 +++++++++++++++++++++++++++++++++
 arch/ia64/kvm/kvm_fw.c         |  500 ++++++++++
 arch/ia64/kvm/kvm_minstate.h   |  273 +++++
 arch/ia64/kvm/lapic.h          |   25 +
 arch/ia64/kvm/misc.h           |   93 ++
 arch/ia64/kvm/mmio.c           |  341 +++++++
 arch/ia64/kvm/optvfault.S      |  918 +++++++++++++++++
 arch/ia64/kvm/process.c        |  970 ++++++++++++++++++
 arch/ia64/kvm/trampoline.S     | 1038 +++++++++++++++++++
 arch/ia64/kvm/vcpu.c           | 2163 ++++++++++++++++++++++++++++++++++++++++
 arch/ia64/kvm/vcpu.h           |  740 ++++++++++++++
 arch/ia64/kvm/vmm.c            |   66 ++
 arch/ia64/kvm/vmm_ivt.S        | 1424 ++++++++++++++++++++++++++
 arch/ia64/kvm/vti.h            |  290 ++++++
 arch/ia64/kvm/vtlb.c           |  636 ++++++++++++
 arch/ia64/mm/tlb.c             |  198 ++++
 arch/s390/Kconfig              |   14 +
 arch/s390/Makefile             |    2 +-
 arch/s390/kernel/early.c       |    4 +
 arch/s390/kernel/setup.c       |   14 +-
 arch/s390/kernel/vtime.c       |    1 +
 arch/s390/kvm/Kconfig          |   43 +
 arch/s390/kvm/Makefile         |   14 +
 arch/s390/kvm/diag.c           |   67 ++
 arch/s390/kvm/gaccess.h        |  274 +++++
 arch/s390/kvm/intercept.c      |  216 ++++
 arch/s390/kvm/interrupt.c      |  587 +++++++++++
 arch/s390/kvm/kvm-s390.c       |  673 +++++++++++++
 arch/s390/kvm/kvm-s390.h       |   64 ++
 arch/s390/kvm/priv.c           |  323 ++++++
 arch/s390/kvm/sie64a.S         |   47 +
 arch/s390/kvm/sigp.c           |  288 ++++++
 arch/s390/lib/uaccess_pt.c     |    3 +
 arch/s390/mm/pgtable.c         |   65 ++-
 arch/x86/kvm/mmu.c             |   76 ++-
 arch/x86/kvm/paging_tmpl.h     |    4 -
 arch/x86/kvm/vmx.c             |   73 ++-
 arch/x86/kvm/x86.c             |   55 +-
 drivers/s390/Makefile          |    2 +-
 drivers/s390/kvm/Makefile      |    9 +
 drivers/s390/kvm/kvm_virtio.c  |  338 +++++++
 drivers/s390/sysinfo.c         |  100 +--
 include/asm-ia64/gcc_intrin.h  |   12 +
 include/asm-ia64/kregs.h       |    3 +
 include/asm-ia64/kvm.h         |  205 ++++-
 include/asm-ia64/kvm_host.h    |  524 ++++++++++
 include/asm-ia64/kvm_para.h    |   29 +
 include/asm-ia64/processor.h   |   63 ++
 include/asm-ia64/smp.h         |    3 +
 include/asm-ia64/tlb.h         |   26 +
 include/asm-s390/Kbuild        |    1 +
 include/asm-s390/kvm.h         |   41 +-
 include/asm-s390/kvm_host.h    |  234 +++++
 include/asm-s390/kvm_para.h    |  150 +++
 include/asm-s390/kvm_virtio.h  |   53 +
 include/asm-s390/lowcore.h     |   15 +-
 include/asm-s390/mmu.h         |    1 +
 include/asm-s390/mmu_context.h |    8 +-
 include/asm-s390/pgtable.h     |   93 ++-
 include/asm-s390/setup.h       |    1 +
 include/asm-s390/sysinfo.h     |  111 ++
 include/asm-x86/kvm_host.h     |    8 +-
 include/linux/kvm.h            |   49 +
 include/linux/kvm_host.h       |    4 +
 include/linux/sched.h          |    2 +
 kernel/fork.c                  |    2 +-
 mm/rmap.c                      |    7 +-
 virt/kvm/kvm_main.c            |   17 +-
 79 files changed, 17006 insertions(+), 191 deletions(-)
 create mode 100644 Documentation/ia64/kvm.txt
 create mode 100644 Documentation/s390/kvm.txt
 create mode 100644 arch/ia64/kvm/Kconfig
 create mode 100644 arch/ia64/kvm/Makefile
 create mode 100644 arch/ia64/kvm/asm-offsets.c
 create mode 100644 arch/ia64/kvm/kvm-ia64.c
 create mode 100644 arch/ia64/kvm/kvm_fw.c
 create mode 100644 arch/ia64/kvm/kvm_minstate.h
 create mode 100644 arch/ia64/kvm/lapic.h
 create mode 100644 arch/ia64/kvm/misc.h
 create mode 100644 arch/ia64/kvm/mmio.c
 create mode 100644 arch/ia64/kvm/optvfault.S
 create mode 100644 arch/ia64/kvm/process.c
 create mode 100644 arch/ia64/kvm/trampoline.S
 create mode 100644 arch/ia64/kvm/vcpu.c
 create mode 100644 arch/ia64/kvm/vcpu.h
 create mode 100644 arch/ia64/kvm/vmm.c
 create mode 100644 arch/ia64/kvm/vmm_ivt.S
 create mode 100644 arch/ia64/kvm/vti.h
 create mode 100644 arch/ia64/kvm/vtlb.c
 create mode 100644 arch/s390/kvm/Kconfig
 create mode 100644 arch/s390/kvm/Makefile
 create mode 100644 arch/s390/kvm/diag.c
 create mode 100644 arch/s390/kvm/gaccess.h
 create mode 100644 arch/s390/kvm/intercept.c
 create mode 100644 arch/s390/kvm/interrupt.c
 create mode 100644 arch/s390/kvm/kvm-s390.c
 create mode 100644 arch/s390/kvm/kvm-s390.h
 create mode 100644 arch/s390/kvm/priv.c
 create mode 100644 arch/s390/kvm/sie64a.S
 create mode 100644 arch/s390/kvm/sigp.c
 create mode 100644 drivers/s390/kvm/Makefile
 create mode 100644 drivers/s390/kvm/kvm_virtio.c
 create mode 100644 include/asm-ia64/kvm_host.h
 create mode 100644 include/asm-ia64/kvm_para.h
 create mode 100644 include/asm-s390/kvm_host.h
 create mode 100644 include/asm-s390/kvm_para.h
 create mode 100644 include/asm-s390/kvm_virtio.h
 create mode 100644 include/asm-s390/sysinfo.h

