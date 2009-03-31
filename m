Return-Path: <linux-kernel-owner+w=401wt.eu-S1761650AbZCaTNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650AbZCaTNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbZCaTNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:13:39 -0400
Received: from outbound-mail-142.bluehost.com ([67.222.38.32]:35492 "HELO
	outbound-mail-142.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755371AbZCaTNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:13:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=PueoGHs3hfE2Fep4J0XNY3mZhRM2UnDLh/fRRJul53IcpfmSrownSZvYL+exg40Y82TSk1KB9cku5VUlf/mZ07kV1EbUzFGZ5MDHY6PIUDF8U5xpDoW2xpx6mvwUHrD6;
Date: Tue, 31 Mar 2009 12:13:31 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: [git pull] PCI changes for 2.6.30
Message-ID: <20090331121331.3673cf59@hobbes>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider pulling my PCI tree from
  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 linux-next

There are some real changes in here, notably Alex's changes to the core to add
real hotplug support, Matthew's multiple MSI support, and Yu's SR-IOV support.
Overall, v12n users should be happy with this set of changes.  And as is
customary we got a good collection of fixes from the usual suspects: Kenji-san,
Yinghai, and Bjorn.  Oh and Alpha has support for sysfs PCI resources now,
thanks to a commit from Ivan.

I note you've been having some tree management discussions with people this
time around, so I figured it would be good to describe how I've been handling
things.

I generally have two branches going: for-linus and linux-next.  The for-linus
branch rarely gets merge commits or rebases.  Merges will generally only
happen if I have some dependencies with another tree (like ACPI), and rebases
only occur when I need to drop a patch.  Other than that it's just fast
forwards from pulling your tree (after you've pulled mine) and commits for
new patches.

I try to keep the linux-next branch a superset of my for-linus branch at the
request of my downstream developers.  This means periodic rebasing after the
merge window closes, but it's generally important to get your latest stuff
into that branch so that downstream developers don't have to fight with bugs
that have been fixed upstream.  This isn't pain free (downstream developers
with large patchsets then have to rebase their stuff) but so far it seems
like the path of least pain for our purposes, probably because I haven't
started pulling trees from downstream (yet).  If I did, I of course would
avoid rebasing at that point...

Anyway hope this pull is ok.  I went through every warning by hand to make
sure none were caused by PCI commits, but that was with the bits in this
tree, which are -rc8 vintage.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

Alex Chiang (12):
      PCI: enhance physical slot debug information
      PCI: PCIe portdrv: eliminate double kfree in remove path
      PCIe: portdrv: call pci_disable_device during remove    
      PCI: always scan child buses                            
      PCI: do not initialize bridges more than once           
      PCI: do not enable bridges more than once               
      PCI: Introduce pci_rescan_bus()                         
      PCI: Introduce /sys/bus/pci/rescan                      
      PCI: Introduce /sys/bus/pci/devices/.../remove          
      PCI: Introduce /sys/bus/pci/devices/.../rescan          
      PCI Hotplug: rename legacy_fakephp to fakephp           
      PCI Hotplug: schedule fakephp for feature removal       

Andrew Morton (1):
      PCI: constify pci_bus_assign_resources()

Bjorn Helgaas (4):
      PCI/x86: make early dump handle multi-function devices
      PCI/x86: format early dump like other PCI output      
      PCI/x86: document pci=earlydump argument              
      x86: use dev_printk in quirk message                  

Chris Wright (1):
      PCI: add remove_id sysfs entry

Dave Airlie (1):
      PCI: expose boot VGA device via sysfs.

David O'Shea (1):
      PCI: Compaq Evo D510 SMBus quirk using USB instead of VGA

Ed Swierk (1):
      x86/PCI: Detect mmconfig on nVidia MCP55

Eric W. Biederman (1):
      PCI: pcie_portdriver: fix pcie_port_device_remove

Frank Seidel (1):
      PCI: add missing KERN_* constants to printks

Geert Uytterhoeven (1):
      PCI: Use kzalloc() in pci_create_bus()

Harvey Harrison (1):
      PCI: __FUNCTION__ is gcc-specific, use __func__

Ivan Kokshaysky (1):
      PCI/alpha: pci sysfs resources

Jesse Barnes (1):
      powerpc/PCI: include pci.h in powerpc MSI implementation

Jiri Slaby (1):
      PCI quirk: don't mark one netmos as class other

Julia Lawall (1):
      PCI: introduce missing kfree

Kay Sievers (1):
      PCI: struct device - replace bus_id with dev_name(), dev_set_name()

Kenji Kaneshige (15):
      PCI: pciehp: fix possible endless loop in pcie_isr
      PCI: pciehp: enable software notification on empty slots
      PCI: pciehp: make cmd_busy flag one bit                 
      PCI/ACPI: move _OSC code to pci_root.c                  
      PCI/ACPI: rename pci_osc_control_set()                  
      PCI/ACPI: fix wrong assumption in acpi_pci_get_bridge_handle
      PCI/ACPI: fix wrong assumption in acpi_find_root_bridge_handle
      PCI hotplug: fix wrong assumption in acpi_get_hp_params_from_firmware
      PCI hotplug: fix wrong assumption in acpi_get_hp_hw_control_from_firmware
      PCI: fix wrong assumption in pci_find_upstream_pcie_bridge               
      PCI: fix wrong assumption in pci_read_bridge_bases                       
      PCI: fix wrong assumption in pci_get_interrupt_pin                       
      PCI: fix wrong assumption in pci_common_swizzle                          
      PCI: pci_is_root_bus helper                                              
      PCI: fix kernel oops on bridge removal                                   

Matthew Wilcox (6):
      Rewrite MSI-HOWTO
      PCI MSI: Replace 'type' with 'is_msix'
      PCI MSI: msi_desc->dev is always initialised
      PCI MSI: Use mask_pos instead of mask_base when appropriate
      PCI MSI: Refactor interrupt masking code                   
      PCI MSI: Add support for multiple MSI                      

Michael Ellerman (3):
      PCI/MSI: Use #ifdefs instead of weak functions
      PCI/MSI: Allow arch code to return the number of MSI-X available
      PCI MSI: Add example request loop to MSI-HOWTO.txt              

Rafael J. Wysocki (9):
      PCI: PCIe portdrv: Use driver data to simplify code
      PCI: PCIe portdrv: Aviod using service devices with wrong interrupts
      PCI: PCIe portdrv: Do not enable port device before setting up interrupts
      PCI: PCIe portdrv: Remove unnecessary function                           
      PCI: PCIe portdrv: Simplily probe callback of service drivers            
      PCI: PCIe portdrv: Remove struct pcie_port_service_id                    
      PCI/MSI: Introduce pci_msix_table_size()                                 
      PCI/PCIe portdrv: Fix allocation of interrupts                           
      PCI: PCIe portdrv: Implement pm object                                   

Roel Kluin (1):
      PCI hotplug: shpchp: fix bus number check to avoid false positive

Sheng Yang (1):
      PCI: Speed up device reset function

Stephen Rothwell (1):
      PCI: update fakephp for bus_id removal

Trent Piepho (3):
      PCI: don't scan existing devices
      PCI: pci_scan_slot() returns newly found devices
      PCI Hotplug: restore fakephp interface with complete reimplementation

Yinghai Lu (5):
      PCI/x86: detect host bridge config space size w/o using quirks
      x86/PCI: host mmconfig detect clean up                        
      x86/PCI: make pci=lastbus=255 work when acpi is on            
      PCI: don't enable too much HT MSI mapping                     
      PCI: fix HT MSI mapping fix                                   

Yu Zhao (12):
      PCI: check if a bus is added when removing it
      PCI: fix incorrect mask of PM No_Soft_Reset bit
      PCI: initialize and release SR-IOV capability  
      PCI: restore saved SR-IOV state                
      PCI: reserve bus range for SR-IOV device       
      PCI: centralize device setup code              
      PCI: add SR-IOV API for Physical Function driver
      PCI: handle SR-IOV Virtual Function Migration   
      PCI: document SR-IOV sysfs entries              
      PCI: manual for SR-IOV user and driver developer
      PCI: fix conflict between SR-IOV and config space sizing
      PCI: save and restore PCIe 2.0 registers                

Yuji Shimada (1):
      PCI: allow assignment of memory resources with a specified alignment

akpm@linux-foundation.org (1):
      PCI: constify pci_bus_add_devices()

 Documentation/ABI/testing/sysfs-bus-pci    |   70 +++
 Documentation/DocBook/kernel-api.tmpl      |    1 +  
 Documentation/PCI/MSI-HOWTO.txt            |  814 +++++++++++----------------
 Documentation/PCI/pci-iov-howto.txt        |   99 ++++                       
 Documentation/feature-removal-schedule.txt |   33 ++                         
 Documentation/filesystems/sysfs-pci.txt    |   10 +                          
 Documentation/kernel-parameters.txt        |   11 +                          
 arch/alpha/include/asm/pci.h               |   14 +                          
 arch/alpha/kernel/Makefile                 |    2 +-                         
 arch/alpha/kernel/pci-sysfs.c              |  366 +++++++++++++              
 arch/powerpc/include/asm/pci.h             |    4 +                          
 arch/powerpc/kernel/msi.c                  |    5 +                          
 arch/x86/include/asm/pci.h                 |    3 +                          
 arch/x86/kernel/io_apic.c                  |    4 +                          
 arch/x86/kernel/pci-dma.c                  |    3 +-                         
 arch/x86/pci/early.c                       |   19 +-                         
 arch/x86/pci/fixup.c                       |   20 -                          
 arch/x86/pci/legacy.c                      |    3 +-                         
 arch/x86/pci/mmconfig-shared.c             |  227 ++++++--                   
 arch/x86/pci/mmconfig_64.c                 |   17 +-                         
 drivers/acpi/pci_root.c                    |  180 ++++++-                    
 drivers/pci/Kconfig                        |   10 +                          
 drivers/pci/Makefile                       |    2 +                          
 drivers/pci/bus.c                          |    8 +-                         
 drivers/pci/hotplug/acpi_pcihp.c           |   58 +--                        
 drivers/pci/hotplug/cpqphp_sysfs.c         |    3 +-                         
 drivers/pci/hotplug/fakephp.c              |  444 ++++------------           
 drivers/pci/hotplug/pciehp.h               |   13 +-                         
 drivers/pci/hotplug/pciehp_acpi.c          |   21 +-                         
 drivers/pci/hotplug/pciehp_core.c          |   18 +-                         
 drivers/pci/hotplug/pciehp_hpc.c           |   34 +-                         
 drivers/pci/hotplug/shpchp.h               |   10 +-                         
 drivers/pci/hotplug/shpchp_pci.c           |    2 +-                         
 drivers/pci/intel-iommu.c                  |    2 +-                         
 drivers/pci/iov.c                          |  680 +++++++++++++++++++++++    
 drivers/pci/msi.c                          |  426 ++++++++--------           
 drivers/pci/msi.h                          |    6 -                          
 drivers/pci/pci-acpi.c                     |  215 --------                   
 drivers/pci/pci-driver.c                   |   81 +++-                       
 drivers/pci/pci-sysfs.c                    |  124 ++++-                      
 drivers/pci/pci.c                          |  193 ++++++-                    
 drivers/pci/pci.h                          |   65 +++                        
 drivers/pci/pcie/aer/aerdrv.c              |   28 +-                         
 drivers/pci/pcie/aer/aerdrv_acpi.c         |    2 +-
 drivers/pci/pcie/aer/aerdrv_core.c         |   10 +-
 drivers/pci/pcie/portdrv.h                 |   14 +-
 drivers/pci/pcie/portdrv_bus.c             |   18 +-
 drivers/pci/pcie/portdrv_core.c            |  379 +++++++++-----
 drivers/pci/pcie/portdrv_pci.c             |   50 +-
 drivers/pci/probe.c                        |  210 +++++---
 drivers/pci/quirks.c                       |  221 +++++++--
 drivers/pci/remove.c                       |    4 +
 drivers/pci/search.c                       |    2 +-
 drivers/pci/setup-bus.c                    |    7 +-
 drivers/pci/setup-res.c                    |   15 +
 drivers/pci/slot.c                         |   18 +-
 include/linux/acpi.h                       |   34 ++
 include/linux/msi.h                        |   13 +-
 include/linux/pci-acpi.h                   |   67 +--
 include/linux/pci.h                        |   61 ++-
 include/linux/pci_ids.h                    |    1 +
 include/linux/pci_regs.h                   |   37 ++-
 include/linux/pcieport_if.h                |   36 +-
 63 files changed, 3644 insertions(+), 1903 deletions(-)
 create mode 100644 Documentation/PCI/pci-iov-howto.txt
 create mode 100644 arch/alpha/kernel/pci-sysfs.c
 create mode 100644 drivers/pci/iov.c
