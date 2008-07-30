Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbYG3Xvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbYG3Xvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbYG3Xvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:51:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbYG3Xvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:51:44 -0400
Date: Wed, 30 Jul 2008 16:49:15 -0700
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
Subject: [patch 00/62] 2.6.26-stable review
Message-ID: <20080730234915.GA12426@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.26.1 release.
There are 62 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by August 1, 12:00:00 UTC.  Anything received
after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.26.1-rc1.gz
and the diffstat can be found below.


thanks,

the -stable release team


 Documentation/networking/udplite.txt          |    2 +-
 Documentation/video4linux/cx18.txt            |   12 +--
 Makefile                                      |    5 +-
 arch/ia64/kvm/kvm-ia64.c                      |    3 +
 arch/powerpc/kvm/powerpc.c                    |    4 +
 arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c |    6 +
 arch/s390/kvm/kvm-s390.c                      |    4 +
 arch/sparc64/kernel/irq.c                     |   10 ++-
 arch/sparc64/kernel/ldc.c                     |   38 ++++----
 arch/sparc64/kernel/time.c                    |   15 ++-
 arch/um/include/init.h                        |    8 ++
 arch/x86/Kconfig.cpu                          |    2 +-
 arch/x86/kernel/acpi/sleep.c                  |   17 +++-
 arch/x86/kernel/i387.c                        |    4 +-
 arch/x86/kernel/ptrace.c                      |    4 +-
 arch/x86/kernel/reboot.c                      |    8 ++
 arch/x86/kvm/mmu.c                            |   10 ++-
 arch/x86/kvm/svm.c                            |   34 ++++--
 arch/x86/kvm/vmx.c                            |    7 +-
 arch/x86/kvm/x86.c                            |    5 +
 arch/x86/kvm/x86_emulate.c                    |    2 +-
 arch/x86/mm/init_64.c                         |    2 +-
 drivers/acpi/processor_perflib.c              |   15 +++-
 drivers/cpufreq/cpufreq.c                     |    3 +
 drivers/dma/iop-adma.c                        |    2 +
 drivers/ide/ide-cd.c                          |   27 ++++-
 drivers/media/dvb/dvb-usb/dib0700_devices.c   |    7 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h       |    1 +
 drivers/media/video/Kconfig                   |    8 +--
 drivers/media/video/cx18/cx18-firmware.c      |    2 +-
 drivers/media/video/cx23885/cx23885-core.c    |  142 +++++++++++++++++++++++-
 drivers/media/video/saa7134/saa7134-cards.c   |    3 -
 drivers/media/video/saa7134/saa7134-core.c    |    5 +-
 drivers/media/video/uvc/Kconfig               |   17 +++
 drivers/media/video/uvc/uvc_driver.c          |   12 ++-
 drivers/media/video/uvc/uvc_status.c          |   19 +++-
 drivers/media/video/uvc/uvc_video.c           |  116 +++++++++++++-------
 drivers/media/video/uvc/uvcvideo.h            |    2 +
 drivers/mmc/host/pxamci.c                     |    2 +-
 drivers/net/hamradio/hdlcdrv.c                |    1 +
 drivers/net/ixgbe/ixgbe_main.c                |    2 -
 drivers/net/myri10ge/myri10ge.c               |   30 +++---
 drivers/net/wireless/ath5k/base.c             |    5 -
 drivers/net/wireless/b43legacy/main.c         |    2 +-
 drivers/rtc/rtc-at91rm9200.c                  |   16 +--
 drivers/spi/mpc52xx_psc_spi.c                 |   22 ++---
 drivers/usb/serial/usb-serial.c               |    5 +-
 fs/dquot.c                                    |   16 +++-
 fs/ecryptfs/crypto.c                          |   30 +++--
 fs/isofs/rock.c                               |   22 ++++-
 fs/libfs.c                                    |    4 +-
 fs/proc/task_mmu.c                            |    2 +-
 include/asm-arm/bitops.h                      |    9 ++-
 include/asm-generic/vmlinux.lds.h             |    4 +-
 include/asm-sparc64/io.h                      |    1 -
 include/asm-x86/signal.h                      |    4 +-
 include/linux/cpufreq.h                       |    1 +
 include/linux/ipv6.h                          |    2 +
 include/linux/kvm_host.h                      |    1 +
 kernel/cpuset.c                               |    4 +-
 kernel/marker.c                               |   12 ++-
 kernel/rcupreempt.c                           |    2 +-
 kernel/sys_ni.c                               |    1 +
 mm/filemap.c                                  |    2 +-
 mm/shmem.c                                    |    3 +-
 net/ipv4/tcp_input.c                          |    3 +-
 net/ipv4/udp.c                                |    4 +
 net/ipv6/ip6_fib.c                            |    4 +-
 scripts/Makefile.modpost                      |    1 +
 scripts/mod/modpost.c                         |    3 +-
 sound/pci/trident/trident_main.c              |    5 +-
 virt/kvm/kvm_main.c                           |    3 +
 72 files changed, 589 insertions(+), 222 deletions(-)
 create mode 100644 drivers/media/video/uvc/Kconfig

