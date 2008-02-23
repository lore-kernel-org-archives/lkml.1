Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbYBWHuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbYBWHuP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 02:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbYBWHt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 02:49:59 -0500
Received: from nn7.de ([85.214.94.156]:37638 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbYBWHt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 02:49:57 -0500
Subject: 2.6.25-git-current several Section mismatch in reference from ...
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Date: Sat, 23 Feb 2008 08:49:53 +0100
Message-Id: <1203752993.4498.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

compiling with

make CONFIG_DEBUG_SECTION_MISMATCH=y

I see the following warnings:

  CC      kernel/stacktrace.o
  CC      kernel/irq/handle.o
  LD      mm/built-in.o
WARNING: mm/built-in.o(.meminit.text+0x89e): Section mismatch in reference from the function free_area_init_core() to the function .init.text:setup_usemap()
The function __meminit free_area_init_core() references
a function __init setup_usemap().
If setup_usemap is only used by free_area_init_core then
annotate setup_usemap with a matching annotation.

WARNING: mm/built-in.o(.data+0x10a4): Section mismatch in reference from the variable cpu_callback_nb.23582 to the function .devinit.text:cpu_callback()
The variable cpu_callback_nb.23582 references
the function __devinit cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

  CC      ipc/util.o
  CC      fs/mpage.o
[...]
  LDS     arch/x86/kernel/vmlinux.lds
  CC      kernel/power/swsusp.o
  CC      fs/nfsctl.o
  LD      arch/x86/kernel/built-in.o
WARNING: arch/x86/kernel/built-in.o(.text+0x13277): Section mismatch in reference from the function cpu_exit_clear() to the function .cpuinit.text:cpu_uninit()
The function cpu_exit_clear() references
the function __cpuinit cpu_uninit().
This is often because cpu_exit_clear lacks a __cpuinit 
annotation or the annotation of cpu_uninit is wrong.

  LD      security/built-in.o
[...]
  CC      kernel/latencytop.o
  CC [M]  fs/cifs/dir.o
  CC      block/genhd.o
  LD      kernel/built-in.o
fs/cifs/dir.c: In function ‘cifs_ci_compare’:
fs/cifs/dir.c:594: warning: passing argument 1 of ‘__constant_memcpy’ discards qualifiers from pointer target type
fs/cifs/dir.c:594: warning: passing argument 1 of ‘__memcpy’ discards qualifiers from pointer target type
fs/cifs/dir.c:594: warning: passing argument 1 of ‘__constant_memcpy’ discards qualifiers from pointer target type
fs/cifs/dir.c:594: warning: passing argument 1 of ‘__memcpy’ discards qualifiers from pointer target type
WARNING: kernel/built-in.o(.text+0x30269): Section mismatch in reference from the function take_cpu_down() to the variable .cpuinit.data:cpu_chain
The function take_cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because take_cpu_down lacks a __cpuinitdata 
annotation or the annotation of cpu_chain is wrong.

WARNING: kernel/built-in.o(.text+0x302f7): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata 
annotation or the annotation of cpu_chain is wrong.

WARNING: kernel/built-in.o(.text+0x3036d): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata 
annotation or the annotation of cpu_chain is wrong.

WARNING: kernel/built-in.o(.text+0x303cf): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata 
annotation or the annotation of cpu_chain is wrong.

WARNING: kernel/built-in.o(.text+0x303fb): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata 
annotation or the annotation of cpu_chain is wrong.

WARNING: kernel/built-in.o(.text+0x3050e): Section mismatch in reference from the function unregister_cpu_notifier() to the variable .cpuinit.data:cpu_chain
The function unregister_cpu_notifier() references
the variable __cpuinitdata cpu_chain.
This is often because unregister_cpu_notifier lacks a __cpuinitdata 
annotation or the annotation of cpu_chain is wrong.

WARNING: kernel/built-in.o(.data+0x270): Section mismatch in reference from the variable profile_cpu_callback_nb.19213 to the function .devinit.text:profile_cpu_callback()
The variable profile_cpu_callback_nb.19213 references
the function __devinit profile_cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: kernel/built-in.o(.data+0x1b48): Section mismatch in reference from the variable workqueue_cpu_callback_nb.13434 to the function .devinit.text:workqueue_cpu_callback()
The variable workqueue_cpu_callback_nb.13434 references
the function __devinit workqueue_cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

block/genhd.c: In function ‘genhd_device_init’:
block/genhd.c:361: warning: ignoring return value of ‘class_register’, declared with attribute warn_unused_result
  CC      drivers/acpi/tables.o
[...]
  LD [M]  fs/hfsplus/hfsplus.o
  CC [M]  fs/isofs/namei.o
  CC [M]  net/bluetooth/rfcomm/tty.o
  CC [M]  fs/isofs/inode.o
  LD [M]  net/bluetooth/rfcomm/rfcomm.o
  LD [M]  net/bluetooth/bluetooth.o
  LD      drivers/acpi/processor.o
WARNING: drivers/acpi/processor.o(.text+0xac5): Section mismatch in reference from the function acpi_processor_hotplug_notify() to the function .cpuinit.text:acpi_processor_start()
The function acpi_processor_hotplug_notify() references
the function __cpuinit acpi_processor_start().
This is often because acpi_processor_hotplug_notify lacks a __cpuinit 
annotation or the annotation of acpi_processor_start is wrong.

  LD      drivers/acpi/built-in.o
  CC [M]  net/bridge/br.o
WARNING: drivers/acpi/built-in.o(.text+0x1e709): Section mismatch in reference from the function acpi_processor_hotplug_notify() to the function .cpuinit.text:acpi_processor_start()
The function acpi_processor_hotplug_notify() references
the function __cpuinit acpi_processor_start().
This is often because acpi_processor_hotplug_notify lacks a __cpuinit 
annotation or the annotation of acpi_processor_start is wrong.

[...]
  CC      drivers/base/module.o
  LD [M]  net/bridge/bridge.o
  CC      net/core/sock.o
  LD      drivers/base/built-in.o
WARNING: drivers/base/built-in.o(.data+0x5a0): Section mismatch in reference from the variable topology_cpu_callback_nb.11044 to the function .cpuinit.text:topology_cpu_callback()
The variable topology_cpu_callback_nb.11044 references
the function __cpuinit topology_cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

  CC      drivers/block/brd.o
  CC      lib/scatterlist.o
[...]
  CC [M]  lib/ts_fsm.o
  CC      drivers/char/defkeymap.o
  LD      net/core/built-in.o
  CC      drivers/char/rtc.o
  CC [M]  fs/minix/itree_v2.o
  LD      lib/built-in.o
  CC      net/ethernet/eth.o
WARNING: lib/built-in.o(.data+0x60): Section mismatch in reference from the variable percpu_counter_hotcpu_callback_nb.9546 to the function .cpuinit.text:percpu_counter_hotcpu_callback()
The variable percpu_counter_hotcpu_callback_nb.9546 references
the function __cpuinit percpu_counter_hotcpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

  AR      lib/lib.a
  CC      arch/x86/lib/msr-on-cpu.o
  CC      drivers/char/hpet.o
[...]
  CC [M]  drivers/cpufreq/cpufreq_stats.o
  CC [M]  net/ieee80211/softmac/ieee80211softmac_module.o
  CC [M]  fs/nfsd/auth.o
  CC [M]  fs/nfs/pagelist.o
  LD      drivers/cpufreq/built-in.o
WARNING: drivers/cpufreq/built-in.o(.text+0x28): Section mismatch in reference from the function cpufreq_unregister_driver() to the variable .cpuinit.data:cpufreq_cpu_notifier
The function cpufreq_unregister_driver() references
the variable __cpuinitdata cpufreq_cpu_notifier.
This is often because cpufreq_unregister_driver lacks a __cpuinitdata 
annotation or the annotation of cpufreq_cpu_notifier is wrong.

WARNING: drivers/cpufreq/built-in.o(.text+0x1a2e): Section mismatch in reference from the function cpufreq_register_driver() to the variable .cpuinit.data:cpufreq_cpu_notifier
The function cpufreq_register_driver() references
the variable __cpuinitdata cpufreq_cpu_notifier.
This is often because cpufreq_register_driver lacks a __cpuinitdata 
annotation or the annotation of cpufreq_cpu_notifier is wrong.

  CC      drivers/cpuidle/cpuidle.o
  CC [M]  net/ieee80211/softmac/ieee80211softmac_scan.o
[...]
  LD      drivers/usb/built-in.o
  LD      drivers/built-in.o
WARNING: drivers/built-in.o(.text+0x2cdc5): Section mismatch in reference from the function acpi_processor_hotplug_notify() to the function .cpuinit.text:acpi_processor_start()
The function acpi_processor_hotplug_notify() references
the function __cpuinit acpi_processor_start().
This is often because acpi_processor_hotplug_notify lacks a __cpuinit 
annotation or the annotation of acpi_processor_start is wrong.

WARNING: drivers/built-in.o(.text+0xc07a8): Section mismatch in reference from the function cpufreq_unregister_driver() to the variable .cpuinit.data:cpufreq_cpu_notifier
The function cpufreq_unregister_driver() references
the variable __cpuinitdata cpufreq_cpu_notifier.
This is often because cpufreq_unregister_driver lacks a __cpuinitdata 
annotation or the annotation of cpufreq_cpu_notifier is wrong.

WARNING: drivers/built-in.o(.text+0xc21ae): Section mismatch in reference from the function cpufreq_register_driver() to the variable .cpuinit.data:cpufreq_cpu_notifier
The function cpufreq_register_driver() references
the variable __cpuinitdata cpufreq_cpu_notifier.
This is often because cpufreq_register_driver lacks a __cpuinitdata 
annotation or the annotation of cpufreq_cpu_notifier is wrong.

WARNING: drivers/built-in.o(.data+0x6ce0): Section mismatch in reference from the variable topology_cpu_callback_nb.11044 to the function .cpuinit.text:topology_cpu_callback()
The variable topology_cpu_callback_nb.11044 references
the function __cpuinit topology_cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x134d7): Section mismatch in reference from the function cpu_exit_clear() to the function .cpuinit.text:cpu_uninit()
The function cpu_exit_clear() references
the function __cpuinit cpu_uninit().
This is often because cpu_exit_clear lacks a __cpuinit 
annotation or the annotation of cpu_uninit is wrong.

