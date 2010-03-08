Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab0CHXrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:47:46 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60658 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab0CHXrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:47:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=FPFCJrgiKi9+Hq9z+pA5OwWTFjs5r48Dd/vW+FwE6+t98EvMY/gPJPYDMThBXet8mT
         WKsP+GSIlOG+HsGvDgnUiVXjFK8ocicoHSMzNL1GfqUmsooQw3H7JyywJ7xaEPguqrvn
         Jq3Pr7oPthQ4ExowG5eEcFVtCLA+kA+yJpOuc=
MIME-Version: 1.0
Date: Tue, 9 Mar 2010 02:47:41 +0300
Message-ID: <a4423d671003081547v5c955d58t248db945c06d2a7f@mail.gmail.com>
Subject: 2.6.34-rc1: ACPI: BUG: key f71f0168 not in .data!
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Kernel version is 2.6.34-rc1

bus: 'acpi': add driver processor
bus: 'acpi': driver_probe_device: matched device LNXCPU:00 with driver processor
bus: 'acpi': really_probe: probing driver processor with device LNXCPU:00
device: 'cooling_device0': device_add
driver: 'LNXCPU:00': driver_bound: bound to device 'processor'
bus: 'acpi': really_probe: bound device LNXCPU:00 to driver processor
bus: 'acpi': add driver thermal
bus: 'acpi': driver_probe_device: matched device LNXTHERM:00 with driver thermal
bus: 'acpi': really_probe: probing driver thermal with device LNXTHERM:00
bus: 'acpi': driver_probe_device: matched device LNXTHERM:01 with driver thermal
bus: 'acpi': really_probe: probing driver thermal with device LNXTHERM:01
device: 'thermal_zone0': device_add
BUG: key f71f0168 not in .data!
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x16f/0x4f0()
Hardware name:
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.34-rc1 #1
Call Trace:
 [<c1351758>] ? printk+0x18/0x20
 [<c102aa5d>] warn_slowpath_common+0x6d/0xa0
 [<c104e9af>] ? lockdep_init_map+0x16f/0x4f0
 [<c104e9af>] ? lockdep_init_map+0x16f/0x4f0
 [<c1001000>] ? do_one_initcall+0x0/0x190
 [<c102aaa5>] warn_slowpath_null+0x15/0x20
 [<c104e9af>] lockdep_init_map+0x16f/0x4f0
 [<c10dcd98>] sysfs_add_file_mode+0x58/0xb0
 [<c10dce03>] sysfs_add_file+0x13/0x20
Switched to NOHz mode on CPU #0
 [<c10dcec6>] sysfs_create_file+0x26/0x30
 [<c1247ab3>] device_create_file+0x13/0x20
 [<c12c5bd4>] thermal_zone_bind_cooling_device+0x1e4/0x2f0
 [<c11feb35>] ? acpi_bus_data_handler+0x0/0x5
 [<c121ed40>] acpi_thermal_cooling_device_cb+0x70/0x11e
 [<c12c5780>] ? thermal_zone_device_register+0x260/0x400
 [<c12c59f0>] ? thermal_zone_bind_cooling_device+0x0/0x2f0
 [<c121ee0a>] acpi_thermal_bind_cooling_device+0xd/0xf
 [<c12c57f9>] thermal_zone_device_register+0x2d9/0x400
 [<c121ef82>] acpi_thermal_add+0x176/0x398
 [<c10de301>] ? sysfs_do_create_link+0xa1/0x140
 [<c11fec0f>] acpi_device_probe+0x3a/0xf4
 [<c124a097>] driver_probe_device+0xb7/0x1b0
 [<c124a219>] __driver_attach+0x89/0x90
 [<c12498b8>] bus_for_each_dev+0x48/0x70
 [<c1249e79>] driver_attach+0x19/0x20
 [<c124a190>] ? __driver_attach+0x0/0x90
 [<c124922b>] bus_add_driver+0xcb/0x230
 [<c11feb45>] ? acpi_device_remove+0x0/0x90
 [<c124a495>] driver_register+0x65/0x110
 [<c162119a>] ? kernel_init+0x0/0x120
 [<c10d6bd3>] ? proc_mkdir_mode+0x33/0x50
 [<c162119a>] ? kernel_init+0x0/0x120
 [<c11ffebb>] acpi_bus_register_driver+0x3a/0x3f
 [<c1639062>] acpi_thermal_init+0x50/0x6f
 [<c100102d>] do_one_initcall+0x2d/0x190
 [<c162119a>] ? kernel_init+0x0/0x120
 [<c1639012>] ? acpi_thermal_init+0x0/0x6f
 [<c162119a>] ? kernel_init+0x0/0x120
 [<c1621221>] kernel_init+0x87/0x120
 [<c1002fba>] kernel_thread_helper+0x6/0x1c
---[ end trace a7919e7f17c0a725 ]---
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (39 C)
driver: 'LNXTHERM:01': driver_bound: bound to device 'thermal'
bus: 'acpi': really_probe: bound device LNXTHERM:01 to driver thermal

CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_POWER_METER is not set
# CONFIG_ACPI_SYSFS_POWER is not set
# CONFIG_ACPI_PROC_EVENT is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_PNPACPI=y
