Return-Path: <linux-kernel-owner+w=401wt.eu-S1751804AbZJPROQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbZJPROQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZJPROQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:14:16 -0400
Received: from kroah.org ([198.145.64.141]:46113 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbZJPROP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:14:15 -0400
Date: Fri, 16 Oct 2009 10:14:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/46] 2.6.31.5-stable review
Message-ID: <20091016171422.GA13339@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.31.5 release.
There are 46 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sunday, October 18, 18:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.31.5-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

----------

 Documentation/connector/cn_test.c             |    4 +-
 Documentation/connector/connector.txt         |    8 +-
 MAINTAINERS                                   |    2 +-
 Makefile                                      |    7 +-
 arch/arm/Makefile                             |    2 +-
 arch/arm/kernel/Makefile                      |    3 +-
 arch/arm/mach-pxa/cpufreq-pxa2xx.c            |    2 +-
 arch/cris/Makefile                            |    2 -
 arch/cris/kernel/Makefile                     |    1 +
 arch/mips/Makefile                            |   27 +--
 arch/mips/kernel/vmlinux.lds.S                |   13 +-
 arch/powerpc/Makefile                         |    2 -
 arch/sparc/Makefile                           |    4 -
 arch/sparc/kernel/Makefile                    |    6 +-
 arch/um/Makefile                              |    9 +-
 arch/um/kernel/Makefile                       |    3 +
 arch/um/kernel/vmlinux.lds.S                  |    3 +
 arch/x86/include/asm/paravirt.h               |   38 +--
 arch/xtensa/kernel/Makefile                   |    3 +-
 drivers/char/tpm/tpm.c                        |    8 +-
 drivers/char/tty_buffer.c                     |   29 +-
 drivers/connector/cn_proc.c                   |    3 +-
 drivers/connector/cn_queue.c                  |   15 +-
 drivers/connector/connector.c                 |   24 +-
 drivers/i2c/busses/i2c-amd756.c               |    2 +-
 drivers/i2c/busses/i2c-amd8111.c              |    4 +-
 drivers/i2c/busses/i2c-i801.c                 |    4 +-
 drivers/i2c/busses/i2c-isch.c                 |    2 +-
 drivers/i2c/busses/i2c-piix4.c                |    4 +-
 drivers/i2c/busses/i2c-sis96x.c               |    2 +-
 drivers/i2c/busses/i2c-viapro.c               |    2 +-
 drivers/macintosh/therm_adt746x.c             |    4 +-
 drivers/macintosh/therm_pm72.c                |    4 +-
 drivers/macintosh/windfarm_lm75_sensor.c      |    4 +-
 drivers/macintosh/windfarm_max6690_sensor.c   |    4 +-
 drivers/macintosh/windfarm_smu_sat.c          |    4 +-
 drivers/md/dm-log-userspace-transfer.c        |    6 +-
 drivers/net/e1000e/82571.c                    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c     |   23 +-
 drivers/pci/dmar.c                            |   22 +-
 drivers/scsi/scsi.c                           |   11 +-
 drivers/scsi/scsi_error.c                     |    3 +
 drivers/scsi/sg.c                             |   10 +-
 drivers/staging/dst/dcore.c                   |    8 +-
 drivers/staging/pohmelfs/config.c             |    6 +-
 drivers/staging/rt2860/common/cmm_data_2860.c |    2 +
 drivers/usb/serial/cp210x.c                   |    1 +
 drivers/usb/serial/digi_acceleport.c          |    8 +-
 drivers/usb/serial/ftdi_sio.c                 |  422 ++++++++-----------------
 drivers/usb/serial/generic.c                  |    2 +-
 drivers/usb/serial/ipaq.c                     |    9 +
 drivers/usb/serial/option.c                   |    2 +
 drivers/usb/serial/pl2303.c                   |    8 +-
 drivers/usb/serial/usb-serial.c               |    6 +-
 drivers/usb/storage/transport.c               |   46 +++-
 drivers/video/uvesafb.c                       |    6 +-
 drivers/w1/w1_netlink.c                       |    3 +-
 fs/sysfs/file.c                               |   14 +-
 include/linux/connector.h                     |   11 +-
 include/linux/usb/serial.h                    |    1 +
 include/net/bluetooth/hci_core.h              |    4 +
 kernel/acct.c                                 |    8 +-
 kernel/futex.c                                |   39 ++-
 kernel/trace/trace_events_filter.c            |    3 +-
 net/bluetooth/hci_conn.c                      |   17 +-
 net/bluetooth/hci_event.c                     |    2 +
 net/bluetooth/hidp/core.c                     |   65 +++--
 net/bluetooth/hidp/hidp.h                     |    2 +
 net/mac80211/rx.c                             |   10 +-
 net/mac80211/sta_info.c                       |    2 +
 net/mac80211/tx.c                             |    3 +-
 scripts/Makefile.build                        |    3 +-
 sound/aoa/codecs/tas.c                        |    9 +
 sound/ppc/keywest.c                           |   12 +
 74 files changed, 525 insertions(+), 546 deletions(-)