WARNING: vmlinux.o(.text+0x4cfa9): Section mismatch in reference from the function take_cpu_down() to the variable .cpuinit.data:cpu_chain
The function take_cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because take_cpu_down lacks a __cpuinitdata 
annotation or the annotation of cpu_chain is wrong.

WARNING: vmlinux.o(.text+0x4d037): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata 
annotation or the annotation of cpu_chain is wrong.

WARNING: vmlinux.o(.text+0x4d0ad): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata 
annotation or the annotation of cpu_chain is wrong.

WARNING: vmlinux.o(.text+0x4d10f): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata 
annotation or the annotation of cpu_chain is wrong.

WARNING: vmlinux.o(.text+0x4d13b): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata 
annotation or the annotation of cpu_chain is wrong.

WARNING: vmlinux.o(.text+0x4d24e): Section mismatch in reference from the function unregister_cpu_notifier() to the variable .cpuinit.data:cpu_chain
The function unregister_cpu_notifier() references
the variable __cpuinitdata cpu_chain.
This is often because unregister_cpu_notifier lacks a __cpuinitdata 
annotation or the annotation of cpu_chain is wrong.

WARNING: vmlinux.o(.text+0x16e701): Section mismatch in reference from the function pci_scan_child_bus() to the function .devinit.text:pcibios_fixup_bus()
The function pci_scan_child_bus() references
the function __devinit pcibios_fixup_bus().
This is often because pci_scan_child_bus lacks a __devinit 
annotation or the annotation of pcibios_fixup_bus is wrong.

