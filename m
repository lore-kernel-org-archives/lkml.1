Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbYA3SxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbYA3SxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYA3Swy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:52:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47625 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYA3Swx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:52:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: 2.6.24-git7: section mismatches woes
Date: Wed, 30 Jan 2008 19:50:43 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801301950.44403.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get these messages, the majority of which seem to be false-positives:

  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x8fef): Section mismatch in reference from the function arch_register_cpu() to the function .devinit.text:register_cpu()
WARNING: vmlinux.o(.text+0x1115f): Section mismatch in reference from the function acpi_map_lsapic() to the function .cpuinit.text:mp_register_lapic()
WARNING: vmlinux.o(.text+0x14d4f): Section mismatch in reference from the function remove_cpu_from_maps() to the variable .cpuinit.data:cpu_initialized
WARNING: vmlinux.o(.text+0x14fcc): Section mismatch in reference from the function __cpu_disable() to the variable .cpuinit.data:cpu_initialized
WARNING: vmlinux.o(.text+0x4b7e5): Section mismatch in reference from the function enable_nonboot_cpus() to the function .cpuinit.text:_cpu_up()
WARNING: vmlinux.o(.text+0x4b846): Section mismatch in reference from the function take_cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: vmlinux.o(.text+0x4b8e7): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: vmlinux.o(.text+0x4b90a): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: vmlinux.o(.text+0x4b9b8): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: vmlinux.o(.text+0x4ba07): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: vmlinux.o(.text+0x4bb26): Section mismatch in reference from the function unregister_cpu_notifier() to the variable .cpuinit.data:cpu_chain
WARNING: vmlinux.o(.text+0x110ca7): Section mismatch in reference from the function pci_scan_child_bus() to the function .devinit.text:pcibios_fixup_bus()
WARNING: vmlinux.o(.text+0x1521b9): Section mismatch in reference from the function acpi_pci_root_add() to the function .devinit.text:pci_acpi_scan_root()
WARNING: vmlinux.o(.text+0x180448): Section mismatch in reference from the function store_online() to the function .cpuinit.text:cpu_up()
WARNING: vmlinux.o(.text+0x1bad42): Section mismatch in reference from the function cpufreq_unregister_driver() to the variable .cpuinit.data:cpufreq_cpu_notifier
WARNING: vmlinux.o(.text+0x1baedc): Section mismatch in reference from the function cpufreq_register_driver() to the variable .cpuinit.data:cpufreq_cpu_notifier
WARNING: vmlinux.o(.text+0x1baee1): Section mismatch in reference from the function cpufreq_register_driver() to the function .cpuinit.text:register_cpu_notifier()
WARNING: vmlinux.o(__ksymtab+0x15d0): Section mismatch in reference from the variable __ksymtab_register_cpu_notifier to the function .cpuinit.text:register_cpu_notifier()
WARNING: vmlinux.o(__ksymtab+0x5660): Section mismatch in reference from the variable __ksymtab_pci_do_scan_bus to the function .devinit.text:pci_do_scan_bus()
WARNING: vmlinux.o(.data+0x29b0): Section mismatch in reference from the variable cpu_vsyscall_notifier_nb.11336 to the function .cpuinit.text:cpu_vsyscall_notifier()
WARNING: vmlinux.o(.data+0x58b0): Section mismatch in reference from the variable profile_cpu_callback_nb.15831 to the function .devinit.text:profile_cpu_callback()
WARNING: vmlinux.o(.data+0x86c0): Section mismatch in reference from the variable workqueue_cpu_callback_nb.13223 to the function .devinit.text:workqueue_cpu_callback()
WARNING: vmlinux.o(.data+0x22790): Section mismatch in reference from the variable cpu_callback_nb.22476 to the function .devinit.text:cpu_callback()
WARNING: vmlinux.o(.data+0x2c7e0): Section mismatch in reference from the variable percpu_counter_hotcpu_callback_nb.9364 to the function .cpuinit.text:percpu_counter_hotcpu_callback()
WARNING: vmlinux.o(.data+0x35328): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_ite887x_exit()
WARNING: vmlinux.o(.data+0x35350): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: vmlinux.o(.data+0x35378): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: vmlinux.o(.data+0x353c8): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: vmlinux.o(.data+0x353f0): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: vmlinux.o(.data+0x35418): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: vmlinux.o(.data+0x35440): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:sbs_exit()
WARNING: vmlinux.o(.data+0x35468): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:sbs_exit()
WARNING: vmlinux.o(.data+0x35490): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:sbs_exit()
WARNING: vmlinux.o(.data+0x354b8): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:sbs_exit()
WARNING: vmlinux.o(.data+0x37500): Section mismatch in reference from the variable topology_cpu_callback_nb.10813 to the function .cpuinit.text:topology_cpu_callback()
modpost: Found 35 section mismatch(es).
To see additional details select "Enable full Section mismatch analysis"
in the Kernel Hacking menu (CONFIG_SECTION_MISMATCH).

and if I compile the kernel with CONFIG_SECTION_MISMATCH, it breaks resuming
from RAM.

Greetings,
Rafael
