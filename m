Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993AbZLaM0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbZLaM0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 07:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbZLaM0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 07:26:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36185 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbZLaM0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 07:26:21 -0500
Date: Thu, 31 Dec 2009 13:26:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [origin tree build failure] Re: [git pull] PCI fixes
Message-ID: <20091231122617.GA3508@elte.hu>
References: <20091228081002.71f0e3b9@jbarnes-x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091228081002.71f0e3b9@jbarnes-x200>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> The following changes since commit 8bea8672edfca7ec5f661cafb218f1205863b343:
>   Stephen Rothwell (1):
>         mfd: compile fix for twl4030 renaming
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus
> 
> A few misc fixes.  A few people have run into the CLS bug so far, which Csaba
> kindly provided a fix for (detection of PCI cache line size is a good
> improvement, but it will fail in some cases due to a virtualized or buggy
> platform).
> 
> This set also adds the device specific reset quirk code from Dexuan;
> needed for some devices especially in virtualized environments.
> 
> Benjamin Herrenschmidt (1):
>       PCI/cardbus: Add a fixup hook and fix powerpc
> 
> Csaba Henk (1):
>       PCI: Handle case when no pci device can provide cache line size hint
> 
> Detlef Riekenberg (1):
>       vgaarbiter: fix a typo in the vgaarbiter Documentation
> 
> Dexuan Cui (3):
>       PCI: support device-specific reset methods
>       PCI: add Intel USB specific reset method
>       PCI: add Intel 82599 Virtual Function specific reset method
> 
> Jiri Slaby (1):
>       PCI: fix section mismatch on update_res()
> 
> Rafael J. Wysocki (1):
>       PCI/PM: Propagate wake-up enable for PCIe devices too
> 
> Stefan Assmann (2):
>       PCI: change PCI nomenclature in drivers/pci/ (comment changes)
>       PCI: change PCI nomenclature in drivers/pci/ (non-comment changes)
> 
>  Documentation/vgaarbiter.txt           |    2 +-
>  arch/powerpc/kernel/pci-common.c       |   13 +++++++
>  arch/x86/pci/bus_numa.c                |    2 +-
>  drivers/pci/hotplug/shpchp.h           |    2 +-
>  drivers/pci/intel-iommu.c              |    6 ++--
>  drivers/pci/intr_remapping.c           |    2 +-
>  drivers/pci/pci-acpi.c                 |   10 +----
>  drivers/pci/pci.c                      |   30 +++++++++++++++--
>  drivers/pci/pci.h                      |    8 ++++
>  drivers/pci/pcie/aer/Kconfig.debug     |    4 +-
>  drivers/pci/pcie/aer/aer_inject.c      |    6 ++--
>  drivers/pci/pcie/aer/aerdrv.c          |    2 +-
>  drivers/pci/pcie/aer/aerdrv_acpi.c     |    2 +-
>  drivers/pci/pcie/aer/aerdrv_core.c     |    6 ++--
>  drivers/pci/pcie/aer/aerdrv_errprint.c |    4 +-
>  drivers/pci/pcie/aspm.c                |    4 +-
>  drivers/pci/pcie/portdrv_pci.c         |    2 +-
>  drivers/pci/quirks.c                   |   57 +++++++++++++++++++++++++++++++-
>  drivers/pci/search.c                   |    6 ++--
>  drivers/pcmcia/cardbus.c               |    2 +-
>  include/linux/pci.h                    |    3 ++
>  21 files changed, 135 insertions(+), 38 deletions(-)

FYI, a commit in this tree broke today's -tip build on x86:

 drivers/built-in.o: In function `pci_dev_reset':
 pci.c:(.text+0x95ed): undefined reference to `pci_dev_reset_methods'
 pci.c:(.text+0x95fd): undefined reference to `pci_dev_reset_methods'

I wont have time to bisect it today but wanted to give you a heads up.
 
( About 20% failure rate in randconfigs, so it will be reported by others too 
  i suspect. I suspect looking at the symbol names and the Kconfig rules 
  around them the bug should be apparent. Or if not then the relevant Kconfig 
  rules are, by definition, too complex ;-)

	Ingo
