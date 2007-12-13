Return-Path: <linux-kernel-owner+w=401wt.eu-S1760808AbXLMHVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808AbXLMHVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763151AbXLMHDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 02:03:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54458 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762788AbXLMHDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 02:03:05 -0500
Date: Wed, 12 Dec 2007 23:02:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/60] 2.6.23-stable review
Message-ID: <20071213070208.GA12118@kroah.com>
References: <20071213065039.GA6867@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 10:50:39PM -0800, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.23.10 release.
> There are 60 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.

Rolled up patch can be found at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.23.10-rc1.gz

with a full diffstat below.

thanks,

greg k-h

------------

 Makefile                              |    2 
 arch/i386/boot/pmjump.S               |    4 -
 crypto/algapi.c                       |    6 -
 drivers/ata/ahci.c                    |   65 ----------------
 drivers/ata/libata-core.c             |   17 ----
 drivers/atm/he.c                      |   10 +-
 drivers/base/core.c                   |    4 -
 drivers/base/power/Makefile           |    3 
 drivers/base/power/main.c             |    8 --
 drivers/base/power/power.h            |   25 ++++--
 drivers/block/rd.c                    |   13 +++
 drivers/char/apm-emulation.c          |   15 ++-
 drivers/char/random.c                 |    6 -
 drivers/input/mouse/alps.c            |    2 
 drivers/isdn/i4l/isdn_common.c        |    5 +
 drivers/isdn/i4l/isdn_net.c           |    8 +-
 drivers/kvm/kvm_main.c                |   16 ++--
 drivers/kvm/mmu.c                     |    1 
 drivers/kvm/svm.c                     |    4 +
 drivers/kvm/vmx.c                     |    3 
 drivers/kvm/x86_emulate.c             |   30 ++++++-
 drivers/net/forcedeth.c               |   38 ++++++---
 drivers/net/wireless/libertas/cmd.c   |   10 +-
 drivers/pnp/pnpacpi/rsparser.c        |   15 +++
 drivers/scsi/dpt_i2o.c                |  132 +++++++++++++++-------------------
 drivers/scsi/dpti.h                   |    9 +-
 drivers/scsi/esp_scsi.c               |    4 -
 drivers/scsi/scsi.c                   |   31 +++++++
 drivers/usb/host/ehci-hcd.c           |    5 +
 drivers/usb/image/microtek.c          |    2 
 drivers/video/fb_ddc.c                |    8 +-
 fs/xfs/linux-2.6/xfs_buf.c            |    2 
 include/linux/pci_ids.h               |    4 +
 include/linux/pnp.h                   |    4 -
 include/linux/thread_info.h           |   17 +++-
 include/net/sock.h                    |    3 
 include/net/tcp.h                     |    3 
 include/scsi/scsi_device.h            |    3 
 kernel/exit.c                         |    2 
 kernel/futex.c                        |   25 +++---
 kernel/hrtimer.c                      |    8 ++
 kernel/irq/manage.c                   |   20 ++++-
 kernel/sched.c                        |    6 -
 lib/textsearch.c                      |    8 +-
 mm/shmem.c                            |    5 -
 net/8021q/vlan_dev.c                  |    3 
 net/bridge/br.c                       |    4 -
 net/bridge/br_input.c                 |    7 +
 net/bridge/netfilter/ebtable_broute.c |    4 -
 net/decnet/dn_dev.c                   |    4 -
 net/ipv4/arp.c                        |   19 ----
 net/ipv4/netfilter/nf_nat_core.c      |    7 -
 net/ipv4/route.c                      |    8 --
 net/ipv4/sysctl_net_ipv4.c            |    2 
 net/ipv4/tcp_illinois.c               |    2 
 net/ipv4/tcp_output.c                 |    1 
 net/ipv6/addrconf.c                   |   11 ++
 net/key/af_key.c                      |    2 
 net/netfilter/nf_conntrack_extend.c   |    2 
 net/netfilter/xt_CONNMARK.c           |   10 +-
 net/netfilter/xt_CONNSECMARK.c        |   10 +-
 net/netfilter/xt_TCPMSS.c             |    4 -
 net/rxrpc/Kconfig                     |    1 
 net/sched/sch_generic.c               |    5 -
 net/unix/af_unix.c                    |    9 ++
 net/xfrm/xfrm_state.c                 |    2 
 66 files changed, 409 insertions(+), 319 deletions(-)
