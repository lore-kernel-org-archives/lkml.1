Return-Path: <linux-kernel-owner+w=401wt.eu-S933431AbZDBHDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431AbZDBHDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756222AbZDBHDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:03:23 -0400
Received: from sous-sol.org ([216.99.217.87]:49080 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754523AbZDBHDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:03:22 -0400
Date: Wed, 1 Apr 2009 23:57:20 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: chrisw@sous-sol.org, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, stable@kernel.org, jmforbes@linuxtx.org,
       zwane@arm.linux.org.uk, tytso@mit.edu, rdunlap@xenotime.net,
       davej@redhat.com, chuckw@quantumlinux.com, reviews@ml.cw.f00f.org,
       cebbert@redhat.com, cavokz@gmail.com, w@1wt.eu,
       rbranco@la.checkpoint.com, jake@lwn.net, eteo@redhat.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/45] 2.6.29.1 -stable review
Message-ID: <20090402065720.GA18394@sequoia.sous-sol.org>
References: <20090331231045.719396245@sous-sol.org> <20090331.204706.255891471.davem@davemloft.net> <49D2F0BA.7040805@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D2F0BA.7040805@linuxtv.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Krufky (mkrufky@linuxtv.org) wrote:
> David Miller wrote:
>> From: Chris Wright <chrisw@sous-sol.org>
>> Date: Tue, 31 Mar 2009 16:10:45 -0700
>>
>>> Responses should be made by Thursday, April 2, 23:00 UTC.
>>> Anything received after that time might be too late.
>>
>> Chris, any chance you can include the 3 sparc fixes I sent
>> to stable right before you posted this?
>>
>> Thanks!
>
> ...and also the v4l2-common fix that I sent ~10 hours before you posted?
>
> If you can add that one too, I'd appreciate it.

Typically I'd rather push these to the next cycle (some things will
always miss due to timing), but needed to put -rc2 out (needed to rev
to drop the scsi patches anyway), so I added these.

The whole updated patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.29.1-rc2.gz
and the diffstat can be found below.

thanks,
-chris
--

 Makefile                                 |    2 -
 arch/arm/include/asm/elf.h               |    1 
 arch/arm/kernel/module.c                 |    9 +++++
 arch/arm/mach-iop13xx/pci.c              |    5 ++-
 arch/arm/mach-omap2/mmc-twl4030.c        |    1 
 arch/arm/mm/mmu.c                        |    2 -
 arch/sparc/include/asm/tlb_64.h          |    4 +-
 arch/sparc/kernel/nmi.c                  |   23 +++++++++++++
 arch/sparc/kernel/smp_64.c               |    4 +-
 arch/x86/kernel/check.c                  |    6 +--
 arch/x86/kernel/cpu/mtrr/generic.c       |   51 ++++++++++++++++++-------------
 arch/x86/kernel/ptrace.c                 |    3 -
 arch/x86/kernel/tlb_uv.c                 |    3 +
 arch/x86/kvm/paging_tmpl.h               |    2 -
 arch/x86/kvm/svm.c                       |   41 +++++++++++++++++-------
 arch/x86/kvm/vmx.c                       |    2 -
 arch/x86/lguest/boot.c                   |   10 +++++-
 arch/x86/mm/pat.c                        |    5 +--
 arch/x86/pci/i386.c                      |    3 +
 drivers/char/raw.c                       |    1 
 drivers/lguest/page_tables.c             |    4 +-
 drivers/media/dvb/firewire/firedtv-avc.c |    6 +++
 drivers/media/video/v4l2-common.c        |    8 ++--
 drivers/net/dnet.c                       |    1 
 drivers/net/wireless/ath5k/base.c        |   22 +++++++++----
 drivers/net/wireless/ath5k/base.h        |    2 -
 drivers/net/wireless/ath9k/recv.c        |    7 +++-
 drivers/net/wireless/ath9k/xmit.c        |    2 -
 drivers/net/wireless/b43/xmit.c          |    2 -
 drivers/scsi/arm/cumana_2.c              |    2 -
 drivers/usb/core/message.c               |    3 +
 drivers/usb/core/quirks.c                |    4 ++
 drivers/usb/core/sysfs.c                 |    4 +-
 drivers/usb/gadget/f_rndis.c             |    2 -
 drivers/usb/host/ehci-q.c                |   32 +++++++++++++++++++
 drivers/usb/host/ehci.h                  |    3 +
 drivers/usb/storage/cypress_atacb.c      |   15 ++++-----
 drivers/usb/storage/scsiglue.c           |    6 +++
 drivers/video/pxafb.c                    |   14 ++++++++
 fs/cifs/CHANGES                          |    3 +
 fs/cifs/cifssmb.c                        |    6 ++-
 fs/cifs/connect.c                        |    2 -
 fs/fuse/file.c                           |    3 +
 include/linux/mm.h                       |   15 +++++++--
 include/linux/usb/quirks.h               |    3 +
 mm/memory.c                              |    6 ++-
 net/bridge/br_if.c                       |    1 
 net/core/dev.c                           |    9 +----
 net/ipv4/udp.c                           |    6 +++
 net/ipv6/ip6_input.c                     |    4 --
 net/netfilter/nf_conntrack_proto_tcp.c   |    3 +
 net/wireless/reg.c                       |   23 ++++++++++---
 net/xfrm/xfrm_state.c                    |    2 -
 53 files changed, 296 insertions(+), 107 deletions(-)
