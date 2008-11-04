Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbYKDXeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbYKDXeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbYKDXeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:34:12 -0500
Received: from ns2.suse.de ([195.135.220.15]:51578 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbYKDXeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:34:11 -0500
Date: Tue, 4 Nov 2008 15:30:28 -0800
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
Subject: [patch 00/57] 2.6.27-stable review
Message-ID: <20081104233028.GA659@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.5 release.
There are 57 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Thursday, November 6, 23:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.5-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------

 Documentation/i2c/busses/i2c-sis96x              |    2 
 MAINTAINERS                                      |   20 -
 Makefile                                         |    2 
 arch/powerpc/configs/linkstation_defconfig       |    7 
 arch/powerpc/mm/hash_utils_64.c                  |    6 
 arch/powerpc/mm/numa.c                           |  113 +++++-
 arch/powerpc/platforms/embedded6xx/linkstation.c |   14 
 arch/s390/kernel/smp.c                           |   24 -
 arch/sparc64/kernel/trampoline.S                 |   18 -
 arch/x86/kernel/process_64.c                     |    4 
 arch/x86/kernel/rtc.c                            |   22 +
 arch/x86/mm/pat.c                                |    4 
 drivers/acpi/button.c                            |    3 
 drivers/acpi/ec.c                                |  374 +++++++++++------------
 drivers/acpi/hardware/hwsleep.c                  |    7 
 drivers/acpi/reboot.c                            |   25 +
 drivers/ata/libata-core.c                        |    2 
 drivers/ata/pata_it821x.c                        |    3 
 drivers/ata/sata_nv.c                            |   53 +--
 drivers/ata/sata_promise.c                       |   20 +
 drivers/base/sys.c                               |    6 
 drivers/char/agp/intel-agp.c                     |   12 
 drivers/char/ipmi/ipmi_devintf.c                 |    1 
 drivers/firewire/fw-cdev.c                       |    6 
 drivers/firewire/fw-sbp2.c                       |   38 +-
 drivers/firewire/fw-topology.c                   |    6 
 drivers/firewire/fw-transaction.h                |    2 
 drivers/hid/usbhid/hid-quirks.c                  |    4 
 drivers/i2c/busses/scx200_i2c.c                  |    1 
 drivers/input/keyboard/atkbd.c                   |   10 
 drivers/media/dvb/frontends/s5h1411.c            |   35 +-
 drivers/media/video/pvrusb2/pvrusb2-encoder.c    |    4 
 drivers/net/atlx/atl1.c                          |    7 
 drivers/net/atlx/atl1.h                          |    2 
 drivers/net/bonding/bond_alb.c                   |   13 
 drivers/net/wireless/libertas/scan.c             |    4 
 drivers/pci/probe.c                              |    2 
 drivers/rtc/rtc-cmos.c                           |   33 +-
 drivers/scsi/sd.c                                |   10 
 drivers/usb/core/hcd.c                           |   35 +-
 drivers/usb/core/hcd.h                           |    1 
 drivers/usb/core/hub.c                           |    1 
 drivers/usb/core/urb.c                           |   15 
 drivers/usb/storage/unusual_devs.h               |    9 
 fs/hfsplus/bitmap.c                              |   12 
 fs/hfsplus/catalog.c                             |    5 
 include/math-emu/op-common.h                     |   17 -
 kernel/sched_clock.c                             |    6 
 kernel/sched_features.h                          |    2 
 net/ipv4/tcp_output.c                            |   33 +-
 net/ipv6/tcp_ipv6.c                              |    2 
 net/sched/sch_generic.c                          |    2 
 scripts/package/mkspec                           |    3 
 security/commoncap.c                             |    6 
 sound/core/control.c                             |    4 
 sound/pci/hda/hda_intel.c                        |   29 +
 56 files changed, 717 insertions(+), 384 deletions(-)