WARNING: vmlinux.o(.text+0x197007): Section mismatch in reference from the function acpi_pci_root_add() to the function .devinit.text:pci_acpi_scan_root()
The function acpi_pci_root_add() references
the function __devinit pci_acpi_scan_root().
This is often because acpi_pci_root_add lacks a __devinit 
annotation or the annotation of pci_acpi_scan_root is wrong.

WARNING: vmlinux.o(.text+0x19976b): Section mismatch in reference from the function acpi_processor_install_hotplug_notify() to the function .cpuinit.text:register_cpu_notifier()
The function acpi_processor_install_hotplug_notify() references
the function __cpuinit register_cpu_notifier().
This is often because acpi_processor_install_hotplug_notify lacks a __cpuinit 
annotation or the annotation of register_cpu_notifier is wrong.

WARNING: vmlinux.o(.text+0x1998f5): Section mismatch in reference from the function acpi_processor_hotplug_notify() to the function .cpuinit.text:acpi_processor_start()
The function acpi_processor_hotplug_notify() references
the function __cpuinit acpi_processor_start().
This is often because acpi_processor_hotplug_notify lacks a __cpuinit 
annotation or the annotation of acpi_processor_start is wrong.

WARNING: vmlinux.o(.text+0x1c2014): Section mismatch in reference from the function store_online() to the function .cpuinit.text:cpu_up()
The function store_online() references
the function __cpuinit cpu_up().
This is often because store_online lacks a __cpuinit 
annotation or the annotation of cpu_up is wrong.

