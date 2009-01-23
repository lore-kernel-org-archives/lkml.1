Return-Path: <linux-kernel-owner+w=401wt.eu-S1760043AbZAWA04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043AbZAWA04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 19:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758658AbZAWA0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 19:26:43 -0500
Received: from kroah.org ([198.145.64.141]:50186 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757406AbZAWA0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 19:26:41 -0500
Date: Thu, 22 Jan 2009 16:19:08 -0800
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
Subject: [patch 00/40] 2.6.27-stable review
Message-ID: <20090123001908.GA7397@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.13 release.
There are 40 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Sunday, January 25, 00:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.13-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

 Documentation/sound/alsa/ALSA-Configuration.txt |    3 +-
 Makefile                                        |    2 +-
 arch/ia64/Kconfig                               |    1 +
 arch/powerpc/mm/slice.c                         |   11 ++-
 drivers/firmware/dell_rbu.c                     |    4 +-
 drivers/hwmon/abituguru3.c                      |    2 +-
 drivers/hwmon/hwmon-vid.c                       |    1 +
 drivers/misc/sgi-xp/xpc_sn2.c                   |    2 +-
 drivers/net/irda/irda-usb.c                     |    2 +-
 drivers/net/r6040.c                             |   17 ++-
 drivers/net/wireless/ath9k/hw.c                 |    2 +-
 drivers/net/wireless/p54/p54usb.c               |    1 +
 drivers/net/wireless/rt2x00/rt73usb.c           |    1 +
 drivers/pci/pcie/aspm.c                         |  125 +++++++++++++++++++----
 drivers/usb/storage/libusual.c                  |    7 ++
 drivers/usb/storage/scsiglue.c                  |   31 ++++++
 drivers/usb/storage/transport.c                 |   80 +++++++++++++++
 drivers/usb/storage/unusual_devs.h              |   80 +++------------
 drivers/usb/storage/usb.c                       |    6 +
 drivers/usb/storage/usb.h                       |    4 +
 fs/fs-writeback.c                               |   92 ++++++++++-------
 fs/sync.c                                       |    2 +-
 include/linux/fs.h                              |    1 -
 include/linux/usb_usual.h                       |    5 +-
 include/linux/writeback.h                       |    1 -
 kernel/signal.c                                 |    3 +-
 kernel/time/timekeeping.c                       |   71 ++++++-------
 lib/idr.c                                       |   10 +--
 mm/filemap.c                                    |   18 +--
 mm/page-writeback.c                             |  120 ++++++++++++++++------
 net/ipv4/tcp.c                                  |    8 +-
 net/ipv6/ip6_fib.c                              |   15 ++--
 net/sched/cls_u32.c                             |    3 +-
 net/sched/sch_htb.c                             |    1 +
 net/sctp/sm_statefuns.c                         |   14 +++
 security/keys/keyctl.c                          |    1 +
 sound/pci/hda/patch_analog.c                    |   49 ++++++++-
 sound/pci/hda/patch_realtek.c                   |    1 +
 38 files changed, 550 insertions(+), 247 deletions(-)
