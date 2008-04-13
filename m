Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbYDMO3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbYDMO3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 10:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbYDMO3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 10:29:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:59978 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYDMO3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 10:29:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CxpoaPUe4RI7i1CLgJZCTz4L26PS6QFw24K6BmYGo56YIx1gj3sIuVVGOul5Z04TyNO2XiWTD/nYZgItVMmp58sHb8Sqz0AH4qgdqu6ZhyI6CNbVi7vEa0108Uyj5XSZjPS8RJmh9baKWybOHFskr1xcogNA67rRF0h0pSB7FZ0=
Message-ID: <e2e108260804130729g1f2d1cd4h37098680c0e83a0@mail.gmail.com>
Date: Sun, 13 Apr 2008 16:29:21 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.25-rc9
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.00.0804111340240.3143@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0804111340240.3143@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 10:51 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>  I really don't want to do this, and I was actually hoping to release
>  2.6.25 last weekend (which is why -rc9 is a few days late - just me hoping
>  to not do another -rc at all), but I've done an -rc9.

I just noticed that the following message is printed when I build
2.6.25-rc7 or 2.6.25-rc9 on my system (x86_64):
$ make bzImage
...
WARNING: modpost: Found 26 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
...

The whole list of warnings is as follows:

$ make CONFIG_DEBUG_SECTION_MISMATCH=y bzImage
WARNING: arch/x86/kernel/built-in.o(.data+0x5e0): Section mismatch in
reference from the variable cpu_vsyscall_notifier_nb.11607 to the
function .cpuinit.text:cpu_vsyscall_notifier()
The variable cpu_vsyscall_notifier_nb.11607 references
the function __cpuinit cpu_vsyscall_notifier()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: kernel/built-in.o(.text+0x2840b): Section mismatch in
reference from the function take_cpu_down() to the variable
.cpuinit.data:cpu_chain
The function take_cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because take_cpu_down lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

WARNING: kernel/built-in.o(.text+0x284a7): Section mismatch in
reference from the function _cpu_down() to the variable
.cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

WARNING: kernel/built-in.o(.text+0x284cb): Section mismatch in
reference from the function _cpu_down() to the variable
.cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

WARNING: kernel/built-in.o(.text+0x2857a): Section mismatch in
reference from the function _cpu_down() to the variable
.cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

WARNING: kernel/built-in.o(.text+0x285c6): Section mismatch in
reference from the function _cpu_down() to the variable
.cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

WARNING: kernel/built-in.o(.text+0x286d7): Section mismatch in
reference from the function unregister_cpu_notifier() to the variable
.cpuinit.data:cpu_chain
The function unregister_cpu_notifier() references
the variable __cpuinitdata cpu_chain.
This is often because unregister_cpu_notifier lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

