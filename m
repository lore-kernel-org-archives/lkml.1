Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYJGAkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYJGAkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYJGAkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:40:24 -0400
Received: from mx1.suse.de ([195.135.220.2]:46421 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099AbYJGAkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:40:23 -0400
Date: Mon, 6 Oct 2008 17:36:34 -0700
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
Subject: [patch 00/71] 2.6.26-stable review
Message-ID: <20081007003634.GA3055@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.26.6 release.
There are 71 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Wed Oct 8, 22:00:00 UTC.  Anything received
after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.26.8-rc1.gz
and the diffstat can be found below.


thanks,

the -stable release team

 Makefile                                        |    2 
 arch/s390/kernel/compat_ptrace.h                |    1 
 arch/s390/kernel/ptrace.c                       |   28 +++++
 arch/sparc64/kernel/of_device.c                 |    9 -
 arch/sparc64/kernel/pci.c                       |    2 
 arch/sparc64/kernel/pci_psycho.c                |   14 +-
 arch/sparc64/kernel/prom.c                      |  104 +--------------------
 arch/x86/kernel/alternative.c                   |   18 +--
 arch/x86/kernel/apic_32.c                       |   30 +++++-
 arch/x86/kernel/apic_64.c                       |    3 
 arch/x86/kernel/cpu/bugs.c                      |    6 +
 arch/x86/kernel/e820_32.c                       |    2 
 arch/x86/kernel/e820_64.c                       |    2 
 arch/x86/kernel/genapic_64.c                    |    2 
 arch/x86/kernel/head64.c                        |    1 
 arch/x86/kernel/hpet.c                          |   19 ++-
 arch/x86/kernel/io_delay.c                      |    8 +
 arch/x86/kernel/mpparse.c                       |    5 +
 arch/x86/kernel/setup.c                         |    1 
 arch/x86/kernel/setup_32.c                      |   11 +-
 arch/x86/kernel/signal_64.c                     |   62 ++++++++++++
 arch/x86/kernel/traps_64.c                      |    9 +
 arch/x86/kernel/vmi_32.c                        |    2 
 arch/x86/kernel/vsmp_64.c                       |    2 
 arch/x86/kvm/svm.c                              |   14 ++
 arch/x86/mach-generic/bigsmp.c                  |    2 
 arch/x86/mm/pageattr.c                          |    6 -
 arch/x86/oprofile/nmi_int.c                     |   39 +++++++-
 crypto/async_tx/async_tx.c                      |    3 
 drivers/accessibility/braille/braille_console.c |   13 --
 drivers/acpi/ec.c                               |    2 
 drivers/acpi/processor_perflib.c                |    2 
 drivers/i2c/i2c-dev.c                           |    4 
 drivers/mmc/card/block.c                        |    4 
 drivers/net/ixgbe/ixgbe_main.c                  |    6 +
 drivers/net/niu.c                               |   56 +++++++++++
 drivers/net/wireless/rt2x00/rt2x00.h            |    4 
 drivers/net/wireless/rt2x00/rt2x00dev.c         |   17 ---
 drivers/net/wireless/rt2x00/rt2x00mac.c         |    4 
 drivers/pcmcia/ds.c                             |   23 ++--
 drivers/rtc/rtc-dev.c                           |   15 +--
 drivers/scsi/qla2xxx/qla_isr.c                  |    1 
 drivers/scsi/qla2xxx/qla_os.c                   |    2 
 drivers/spi/pxa2xx_spi.c                        |  116 ++++++++++++++++++------
 drivers/usb/core/hcd.c                          |    3 
 drivers/video/console/fbcon.h                   |    2 
 fs/buffer.c                                     |   13 +-
 fs/exec.c                                       |    2 
 fs/ocfs2/stackglue.c                            |    7 -
 fs/proc/array.c                                 |   59 ------------
 include/asm-generic/rtc.h                       |   12 --
 include/asm-x86/i387.h                          |   56 -----------
 include/asm-x86/mpspec.h                        |    1 
 include/asm-x86/pgtable_64.h                    |    2 
 include/linux/clockchips.h                      |    2 
 include/linux/mmzone.h                          |   12 +-
 include/linux/rmap.h                            |    2 
 include/linux/sched.h                           |    4 
 include/linux/smb.h                             |    2 
 include/net/netlink.h                           |    2 
 kernel/cgroup.c                                 |    5 -
 kernel/exit.c                                   |   18 ++-
 kernel/sched.c                                  |   59 ++++++++++++
 kernel/time/clockevents.c                       |    3 
 kernel/time/ntp.c                               |    2 
 kernel/time/tick-broadcast.c                    |   78 ++++++++++++----
 kernel/time/tick-common.c                       |    1 
 kernel/time/tick-internal.h                     |    2 
 kernel/time/tick-oneshot.c                      |   44 +++++++--
 lib/scatterlist.c                               |    5 -
 mm/filemap_xip.c                                |    2 
 mm/memcontrol.c                                 |   13 ++
 mm/mmzone.c                                     |    2 
 mm/rmap.c                                       |   14 +-
 net/ipv4/udp.c                                  |   59 ++++++------
 net/ipv6/ip6_output.c                           |   64 ++++++-------
 net/ipv6/route.c                                |    2 
 net/key/af_key.c                                |   30 +++---
 net/sctp/associola.c                            |    9 +
 net/sctp/sm_make_chunk.c                        |   15 +--
 net/xfrm/xfrm_output.c                          |   12 +-
 sound/core/pcm.c                                |    4 
 sound/core/pcm_native.c                         |   13 --
 sound/core/rawmidi.c                            |    4 
 sound/pci/hda/patch_sigmatel.c                  |    2 
 sound/pci/oxygen/hifier.c                       |    4 
 sound/pci/oxygen/oxygen.c                       |    4 
 sound/ppc/awacs.c                               |   50 +++++++---
 88 files changed, 862 insertions(+), 515 deletions(-)
