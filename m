Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbYKLBKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbYKLBKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 20:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbYKLBKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 20:10:00 -0500
Received: from ns.suse.de ([195.135.220.2]:46978 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbYKLBJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 20:09:59 -0500
Date: Tue, 11 Nov 2008 17:07:53 -0800
From: Greg KH <gregkh@suse.de>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
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
Subject: Re: [patch 00/49] 2.6.27.5 stable review
Message-ID: <20081112010753.GA14073@suse.de>
References: <20081112002215.GA10989@kroah.com> <491A26F5.6090204@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491A26F5.6090204@googlemail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 01:44:37AM +0100, Gabriel C wrote:
> Greg KH wrote:
> 
> > This is the start of the stable review cycle for the 2.6.27.5 release.
> > There are 49 patches in this series, all will be posted as a response to
> > this one. 
> 
> 
> Hmm , again 2.6.27.5 ?:) I guess you mean 2.6.27.6 ?

Oh crap.

I did all of this on an older git tree that was based on 2.6.27.4.  So
it was really 2.6.27.5 I was working with...

I've updated the patch now, the hfsplus patches were already in 2.6.27.5
so they dropped out.  It can be found as patch-2.6.27.6-rc1.gz in the
same location, with the diffstat below.

Sorry for the confusion, this release was tough to get out as it kept
crashing my boxes until I got all of the needed fixes added.

It's time for a beer...

greg k-h

-------------------

 Documentation/cciss.txt                     |    2 
 Makefile                                    |    2 
 arch/arm/mach-pxa/include/mach/reset.h      |    9 +
 arch/arm/mach-pxa/reset.c                   |    9 +
 arch/arm/mach-pxa/spitz.c                   |    2 
 arch/arm/mach-pxa/tosa.c                    |    2 
 arch/arm/mm/cache-xsc3l2.c                  |    4 
 arch/x86/Kconfig                            |   20 ++++
 arch/x86/kernel/setup.c                     |   41 ++++++++
 arch/x86/kernel/tsc.c                       |    8 -
 drivers/acpi/dock.c                         |    5 -
 drivers/ata/libata-eh.c                     |   21 ++--
 drivers/block/cciss.c                       |   28 +++++
 drivers/block/cpqarray.c                    |    7 +
 drivers/dca/dca-core.c                      |    2 
 drivers/dma/ioat_dma.c                      |   11 +-
 drivers/dma/iovlock.c                       |   17 +--
 drivers/hid/hidraw.c                        |    2 
 drivers/md/linear.c                         |    2 
 drivers/md/raid10.c                         |    2 
 drivers/mmc/core/core.c                     |    6 +
 drivers/mtd/chips/cfi_cmdset_0002.c         |   13 --
 drivers/mtd/chips/jedec_probe.c             |   10 --
 drivers/net/r8169.c                         |  134 ++++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h  |    7 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   63 +------------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   57 ++++++++---
 drivers/net/wireless/iwlwifi/iwl-calib.c    |   60 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   27 +----
 drivers/net/wireless/iwlwifi/iwl-core.h     |    8 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   15 +--
 drivers/net/wireless/iwlwifi/iwl-power.c    |   39 +++++++-
 drivers/net/wireless/iwlwifi/iwl-power.h    |    4 
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    8 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 +
 drivers/net/wireless/zd1211rw/zd_usb.c      |    2 
 fs/ext3/super.c                             |   11 +-
 fs/hfs/catalog.c                            |    4 
 fs/jffs2/background.c                       |   10 +-
 fs/jffs2/compr_lzo.c                        |   15 +--
 include/asm-generic/memory_model.h          |    2 
 include/linux/mtd/cfi.h                     |   22 +++-
 include/net/af_unix.h                       |    1 
 kernel/cgroup.c                             |    1 
 mm/hugetlb.c                                |   49 +++++++++-
 mm/internal.h                               |   29 ++++++
 mm/page_alloc.c                             |   28 ++++-
 net/unix/af_unix.c                          |   31 +++++-
 net/unix/garbage.c                          |   49 +++++++---
 security/keys/internal.h                    |    1 
 security/keys/process_keys.c                |    2 
 security/keys/request_key.c                 |    4 
 sound/pci/hda/patch_sigmatel.c              |   15 +--
 53 files changed, 630 insertions(+), 300 deletions(-)