WARNING: kernel/built-in.o(.data+0x4e0): Section mismatch in reference
from the variable profile_cpu_callback_nb.16348 to the function
.devinit.text:profile_cpu_callback()
The variable profile_cpu_callback_nb.16348 references
the function __devinit profile_cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: kernel/built-in.o(.data+0x2f10): Section mismatch in
reference from the variable workqueue_cpu_callback_nb.13579 to the
function .devinit.text:workqueue_cpu_callback()
The variable workqueue_cpu_callback_nb.13579 references
the function __devinit workqueue_cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: kernel/built-in.o(.data+0x5700): Section mismatch in
reference from the variable relay_hotcpu_callback_nb.18209 to the
function .cpuinit.text:relay_hotcpu_callback()
The variable relay_hotcpu_callback_nb.18209 references
the function __cpuinit relay_hotcpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: mm/built-in.o(.data+0x98d0): Section mismatch in reference
from the variable cpu_callback_nb.23084 to the function
.devinit.text:cpu_callback()
The variable cpu_callback_nb.23084 references
the function __devinit cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/base/built-in.o(.data+0xb20): Section mismatch in
reference from the variable topology_cpu_callback_nb.11157 to the
function .cpuinit.text:topology_cpu_callback()
The variable topology_cpu_callback_nb.11157 references
the function __cpuinit topology_cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/serial/built-in.o(.data+0x460): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:pci_ite887x_exit()
The variable pci_serial_quirks references
the function __devexit pci_ite887x_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/serial/built-in.o(.data+0x488): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:pci_plx9050_exit()
The variable pci_serial_quirks references
the function __devexit pci_plx9050_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/serial/built-in.o(.data+0x4b0): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:pci_plx9050_exit()
The variable pci_serial_quirks references
the function __devexit pci_plx9050_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/serial/built-in.o(.data+0x500): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:pci_plx9050_exit()
The variable pci_serial_quirks references
the function __devexit pci_plx9050_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/serial/built-in.o(.data+0x528): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:pci_plx9050_exit()
The variable pci_serial_quirks references
the function __devexit pci_plx9050_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/serial/built-in.o(.data+0x550): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:pci_plx9050_exit()
The variable pci_serial_quirks references
the function __devexit pci_plx9050_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/serial/built-in.o(.data+0x578): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:sbs_exit()
The variable pci_serial_quirks references
the function __devexit sbs_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/serial/built-in.o(.data+0x5a0): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:sbs_exit()
The variable pci_serial_quirks references
the function __devexit sbs_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/serial/built-in.o(.data+0x5c8): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:sbs_exit()
The variable pci_serial_quirks references
the function __devexit sbs_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/serial/built-in.o(.data+0x5f0): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:sbs_exit()
The variable pci_serial_quirks references
the function __devexit sbs_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/built-in.o(.data+0x9900): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:pci_ite887x_exit()
The variable pci_serial_quirks references
the function __devexit pci_ite887x_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/built-in.o(.data+0x9928): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:pci_plx9050_exit()
The variable pci_serial_quirks references
the function __devexit pci_plx9050_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/built-in.o(.data+0x9950): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:pci_plx9050_exit()
The variable pci_serial_quirks references
the function __devexit pci_plx9050_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/built-in.o(.data+0x99a0): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:pci_plx9050_exit()
The variable pci_serial_quirks references
the function __devexit pci_plx9050_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/built-in.o(.data+0x99c8): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:pci_plx9050_exit()
The variable pci_serial_quirks references
the function __devexit pci_plx9050_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/built-in.o(.data+0x99f0): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:pci_plx9050_exit()
The variable pci_serial_quirks references
the function __devexit pci_plx9050_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/built-in.o(.data+0x9a18): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:sbs_exit()
The variable pci_serial_quirks references
the function __devexit sbs_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/built-in.o(.data+0x9a40): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:sbs_exit()
The variable pci_serial_quirks references
the function __devexit sbs_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/built-in.o(.data+0x9a68): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:sbs_exit()
The variable pci_serial_quirks references
the function __devexit sbs_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/built-in.o(.data+0x9a90): Section mismatch in
reference from the variable pci_serial_quirks to the function
.devexit.text:sbs_exit()
The variable pci_serial_quirks references
the function __devexit sbs_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/built-in.o(.data+0xbd80): Section mismatch in
reference from the variable topology_cpu_callback_nb.11157 to the
function .cpuinit.text:topology_cpu_callback()
The variable topology_cpu_callback_nb.11157 references
the function __cpuinit topology_cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: lib/built-in.o(.data+0x40): Section mismatch in reference
from the variable percpu_counter_hotcpu_callback_nb.9655 to the
function .cpuinit.text:percpu_counter_hotcpu_callback()
The variable percpu_counter_hotcpu_callback_nb.9655 references
the function __cpuinit percpu_counter_hotcpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.text+0x4439f): Section mismatch in reference from
the function take_cpu_down() to the variable .cpuinit.data:cpu_chain
The function take_cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because take_cpu_down lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

WARNING: vmlinux.o(.text+0x4443b): Section mismatch in reference from
the function _cpu_down() to the variable .cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

WARNING: vmlinux.o(.text+0x4445f): Section mismatch in reference from
the function _cpu_down() to the variable .cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

WARNING: vmlinux.o(.text+0x4450e): Section mismatch in reference from
the function _cpu_down() to the variable .cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

WARNING: vmlinux.o(.text+0x4455a): Section mismatch in reference from
the function _cpu_down() to the variable .cpuinit.data:cpu_chain
The function _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

WARNING: vmlinux.o(.text+0x4466b): Section mismatch in reference from
the function unregister_cpu_notifier() to the variable
.cpuinit.data:cpu_chain
The function unregister_cpu_notifier() references
the variable __cpuinitdata cpu_chain.
This is often because unregister_cpu_notifier lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

WARNING: vmlinux.o(.text+0x12ddef): Section mismatch in reference from
the function xfs_icsb_init_counters() to the function
.cpuinit.text:register_cpu_notifier()
The function xfs_icsb_init_counters() references
the function __cpuinit register_cpu_notifier().
This is often because xfs_icsb_init_counters lacks a __cpuinit
annotation or the annotation of register_cpu_notifier is wrong.

