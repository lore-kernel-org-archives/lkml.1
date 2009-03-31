Return-Path: <linux-kernel-owner+w=401wt.eu-S1761452AbZCaXUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761452AbZCaXUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757801AbZCaXUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:20:12 -0400
Received: from sous-sol.org ([216.99.217.87]:33092 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756626AbZCaXUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:20:10 -0400
Message-Id: <20090331231045.719396245@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:10:45 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
Subject: [patch 00/45] 2.6.29.1 -stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.29.1 release.
There are 45 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Thursday, April 2, 23:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.29.1-rc1.gz
and the diffstat can be found below.

thanks,
-chris

 Makefile                                 |    2 
 arch/arm/include/asm/elf.h               |    1 
 arch/arm/kernel/module.c                 |    9 
 arch/arm/mach-iop13xx/pci.c              |    5 
 arch/arm/mach-omap2/mmc-twl4030.c        |    1 
 arch/arm/mm/mmu.c                        |    2 
 arch/x86/kernel/check.c                  |    6 
 arch/x86/kernel/cpu/mtrr/generic.c       |   51 +--
 arch/x86/kernel/ptrace.c                 |    3 
 arch/x86/kernel/tlb_uv.c                 |    3 
 arch/x86/kvm/paging_tmpl.h               |    2 
 arch/x86/kvm/svm.c                       |   41 +-
 arch/x86/kvm/vmx.c                       |    2 
 arch/x86/lguest/boot.c                   |   10 
 arch/x86/mm/pat.c                        |    5 
 arch/x86/pci/i386.c                      |    3 
 drivers/char/raw.c                       |    1 
 drivers/lguest/page_tables.c             |    4 
 drivers/media/dvb/firewire/firedtv-avc.c |    6 
 drivers/net/dnet.c                       |    1 
 drivers/net/wireless/ath5k/base.c        |   22 +
 drivers/net/wireless/ath5k/base.h        |    2 
 drivers/net/wireless/ath9k/recv.c        |    7 
 drivers/net/wireless/ath9k/xmit.c        |    2 
 drivers/net/wireless/b43/xmit.c          |    2 
 drivers/scsi/arm/cumana_2.c              |    2 
 drivers/scsi/sg.c                        |  466 ++++++++++++++-----------------
 drivers/usb/core/message.c               |    3 
 drivers/usb/core/quirks.c                |    4 
 drivers/usb/core/sysfs.c                 |    4 
 drivers/usb/gadget/f_rndis.c             |    2 
 drivers/usb/host/ehci-q.c                |   32 ++
 drivers/usb/host/ehci.h                  |    3 
 drivers/usb/storage/cypress_atacb.c      |   15 
 drivers/usb/storage/scsiglue.c           |    6 
 drivers/video/pxafb.c                    |   14 
 fs/cifs/CHANGES                          |    3 
 fs/cifs/cifssmb.c                        |    6 
 fs/cifs/connect.c                        |    2 
 fs/fuse/file.c                           |    3 
 include/linux/mm.h                       |   15 
 include/linux/usb/quirks.h               |    3 
 mm/memory.c                              |    6 
 net/bridge/br_if.c                       |    1 
 net/core/dev.c                           |    9 
 net/ipv4/udp.c                           |    6 
 net/ipv6/ip6_input.c                     |    4 
 net/netfilter/nf_conntrack_proto_tcp.c   |    3 
 net/wireless/reg.c                       |   23 +
 net/xfrm/xfrm_state.c                    |    2 
 50 files changed, 490 insertions(+), 340 deletions(-)
