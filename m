Return-Path: <linux-kernel-owner+w=401wt.eu-S1757934AbYHRTVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbYHRTVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbYHRTV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:21:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39798 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbYHRTVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:21:24 -0400
Date: Mon, 18 Aug 2008 12:18:34 -0700
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
Subject: [patch 00/49] 2.6.25-stable review
Message-ID: <20080818191834.GA10350@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.25.16 release.
There are 49 patches in this series, all will be posted as a response to
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
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.16-rc1.gz
and the diffstat can be found below.


thanks,

the -stable release team


 Makefile                                 |    2 -
 arch/sparc64/kernel/signal.c             |    6 ++-
 arch/um/Makefile                         |    1 
 arch/um/Makefile-i386                    |    7 +++
 arch/um/Makefile-x86_64                  |    3 +
 arch/um/drivers/chan_user.c              |    1 
 arch/um/drivers/cow_sys.h                |    2 -
 arch/um/drivers/daemon_user.c            |    4 +-
 arch/um/drivers/fd.c                     |    2 -
 arch/um/drivers/mcast_user.c             |    3 +
 arch/um/drivers/net_user.c               |    2 -
 arch/um/drivers/pcap_user.c              |    2 -
 arch/um/drivers/port_user.c              |    2 -
 arch/um/drivers/pty.c                    |    2 -
 arch/um/drivers/slip_user.c              |    2 -
 arch/um/drivers/tty.c                    |    2 -
 arch/um/drivers/xterm.c                  |    2 -
 arch/um/include/init.h                   |    8 ++++
 arch/um/include/os.h                     |    2 -
 arch/um/include/process.h                |    4 +-
 arch/um/include/um_malloc.h              |    9 +---
 arch/um/kernel/mem.c                     |    5 ++
 arch/um/kernel/time.c                    |    4 +-
 arch/um/kernel/um_arch.c                 |    7 ++-
 arch/um/os-Linux/drivers/ethertap_user.c |    4 +-
 arch/um/os-Linux/helper.c                |    5 +-
 arch/um/os-Linux/main.c                  |    2 -
 arch/um/os-Linux/sigio.c                 |    4 +-
 arch/um/os-Linux/signal.c                |    1 
 arch/um/os-Linux/skas/process.c          |    2 -
 arch/um/os-Linux/start_up.c              |   25 ++++++++----
 arch/um/os-Linux/sys-i386/task_size.c    |   38 ++++++++++++++-----
 arch/um/os-Linux/sys-x86_64/task_size.c  |    2 -
 arch/um/os-Linux/time.c                  |   61 ++++++++++++++++++++++++++++---
 arch/um/sys-x86_64/ksyms.c               |    5 ++
 arch/x86/boot/boot.h                     |    8 ++++
 arch/x86/boot/cpucheck.c                 |    8 ----
 arch/x86/boot/main.c                     |    4 ++
 block/scsi_ioctl.c                       |    2 -
 drivers/i2c/i2c-core.c                   |    4 +-
 drivers/ide/ide-cd.c                     |   18 +++++----
 drivers/misc/acer-wmi.c                  |   19 +++++++++
 drivers/net/r8169.c                      |    6 ++-
 drivers/scsi/hptiop.c                    |    7 +++
 drivers/scsi/qla2xxx/qla_attr.c          |   43 ++++++++++++++-------
 drivers/scsi/qla2xxx/qla_def.h           |    1 
 drivers/scsi/qla2xxx/qla_gbl.h           |    2 +
 drivers/scsi/qla2xxx/qla_init.c          |   16 ++------
 drivers/scsi/qla2xxx/qla_os.c            |   55 ++++++++++++++++++++-------
 drivers/scsi/scsi_transport_spi.c        |    8 ++--
 drivers/scsi/ses.c                       |   18 +++++++--
 drivers/usb/serial/ftdi_sio.c            |    5 ++
 drivers/usb/serial/ftdi_sio.h            |    6 +++
 drivers/usb/serial/pl2303.c              |    1 
 drivers/usb/serial/pl2303.h              |    4 --
 drivers/usb/serial/usb-serial.c          |    7 +--
 drivers/usb/storage/unusual_devs.h       |   18 ++++++++-
 drivers/video/aty/radeon_accel.c         |   12 +++++-
 drivers/video/matrox/matroxfb_maven.c    |    2 -
 fs/cifs/asn1.c                           |    2 -
 fs/cifs/cifsfs.c                         |    2 +
 fs/cifs/inode.c                          |    1 
 include/asm-sparc64/futex.h              |    2 -
 include/asm-x86/spinlock.h               |    4 +-
 include/linux/usb/serial.h               |    3 +
 include/video/radeon.h                   |    9 +++-
 kernel/posix-timers.c                    |   19 +++++++--
 kernel/relay.c                           |   12 +++++-
 kernel/signal.c                          |    1 
 lib/random32.c                           |   48 +++++++++++++-----------
 mm/memory.c                              |   16 ++++++--
 mm/mlock.c                               |    2 -
 net/dccp/proto.c                         |    5 ++
 net/ipv4/ipvs/ip_vs_est.c                |    7 ++-
 net/ipv4/netfilter/nf_nat_snmp_basic.c   |    2 -
 net/ipv6/ip6_output.c                    |    4 ++
 76 files changed, 464 insertions(+), 182 deletions(-)