WARNING: vmlinux.o(.text+0x1edc11): Section mismatch in reference from
the function store_online() to the function .cpuinit.text:cpu_up()
The function store_online() references
the function __cpuinit cpu_up().
This is often because store_online lacks a __cpuinit
annotation or the annotation of cpu_up is wrong.

WARNING: vmlinux.o(.text+0x2461b1): Section mismatch in reference from
the function cpufreq_register_driver() to the function
.cpuinit.text:register_cpu_notifier()
The function cpufreq_register_driver() references
the function __cpuinit register_cpu_notifier().
This is often because cpufreq_register_driver lacks a __cpuinit
annotation or the annotation of register_cpu_notifier is wrong.

WARNING: vmlinux.o(.data+0x28e0): Section mismatch in reference from
the variable cpu_vsyscall_notifier_nb.11607 to the function
.cpuinit.text:cpu_vsyscall_notifier()
The variable cpu_vsyscall_notifier_nb.11607 references
the function __cpuinit cpu_vsyscall_notifier()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0x55e0): Section mismatch in reference from
the variable profile_cpu_callback_nb.16348 to the function
.devinit.text:profile_cpu_callback()
The variable profile_cpu_callback_nb.16348 references
the function __devinit profile_cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0x8010): Section mismatch in reference from
the variable workqueue_cpu_callback_nb.13579 to the function
.devinit.text:workqueue_cpu_callback()
The variable workqueue_cpu_callback_nb.13579 references
the function __devinit workqueue_cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0xa800): Section mismatch in reference from
the variable relay_hotcpu_callback_nb.18209 to the function
.cpuinit.text:relay_hotcpu_callback()
The variable relay_hotcpu_callback_nb.18209 references
the function __cpuinit relay_hotcpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0x14550): Section mismatch in reference from
the variable cpu_callback_nb.23084 to the function
.devinit.text:cpu_callback()
The variable cpu_callback_nb.23084 references
the function __devinit cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0x1f4a0): Section mismatch in reference from
the variable percpu_counter_hotcpu_callback_nb.9655 to the function
.cpuinit.text:percpu_counter_hotcpu_callback()
The variable percpu_counter_hotcpu_callback_nb.9655 references
the function __cpuinit percpu_counter_hotcpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0x28e00): Section mismatch in reference from
the variable pci_serial_quirks to the function
.devexit.text:pci_ite887x_exit()
The variable pci_serial_quirks references
the function __devexit pci_ite887x_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0x28e28): Section mismatch in reference from
the variable pci_serial_quirks to the function
.devexit.text:pci_plx9050_exit()
The variable pci_serial_quirks references
the function __devexit pci_plx9050_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0x28e50): Section mismatch in reference from
the variable pci_serial_quirks to the function
.devexit.text:pci_plx9050_exit()
The variable pci_serial_quirks references
the function __devexit pci_plx9050_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0x28ea0): Section mismatch in reference from
the variable pci_serial_quirks to the function
.devexit.text:pci_plx9050_exit()
The variable pci_serial_quirks references
the function __devexit pci_plx9050_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0x28ec8): Section mismatch in reference from
the variable pci_serial_quirks to the function
.devexit.text:pci_plx9050_exit()
The variable pci_serial_quirks references
the function __devexit pci_plx9050_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0x28ef0): Section mismatch in reference from
the variable pci_serial_quirks to the function
.devexit.text:pci_plx9050_exit()
The variable pci_serial_quirks references
the function __devexit pci_plx9050_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0x28f18): Section mismatch in reference from
the variable pci_serial_quirks to the function
.devexit.text:sbs_exit()
The variable pci_serial_quirks references
the function __devexit sbs_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0x28f40): Section mismatch in reference from
the variable pci_serial_quirks to the function
.devexit.text:sbs_exit()
The variable pci_serial_quirks references
the function __devexit sbs_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0x28f68): Section mismatch in reference from
the variable pci_serial_quirks to the function
.devexit.text:sbs_exit()
The variable pci_serial_quirks references
the function __devexit sbs_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0x28f90): Section mismatch in reference from
the variable pci_serial_quirks to the function
.devexit.text:sbs_exit()
The variable pci_serial_quirks references
the function __devexit sbs_exit()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0x2b280): Section mismatch in reference from
the variable topology_cpu_callback_nb.11157 to the function
.cpuinit.text:topology_cpu_callback()
The variable topology_cpu_callback_nb.11157 references
the function __cpuinit topology_cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
