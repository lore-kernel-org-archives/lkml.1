Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbZD2WU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbZD2WU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbZD2WUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:20:41 -0400
Received: from kroah.org ([198.145.64.141]:40122 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbZD2WUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:20:37 -0400
Date: Wed, 29 Apr 2009 15:16:57 -0700
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
Subject: [patch 00/58] 2.6.27-stable review
Message-ID: <20090429221657.GA11765@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.22 release.
There are 58 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Friday, May 1, 20:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.22-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h


 Makefile                               |    2 +-
 arch/powerpc/include/asm/futex.h       |   12 +-
 arch/powerpc/include/asm/processor.h   |   19 ++++
 arch/powerpc/kernel/signal.c           |    4 +-
 arch/powerpc/kernel/signal.h           |    2 +-
 arch/powerpc/kernel/signal_32.c        |    4 +-
 arch/powerpc/kernel/signal_64.c        |    2 +-
 arch/x86/boot/memory.c                 |    7 +-
 arch/x86/kernel/cpu/mtrr/generic.c     |   51 +++++----
 arch/x86/pci/i386.c                    |    3 +
 drivers/acpi/ec.c                      |   43 ++++----
 drivers/ata/pata_hpt37x.c              |   22 +----
 drivers/char/agp/generic.c             |    2 +-
 drivers/char/raw.c                     |    1 +
 drivers/crypto/ixp4xx_crypto.c         |  182 +++++++++++---------------------
 drivers/ide/pci/hpt366.c               |    4 +-
 drivers/isdn/gigaset/bas-gigaset.c     |   16 +++-
 drivers/misc/thinkpad_acpi.c           |   41 ++++----
 drivers/net/b44.c                      |    2 +-
 drivers/net/bonding/bond_main.c        |   25 ++++-
 drivers/net/bonding/bonding.h          |    6 +
 drivers/net/r8169.c                    |  106 +++++++++++--------
 drivers/net/wireless/ath9k/ath9k.h     |    4 +-
 drivers/net/wireless/ath9k/core.c      |    1 +
 drivers/net/wireless/ath9k/core.h      |   33 ++++++
 drivers/net/wireless/ath9k/hw.c        |   22 ++++-
 drivers/net/wireless/b43/xmit.c        |    2 +-
 drivers/scsi/libiscsi.c                |    9 +-
 drivers/usb/class/cdc-wdm.c            |    2 +-
 drivers/usb/gadget/f_rndis.c           |    2 +-
 drivers/usb/gadget/u_ether.c           |    8 +--
 drivers/usb/host/ehci-q.c              |   32 ++++++
 drivers/usb/host/ehci.h                |    3 +
 drivers/usb/serial/ftdi_sio.c          |    1 +
 drivers/usb/serial/ftdi_sio.h          |    7 ++
 drivers/usb/storage/cypress_atacb.c    |   15 ++--
 drivers/usb/storage/scsiglue.c         |    6 +
 drivers/usb/storage/unusual_devs.h     |    6 +-
 fs/buffer.c                            |    2 +-
 fs/cifs/CHANGES                        |    3 +
 fs/cifs/cifssmb.c                      |    6 +-
 fs/cifs/connect.c                      |    2 +-
 fs/compat.c                            |   12 ++-
 fs/dquot.c                             |    2 +-
 fs/drop_caches.c                       |    2 +-
 fs/exec.c                              |    4 +-
 fs/fs-writeback.c                      |    3 +-
 fs/hugetlbfs/inode.c                   |    3 +-
 fs/ocfs2/file.c                        |    8 +-
 fs/proc/base.c                         |   50 +++------
 fs/splice.c                            |   25 ++++-
 include/linux/capability.h             |   23 ++++-
 include/linux/pci_regs.h               |    2 +-
 include/linux/sched.h                  |    3 +-
 kernel/exit.c                          |    3 +-
 kernel/kprobes.c                       |    4 +-
 kernel/signal.c                        |    8 ++
 mm/filemap_xip.c                       |    4 +-
 mm/mmap.c                              |    3 +
 net/bridge/br_if.c                     |    1 -
 net/ipv4/netfilter/arp_tables.c        |    4 +-
 net/ipv4/netfilter/ip_tables.c         |    4 +-
 net/ipv6/inet6_hashtables.c            |    4 +-
 net/ipv6/ip6_input.c                   |    4 +-
 net/ipv6/netfilter/ip6_tables.c        |    4 +-
 net/netfilter/nf_conntrack_proto_tcp.c |    3 +-
 net/netrom/af_netrom.c                 |    8 ++-
 net/rose/af_rose.c                     |    4 +
 net/sctp/endpointola.c                 |    3 +-
 net/x25/af_x25.c                       |    6 +
 security/selinux/hooks.c               |    1 +
 security/smack/smack_lsm.c             |    4 +-
 sound/pci/hda/patch_analog.c           |    2 +-
 73 files changed, 550 insertions(+), 383 deletions(-)
