Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793Ab0AMSvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0AMSvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 13:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642Ab0AMSvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 13:51:31 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:41800 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab0AMSvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 13:51:31 -0500
Message-ID: <4B4E1633.8010700@pardus.org.tr>
Date: Wed, 13 Jan 2010 20:51:31 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Boot hangs after "Freeing initrd memory" with 2.6.31.11
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A lot of our users complains about the problem in $subject. Here are some clues:

- All users have mainboards with nForce2 chipset:
  nVidia Corporation nForce2 IGP2 [10de:01e0] (rev c1)
- The last working kernel for them is 2.6.30.9. They can't boot into 2.6.31.9-11,
- They all tried several boot parameters to disable acpi, lapic, mce, etc. none of them works,
- Their last working kernel (2.6.30.9)'s all shows some suspicious stuff:

[    0.000000] Using APIC driver default                             
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.  
[    0.000000] If you got timer trouble try acpi_use_timer_override  
[    0.000000] ACPI: PM-Timer IO Port: 0x4008                        
[    0.000000] ACPI: Local APIC address 0xfee00000                   
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)    
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])   
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])          
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23   
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)         
[    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.                
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)      
[    0.000000] ACPI: IRQ9 used by override.                          
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs         
[    0.000000] Using ACPI (MADT) for SMP configuration information   
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs                  
[    0.000000] nr_irqs_gsi: 24
...
...
[    0.102842] pci 0000:00:00.0: reg 10 32bit mmio: [0xe0000000-0xe7ffffff]     
[    0.102858] pci 0000:00:00.0: nForce2 C1 Halt Disconnect fixup    
[    0.103045] pci 0000:00:01.1: reg 10 io port: [0xe400-0xe41f]     
[    0.103079] pci 0000:00:01.1: PME# supported from D3hot D3cold    
[    0.103083] pci 0000:00:01.1: PME# disabled
...
...
[    0.224587] Unpacking initramfs...                                
[    0.407342] Freeing initrd memory: 4954k freed                    
[    0.413366] cpu0(1) debug files 5                                 
[    0.413372] Machine check exception polling timer started.        
[    0.413382] cpufreq-nforce2: Detected nForce2 chipset revision C1 
[    0.413385] cpufreq-nforce2: FSB changing is maybe unstable and can lead to crashes and data loss.                                     
[    0.413398] cpufreq-nforce2: FSB currently at 200 MHz, FID 11.0   
[    0.413423] ondemand governor failed, too long transition latency of HW, fallback to performance governor


I've googled a lot but couldn't find a similar bug report/regression between 2.6.30 and 2.6.31. I wanted to know how
should I help them debugging the issue (except bisect because that would be a tough task for them).

What should I interpret from a hang just after freeing initrd memory? They can't even reach the busybox in the initramfs
so I can't suspect the initramfs code for now.

Note that I've done two radical configuration changes from 2.6.30->2.6.31: Building AGP drivers and libata driver
into the kernel image.

Regards,

Ozan Caglayan
Pardus Linux -- http://www.pardus.org.tr/eng
