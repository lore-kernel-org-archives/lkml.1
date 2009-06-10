Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZFJERM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZFJERM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 00:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbZFJEQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 00:16:58 -0400
Received: from kroah.org ([198.145.64.141]:41782 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbZFJEQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 00:16:58 -0400
Date: Tue, 9 Jun 2009 20:21:35 -0700
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
Subject: [patch 00/60] 2.6.27-stable review
Message-ID: <20090610032135.GA19346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.25 release.
There are 60 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by June 11 09:00:00 UTC.  Anything received
after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.25-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Documentation/filesystems/ext4.txt    |    5 +-
 Makefile                              |    2 +-
 arch/sparc/include/asm/pil.h          |    1 +
 arch/sparc/include/asm/tlb_64.h       |    4 +-
 arch/sparc/kernel/of_device.c         |   21 ++++++-
 arch/sparc64/kernel/irq.c             |   29 ++++++---
 arch/sparc64/kernel/kgdb.c            |    2 +-
 arch/sparc64/kernel/of_device.c       |   21 ++++++-
 arch/sparc64/kernel/pci_common.c      |    2 +-
 arch/sparc64/kernel/smp.c             |    8 +-
 arch/sparc64/kernel/ttable.S          |    8 ++-
 arch/sparc64/mm/ultra.S               |   24 +-------
 arch/x86/kernel/setup.c               |    5 +-
 arch/x86/mm/hugetlbpage.c             |    6 ++-
 arch/x86/mm/pageattr.c                |   11 ++++
 arch/x86/pci/mmconfig-shared.c        |    6 +-
 drivers/acpi/processor_idle.c         |    8 ++-
 drivers/char/random.c                 |   19 ++++--
 drivers/char/tpm/tpm_bios.c           |    3 +-
 drivers/hwmon/lm78.c                  |    2 +-
 drivers/media/video/cx88/cx88-input.c |   25 ++------
 drivers/net/bnx2.c                    |    2 +
 drivers/net/bonding/bond_alb.c        |    8 +--
 drivers/net/e1000/e1000_main.c        |    5 +-
 drivers/net/igb/igb_ethtool.c         |    4 +
 drivers/net/macvlan.c                 |    3 +-
 drivers/net/myri10ge/myri10ge.c       |    1 +
 drivers/scsi/3w-xxxx.c                |    5 +-
 drivers/scsi/3w-xxxx.h                |    2 +-
 drivers/serial/icom.c                 |    2 +-
 drivers/serial/mpc52xx_uart.c         |    2 +-
 drivers/usb/host/isp1760-hcd.c        |   24 +++++++-
 fs/ext4/ext4.h                        |   28 +++++++++
 fs/ext4/extents.c                     |   25 ++++++--
 fs/ext4/file.c                        |    7 ++-
 fs/ext4/ialloc.c                      |   31 +++++-----
 fs/ext4/inode.c                       |  105 +++++++++++++++++++++++++++++++--
 fs/ext4/ioctl.c                       |   17 +++++-
 fs/ext4/mballoc.c                     |   17 ++++--
 fs/ext4/namei.c                       |   17 +++++-
 fs/jbd2/revoke.c                      |   24 ++++++--
 fs/nfs/dir.c                          |    3 +-
 mm/hugetlb.c                          |   26 ++++----
 net/core/pktgen.c                     |    2 +-
 net/core/skbuff.c                     |    2 +-
 net/ipv4/tcp_input.c                  |    3 +
 net/mac80211/rc80211_pid_algo.c       |   71 ++++++++++++----------
 security/selinux/hooks.c              |    2 +-
 sound/usb/usbaudio.c                  |    2 +-
 sound/usb/usbaudio.h                  |    2 +-
 sound/usb/usbmidi.c                   |   12 ++++-
 sound/usb/usbquirks.h                 |    2 +-
 52 files changed, 474 insertions(+), 194 deletions(-)
