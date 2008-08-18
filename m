Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbYHRSox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbYHRSox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbYHRSop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:44:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:34366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbYHRSoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:44:44 -0400
Date: Mon, 18 Aug 2008 11:40:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 00/60] 2.6.26-stable review
Message-ID: <20080818184035.GA29394@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.26.3 release.
There are 60 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Wed, August 20, 17:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.26.3-rc1.gz
and the diffstat can be found below.


thanks,

the -stable release team

 Makefile                              |    2 +-
 arch/ia64/kvm/kvm-ia64.c              |    5 +-
 arch/sparc64/kernel/irq.c             |   52 +++++++
 arch/sparc64/kernel/kstack.h          |   60 ++++++++
 arch/sparc64/kernel/process.c         |   32 +++--
 arch/sparc64/kernel/signal.c          |    6 +-
 arch/sparc64/kernel/stacktrace.c      |   11 +-
 arch/sparc64/kernel/traps.c           |    7 +-
 arch/sparc64/lib/mcount.S             |   39 +++++-
 arch/sparc64/mm/init.c                |   11 ++
 arch/sparc64/mm/ultra.S               |    7 +
 arch/x86/boot/boot.h                  |    8 +
 arch/x86/boot/cpucheck.c              |    8 +-
 arch/x86/boot/main.c                  |    4 +
 arch/x86/kernel/cpu/mtrr/generic.c    |    2 +-
 arch/x86/kvm/mmu.c                    |    1 +
 arch/x86/kvm/svm.c                    |    7 +-
 arch/x86/kvm/vmx.c                    |    2 +
 arch/x86/kvm/x86.c                    |  109 ++++++---------
 arch/x86/pci/k8-bus_64.c              |    4 +-
 block/scsi_ioctl.c                    |    2 +-
 drivers/char/hw_random/via-rng.c      |    8 +
 drivers/crypto/padlock-aes.c          |   28 ++++-
 drivers/crypto/padlock-sha.c          |    9 ++
 drivers/i2c/Kconfig                   |   14 ++
 drivers/i2c/algos/Kconfig             |   11 +-
 drivers/i2c/i2c-core.c                |    4 +-
 drivers/ide/ide-cd.c                  |   18 ++-
 drivers/ide/pci/cs5520.c              |    1 +
 drivers/ide/pci/it821x.c              |    6 +
 drivers/misc/acer-wmi.c               |   19 +++
 drivers/net/r8169.c                   |    6 +-
 drivers/net/wireless/rtl8187.h        |    4 +
 drivers/net/wireless/rtl8187_dev.c    |    3 +
 drivers/pci/quirks.c                  |    7 +-
 drivers/scsi/hptiop.c                 |    7 +
 drivers/scsi/qla2xxx/qla_attr.c       |   43 ++++--
 drivers/scsi/qla2xxx/qla_def.h        |    1 -
 drivers/scsi/qla2xxx/qla_gbl.h        |    2 +
 drivers/scsi/qla2xxx/qla_init.c       |   16 +--
 drivers/scsi/qla2xxx/qla_os.c         |   55 ++++++--
 drivers/scsi/scsi_transport_spi.c     |    8 +-
 drivers/scsi/ses.c                    |   18 ++-
 drivers/usb/core/message.c            |    2 +-
 drivers/usb/serial/ftdi_sio.c         |    5 +
 drivers/usb/serial/ftdi_sio.h         |    6 +
 drivers/usb/serial/pl2303.c           |    1 -
 drivers/usb/serial/pl2303.h           |    4 -
 drivers/usb/serial/usb-serial.c       |    7 +-
 drivers/usb/storage/scsiglue.c        |   25 ++--
 drivers/usb/storage/transport.c       |   17 ++-
 drivers/usb/storage/unusual_devs.h    |   18 ++-
 drivers/video/arkfb.c                 |   18 ++--
 drivers/video/aty/radeon_accel.c      |   12 ++-
 drivers/video/matrox/matroxfb_maven.c |    2 +-
 drivers/video/s3fb.c                  |   18 ++--
 drivers/video/vt8623fb.c              |   20 ++--
 fs/cifs/asn1.c                        |    2 +-
 fs/cifs/cifs_spnego.c                 |   18 ++-
 fs/cifs/cifsfs.c                      |    2 +
 fs/cifs/inode.c                       |    1 +
 include/asm-sparc64/futex.h           |    2 +-
 include/asm-sparc64/irq.h             |    4 +
 include/asm-sparc64/ptrace.h          |    8 +-
 include/asm-x86/i387.h                |   32 +++++
 include/asm-x86/spinlock.h            |    4 +-
 include/linux/usb/serial.h            |    3 +-
 include/video/radeon.h                |    9 +-
 kernel/posix-timers.c                 |   19 ++-
 kernel/relay.c                        |   12 ++-
 kernel/signal.c                       |    1 +
 lib/random32.c                        |   48 ++++---
 mm/memory.c                           |   16 ++-
 mm/mlock.c                            |    2 -
 net/dccp/proto.c                      |    5 +
 net/ipv4/ipvs/ip_vs_est.c             |    7 +-
 net/ipv4/syncookies.c                 |    1 +
 net/ipv6/ip6_output.c                 |    4 +
 net/ipv6/syncookies.c                 |    1 +
 sound/soc/fsl/fsl_dma.c               |  242 ++++++++++++++++++---------------
 sound/soc/fsl/fsl_ssi.c               |   74 +++++++++--
 81 files changed, 940 insertions(+), 399 deletions(-)
 create mode 100644 arch/sparc64/kernel/kstack.h