WARNING: vmlinux.o(.text+0x22d2d8): Section mismatch in reference from the function cpufreq_unregister_driver() to the variable .cpuinit.data:cpufreq_cpu_notifier
The function cpufreq_unregister_driver() references
the variable __cpuinitdata cpufreq_cpu_notifier.
This is often because cpufreq_unregister_driver lacks a __cpuinitdata 
annotation or the annotation of cpufreq_cpu_notifier is wrong.

WARNING: vmlinux.o(.text+0x22ecde): Section mismatch in reference from the function cpufreq_register_driver() to the variable .cpuinit.data:cpufreq_cpu_notifier
The function cpufreq_register_driver() references
the variable __cpuinitdata cpufreq_cpu_notifier.
This is often because cpufreq_register_driver lacks a __cpuinitdata 
annotation or the annotation of cpufreq_cpu_notifier is wrong.

WARNING: vmlinux.o(.text+0x22ece3): Section mismatch in reference from the function cpufreq_register_driver() to the function .cpuinit.text:register_cpu_notifier()
The function cpufreq_register_driver() references
the function __cpuinit register_cpu_notifier().
This is often because cpufreq_register_driver lacks a __cpuinit 
annotation or the annotation of register_cpu_notifier is wrong.

WARNING: vmlinux.o(.meminit.text+0x90e): Section mismatch in reference from the function free_area_init_core() to the function .init.text:setup_usemap()
The function __meminit free_area_init_core() references
a function __init setup_usemap().
If setup_usemap is only used by free_area_init_core then
annotate setup_usemap with a matching annotation.

WARNING: vmlinux.o(.data+0x3830): Section mismatch in reference from the variable profile_cpu_callback_nb.19213 to the function .devinit.text:profile_cpu_callback()
The variable profile_cpu_callback_nb.19213 references
the function __devinit profile_cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: vmlinux.o(.data+0x5108): Section mismatch in reference from the variable workqueue_cpu_callback_nb.13434 to the function .devinit.text:workqueue_cpu_callback()
The variable workqueue_cpu_callback_nb.13434 references
the function __devinit workqueue_cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: vmlinux.o(.data+0x6f64): Section mismatch in reference from the variable cpu_callback_nb.23582 to the function .devinit.text:cpu_callback()
The variable cpu_callback_nb.23582 references
the function __devinit cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: vmlinux.o(.data+0xc2d4): Section mismatch in reference from the variable percpu_counter_hotcpu_callback_nb.9546 to the function .cpuinit.text:percpu_counter_hotcpu_callback()
The variable percpu_counter_hotcpu_callback_nb.9546 references
the function __cpuinit percpu_counter_hotcpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: vmlinux.o(.data+0x12fe0): Section mismatch in reference from the variable topology_cpu_callback_nb.11044 to the function .cpuinit.text:topology_cpu_callback()
The variable topology_cpu_callback_nb.11044 references
the function __cpuinit topology_cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
  KSYM    .tmp_kallsyms1.S
  AS      .tmp_kallsyms1.o
  LD      .tmp_vmlinux2
  KSYM    .tmp_kallsyms2.S
  AS      .tmp_kallsyms2.o
  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map
  Building modules, stage 2.
  CC      arch/x86/boot/version.o
  AS      arch/x86/boot/compressed/head_32.o
  OBJCOPY arch/x86/boot/compressed/vmlinux.bin
  LD      arch/x86/boot/setup.elf
  OBJCOPY arch/x86/boot/setup.bin
  GZIP    arch/x86/boot/compressed/vmlinux.bin.gz
  MODPOST 437 modules
WARNING: drivers/cpufreq/cpufreq_stats.o(.exit.text+0x20): Section mismatch in reference from the function cleanup_module() to the variable .cpuinit.data:cpufreq_stat_cpu_notifier
The function __exit cleanup_module() references
a variable __cpuinitdata cpufreq_stat_cpu_notifier.
This is often seen when error handling in the exit function
uses functionality in the init path.
The fix is often to remove the __cpuinitdata annotation of
cpufreq_stat_cpu_notifier so it may be used outside an init section.

  LD      arch/x86/boot/compressed/piggy.o
  LD      arch/x86/boot/compressed/vmlinux
  OBJCOPY arch/x86/boot/vmlinux.bin
  BUILD   arch/x86/boot/bzImage
Root device is (8, 3)
Setup is 10460 bytes (padded to 10752 bytes).
System is 2285 kB
Kernel: arch/x86/boot/bzImage is ready  (#9)

