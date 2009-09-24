Return-Path: <linux-kernel-owner+w=401wt.eu-S1752385AbZIXWbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbZIXWbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 18:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZIXWbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 18:31:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbZIXWbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 18:31:17 -0400
Date: Thu, 24 Sep 2009 19:28:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 00/63] i7core_edac and edac_mce
Message-ID: <20090924192821.7fcffc80@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The content of this patch series is at:
	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/i7core.git for_linus

The first submission were done on Sept, 5 but weren't reviewed until 
yesterday. 

It is not yet a pull request. It is just the last version, after the 
last review.

My intention is to submit likely tomorrow a git pull request if 
everything is ok and hoping that Linus will still accept it for 2.6.32.

This time I'm sending the it as a patch series for better review. The complete
patchset is being sent to EDAC ML (bluesmoke-devel@lists.sourceforge.net).

Only this email and two others of this series is c/c at LKML. If more people is
interested on reviewing it, you can always look at -git and/or bluesmoke archives.

The two patches c/c at LKML are:
- the one that touches at PCI, for probing buses 254 and 255 - since, by
  default, ACPI bios doesn't announce those buses with MCU registers;
- edac_mce glue driver, that add two hooks on mce that are called only if a
  driver is registered for receiving mce log events. This is needed in order to
  get corrected error reports at the EDAC driver.

Cheers,
Mauro


Aristeu Rozanski (1):
  pci: Add a probing code that seeks for an specific bus

Keith Mannthey (2):
  i7core_edac: Fix ecc enable shift
  i7core_edac: Probe on Xeons eariler

Mauro Carvalho Chehab (60):
  i7core_edac: Add an EDAC memory controller driver for Nehalem
    chipsets
  i7core_edac: Add error insertion code for Nehalem
  i7core_edac: Add more status functions to EDAC driver
  i7core_edac: Registers all supported MC functions
  i7core_edac: Show read/write virtual/physical channel association
  i7core_edac: A few fixes at error injection code
  i7core_edac: need mci->edac_check, otherwise module removal doesn't
    work
  i7core_edac: Add a memory check routine, based on device 3 function 4
  i7core_edac: Add additional tests for error detection
  i7core_edac: Properly fill struct csrow_info
  i7core_edac: Improve error handling
  i7core_edac: Add more information about each active dimm
  i7core_edac: Get more info about the memory DIMMs
  i7core_edac: Memory info fixes and preparation for properly filling
    cswrow data
  i7core_edac: fill csrows edac sysfs info
  i7core_edac: CodingStyle fixes
  edac_mce: Add an interface driver to report mce errors via edac
  edac/Kconfig: edac_mce can't be module
  i7core_edac: Add edac_mce glue
  i7core_edac: Adds write unlock to MC registers
  i7core_edac: Add a code to probe Xeon 55xx bus
  i7core_edac: add support for more than one MC socket
  i7core_edac: maps all sockets as if ther are one MC controller
  i7core_edac: decode mcelog error and send it via edac interface
  i7core_edac: some fixes at memory error parser
  i7core: fix probing on Xeon55xx
  i7core: check if the memory error is fatal or non-fatal
  i7core: enrich error information based on memory transaction type
  i7core: fix get_devices routine for Xeon55xx
  i7core: better document i7core_get_active_channels()
  i7core: add socket info at the debug msg
  i7core: remove some uneeded noisy debug messages
  i7core_edac: Some cleanups at displayed info
  i7core_edac: some fixes at error injection code
  i7core_edac: fix error codes for sysfs error injection interface
  i7core_edac: fix error injection
  Documentation/edac.txt: Add Nehalem specific EDAC characteristics
  i7core_edac: CodingSyle fixes/cleanups
  i7core_edac: Print an error message if pci register fails
  i7core_edac: Use Device 3 function 2 to report errors with RDIMM's
  i7core: Use registered memories per processor
  i7core_edac: Improve corrected_error_counts output for RDIMM
  i7core: temporary workaround to allow it to compile against 2.6.30
  Dynamically allocate memory for PCI devices
  i7core_edac: create one mc per socket/QPI
  i7core_edac: sanity check: print a warning if a mcelog is ignored
  i7core_edac: a few fixes for multiple mc's
  Documentation/edac.txt: Improve it to reflect the latest changes at
    the driver
  i7core_edac: Fix a bug when printing error counts with RDIMMs
  i7core_edac: at remove, don't remove all pci devices at once
  i7core_edac: remove static counter for max sockets
  i7core_edac: change remove module strategy
  i7core_edac: We need to use list_for_each_entry_safe to avoid errors
  i7core_edac: Avoid printing a warning when debug is disabled
  edac_core: Allow the creation of sysfs groups
  i7core_edac: Add support for sysfs addrmatch group
  edac: store/show methods for device groups weren't working
  edac: Don't create csrow entries on instance groups
  i7core_edac: Convert UDIMM error counters into a proper sysfs group
  Documentation/edac.txt: Reflect the sysfs changes at the document

 Documentation/edac.txt           |  153 +++
 arch/x86/include/asm/pci_x86.h   |    2 +
 arch/x86/kernel/cpu/mcheck/mce.c |   12 +
 arch/x86/pci/legacy.c            |   43 +-
 drivers/edac/Kconfig             |   13 +
 drivers/edac/Makefile            |    4 +-
 drivers/edac/edac_core.h         |   14 +-
 drivers/edac/edac_mc_sysfs.c     |  152 +++-
 drivers/edac/edac_mce.c          |   61 ++
 drivers/edac/i7core_edac.c       | 1947 ++++++++++++++++++++++++++++++++++++++
 include/linux/edac_mce.h         |   31 +
 include/linux/pci.h              |    1 +
 include/linux/pci_ids.h          |   19 +
 13 files changed, 2407 insertions(+), 45 deletions(-)
 create mode 100644 drivers/edac/edac_mce.c
 create mode 100644 drivers/edac/i7core_edac.c
 create mode 100644 include/linux/edac_mce.h

