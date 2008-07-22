Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbYGVXSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbYGVXSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYGVXR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:17:29 -0400
Received: from ns2.suse.de ([195.135.220.15]:57373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbYGVXR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:17:28 -0400
Date: Tue, 22 Jul 2008 16:13:42 -0700
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
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/47] 2.6.25-stable review
Message-ID: <20080722231342.GA8282@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.25.12 release.
There are 47 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by July 24, 22:00:00 UTC.  Anything received
after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.12-rc1.gz
and the diffstat can be found below.


thanks,

the -stable release team

-----

 Makefile                                    |    2 
 arch/powerpc/kernel/of_platform.c           |    2 
 block/as-iosched.c                          |    2 
 crypto/chainiv.c                            |   10 +++-
 drivers/base/node.c                         |    4 -
 drivers/block/cciss.c                       |   66 +++++++++++++++-------------
 drivers/char/pcmcia/ipwireless/hardware.c   |    4 +
 drivers/char/rtc.c                          |    3 -
 drivers/char/tpm/tpm_tis.c                  |    1 
 drivers/hwmon/hdaps.c                       |    8 +++
 drivers/isdn/i4l/isdn_common.c              |    4 +
 drivers/md/md.c                             |    6 +-
 drivers/md/raid10.c                         |    2 
 drivers/md/raid5.c                          |   14 ++---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    7 ++
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h     |    3 -
 drivers/media/video/ov7670.c                |    4 +
 drivers/message/fusion/mptspi.c             |    9 ++-
 drivers/mmc/host/pxamci.c                   |   13 +++++
 drivers/mmc/host/sdhci.c                    |    6 +-
 drivers/net/3c59x.c                         |    5 +-
 drivers/net/wireless/b43/leds.c             |    3 +
 drivers/net/wireless/b43/main.c             |    9 ++-
 drivers/net/wireless/b43legacy/dma.c        |    2 
 drivers/net/wireless/b43legacy/main.c       |    6 +-
 drivers/net/wireless/zd1211rw/zd_usb.c      |    1 
 drivers/rapidio/rio-driver.c                |    2 
 drivers/scsi/esp_scsi.c                     |   22 ++++++++-
 drivers/scsi/ses.c                          |    2 
 drivers/serial/8250.c                       |    3 +
 drivers/serial/serial_core.c                |    4 +
 drivers/usb/core/hcd.c                      |   38 +++++++++++-----
 drivers/usb/host/ehci.h                     |   19 ++++----
 drivers/usb/host/ohci-hcd.c                 |   15 +++++-
 drivers/usb/host/ohci-q.c                   |   12 +++++
 drivers/usb/misc/sisusbvga/sisusb.c         |    2 
 drivers/video/fb_defio.c                    |   20 ++++++++
 fs/buffer.c                                 |   13 +++--
 fs/cifs/cifsacl.c                           |   10 ++--
 fs/exec.c                                   |    2 
 fs/reiserfs/inode.c                         |    2 
 include/linux/fs.h                          |    1 
 kernel/hrtimer.c                            |    8 +++
 lib/ts_bm.c                                 |    2 
 mm/slub.c                                   |    4 +
 net/can/af_can.c                            |   10 ++++
 net/can/bcm.c                               |   23 ++++++++-
 net/can/raw.c                               |    3 +
 net/mac80211/tx.c                           |    9 +++
 net/netfilter/nf_conntrack_proto_tcp.c      |   13 ++---
 50 files changed, 323 insertions(+), 112 deletions(-)
