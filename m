Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbYKQHQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbYKQHQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYKQHQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:16:39 -0500
Received: from kroah.org ([198.145.64.141]:60281 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751945AbYKQHQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:16:38 -0500
Date: Sun, 16 Nov 2008 23:13:33 -0800
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
Subject: [patch 00/46] 2.6.27.7-stable review
Message-ID: <20081117071333.GA29522@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, let's try this again.  The 2.6.27.7-rc1 patch was a mess.  It had a
patch that was applied corrupted, and some other problems.  So here's a
second try at this kernel release.  I've added a few more patches that
have gone into Linus's tree and people have asked for, so it is bigger
than 2.6.27.7-rc1 was.  Because of this, I'm resetting the review period
clock to start over, as this all needs a good review.

There are 46 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by November 19, 2008, 07:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.7-rc2.gz
and the diffstat can be found below.


thanks,

greg k-h

--------------

 Makefile                                  |    2 +-
 arch/arm/mm/cache-feroceon-l2.c           |    4 +-
 arch/m68k/kernel/ints.c                   |    2 +-
 arch/powerpc/include/asm/mpic.h           |    2 +
 arch/powerpc/platforms/85xx/mpc85xx_ds.c  |    3 +-
 arch/powerpc/platforms/86xx/pic.c         |    3 +-
 arch/powerpc/sysdev/mpic.c                |   59 +++++++++++++++++++--
 arch/s390/kernel/topology.c               |   11 +++--
 block/blk-merge.c                         |   19 ++++++-
 drivers/acpi/bus.c                        |   16 +++---
 drivers/acpi/ec.c                         |   84 ++++++++++++++++++++---------
 drivers/acpi/scan.c                       |   35 +++++++++----
 drivers/acpi/system.c                     |   25 ++++++---
 drivers/char/ipmi/ipmi_msghandler.c       |   20 ++++---
 drivers/char/ipmi/ipmi_si_intf.c          |   16 +++---
 drivers/hwmon/ibmaem.c                    |   18 ++++---
 drivers/input/mouse/alps.c                |    1 +
 drivers/md/dm-raid1.c                     |    1 +
 drivers/media/video/tvaudio.c             |   15 +++---
 drivers/misc/sony-laptop.c                |    6 ++-
 drivers/net/Kconfig                       |    1 +
 drivers/net/bnx2x_init.h                  |    9 ++--
 drivers/net/bnx2x_main.c                  |    6 ++-
 drivers/net/wireless/ath5k/base.c         |   67 ++++++++++++-----------
 drivers/net/wireless/ath5k/base.h         |    3 +-
 drivers/net/wireless/ath5k/hw.c           |   22 +++-----
 drivers/net/wireless/ath5k/initvals.c     |    2 +
 drivers/net/wireless/hostap/hostap_wlan.h |    5 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    6 ++-
 drivers/net/wireless/rtl8187_dev.c        |    3 +
 drivers/pnp/pnpacpi/core.c                |    6 ++-
 drivers/scsi/dpt_i2o.c                    |    4 +-
 drivers/scsi/qla2xxx/qla_def.h            |    1 -
 drivers/scsi/qla2xxx/qla_init.c           |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c            |    2 +-
 drivers/scsi/qla2xxx/qla_os.c             |    1 +
 drivers/scsi/qla2xxx/qla_sup.c            |   19 +++----
 drivers/usb/class/cdc-acm.c               |    9 ++--
 drivers/usb/core/message.c                |    1 +
 drivers/usb/core/sysfs.c                  |    2 +-
 drivers/usb/gadget/f_acm.c                |    4 ++
 drivers/usb/host/Kconfig                  |   23 ++------
 drivers/usb/host/ehci-hcd.c               |   25 ++++-----
 drivers/usb/host/ehci-ps3.c               |    1 +
 drivers/usb/host/ehci-sched.c             |    4 +-
 drivers/usb/host/isp1760-if.c             |   22 ++++----
 drivers/usb/host/ohci-ps3.c               |    3 +-
 drivers/usb/storage/unusual_devs.h        |    7 +++
 fs/namespace.c                            |    7 ++-
 fs/proc/proc_sysctl.c                     |    1 +
 include/linux/bio.h                       |    7 +++
 include/linux/usb.h                       |    2 +
 mm/hugetlb.c                              |    5 +-
 mm/page_isolation.c                       |    5 +-
 net/ipv4/proc.c                           |   58 ++++++++++----------
 scripts/package/builddeb                  |   24 ++++++++-
 56 files changed, 449 insertions(+), 262 deletions(-)
