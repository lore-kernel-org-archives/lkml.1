Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbZKINIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbZKINIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 08:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZKINIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 08:08:35 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:46727 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZKINIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 08:08:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=dSc9rbpVeKoMe0se9EHz+qap42qNxwwuoh6da+IbaPH0CRwKkiGgEaRK75kV7LvNi9
         MktYqtede+K+Sbx4jnJjZIKr7z05bJ5EgPBp9HCFQULNwlmYcmI35dmK7mYgG/DdJHaz
         xMODaHR/JTWoFJHz/0h9/Ppi9C45jgRwgBE3g=
Message-ID: <4AF81453.7030305@gmail.com>
Date: Mon, 09 Nov 2009 08:08:35 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linux Kernel Developers <linux-kernel@vger.kernel.org>
Subject: net-next-2.6 compilation errors and section mismatches
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally reported to the netdev list, as this was prompted by some recent
import/merge of another tree.  Andi Kleen recommended reporting here.

Ubuntu's config-2.6.31-14-generic -- plus defaults for all (NEW) config --
doesn't compile as of yesterday:

/home/administer/net-next-2.6/drivers/staging/android/logger.c: In function ‘logger_read’:
/home/administer/net-next-2.6/drivers/staging/android/logger.c:165: error: ‘TASK_INTERRUPTIBLE’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/staging/android/logger.c:165: error: (Each undeclared identifier is reported only once
/home/administer/net-next-2.6/drivers/staging/android/logger.c:165: error: for each function it appears in.)
/home/administer/net-next-2.6/drivers/staging/android/logger.c:178: error: implicit declaration of function ‘signal_pending’
/home/administer/net-next-2.6/drivers/staging/android/logger.c:183: error: implicit declaration of function ‘schedule’
/home/administer/net-next-2.6/drivers/staging/android/logger.c: In function ‘logger_aio_write’:
/home/administer/net-next-2.6/drivers/staging/android/logger.c:325: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/staging/android/logger.c:333: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/staging/android/logger.c:334: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/staging/android/logger.c:337: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/staging/android/logger.c:360: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/staging/android/logger.c:363: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/staging/android/logger.c:370: error: increment of pointer to unknown structure
/home/administer/net-next-2.6/drivers/staging/android/logger.c:370: error: arithmetic on pointer to an incomplete type
/home/administer/net-next-2.6/drivers/staging/android/logger.c:377: error: ‘TASK_INTERRUPTIBLE’ undeclared (first use in this function)
make[4]: *** [drivers/staging/android/logger.o] Error 1
make[3]: *** [drivers/staging/android] Error 2
make[2]: *** [drivers/staging] Error 2
make[2]: *** Waiting for unfinished jobs....


'make CONFIG_DEBUG_SECTION_MISMATCH=y vmlinux' has more section mismatches,
although one has been present for weeks:

/home/administer/net-next-2.6/arch/x86/include/asm/string_32.h:74: warning: array subscript is above array bounds
WARNING: drivers/acpi/processor.o(.text+0xa88): Section mismatch in reference from the function acpi_processor_add() to the function .cpuinit.text:acpi_processor_power_init()
The function acpi_processor_add() references
the function __cpuinit acpi_processor_power_init().
This is often because acpi_processor_add lacks a __cpuinit
annotation or the annotation of acpi_processor_power_init is wrong.

WARNING: drivers/acpi/built-in.o(.text+0x21f24): Section mismatch in reference from the function acpi_processor_add() to the function .cpuinit.text:acpi_processor_power_init()
The function acpi_processor_add() references
the function __cpuinit acpi_processor_power_init().
This is often because acpi_processor_add lacks a __cpuinit
annotation or the annotation of acpi_processor_power_init is wrong.

/home/administer/net-next-2.6/include/linux/mca-legacy.h:12:2: warning: #warning "MCA legacy - please move your driver to the new sysfs api"
WARNING: drivers/net/phy/built-in.o(.devexit.text+0x13): Section mismatch in reference from the function mdio_gpio_bus_destroy() to the function .devinit.text:mdio_gpio_bus_deinit()
The function __devexit mdio_gpio_bus_destroy() references
a function __devinit mdio_gpio_bus_deinit().
This is often seen when error handling in the exit function
uses functionality in the init path.
The fix is often to remove the __devinit annotation of
mdio_gpio_bus_deinit() so it may be used outside an init section.

WARNING: drivers/net/built-in.o(.devexit.text+0x13): Section mismatch in reference from the function mdio_gpio_bus_destroy() to the function .devinit.text:mdio_gpio_bus_deinit()
The function __devexit mdio_gpio_bus_destroy() references
a function __devinit mdio_gpio_bus_deinit().
This is often seen when error handling in the exit function
uses functionality in the init path.
The fix is often to remove the __devinit annotation of
mdio_gpio_bus_deinit() so it may be used outside an init section.

/home/administer/net-next-2.6/arch/x86/include/asm/string_32.h:74: warning: array subscript is above array bounds
WARNING: drivers/built-in.o(.text+0x48274): Section mismatch in reference from the function acpi_processor_add() to the function .cpuinit.text:acpi_processor_power_init()
The function acpi_processor_add() references
the function __cpuinit acpi_processor_power_init().
This is often because acpi_processor_add lacks a __cpuinit
annotation or the annotation of acpi_processor_power_init is wrong.

WARNING: drivers/built-in.o(.devexit.text+0x38c): Section mismatch in reference from the function mdio_gpio_bus_destroy() to the function .devinit.text:mdio_gpio_bus_deinit()
The function __devexit mdio_gpio_bus_destroy() references
a function __devinit mdio_gpio_bus_deinit().
This is often seen when error handling in the exit function
uses functionality in the init path.
The fix is often to remove the __devinit annotation of
mdio_gpio_bus_deinit() so it may be used outside an init section.

WARNING: vmlinux.o(.text+0x27c824): Section mismatch in reference from the function acpi_processor_add() to the function .cpuinit.text:acpi_processor_power_init()
The function acpi_processor_add() references
the function __cpuinit acpi_processor_power_init().
This is often because acpi_processor_add lacks a __cpuinit
annotation or the annotation of acpi_processor_power_init is wrong.

WARNING: vmlinux.o(.text+0x2c8469): Section mismatch in reference from the function twl4030_sih_setup() to the function .init.text:set_irq_noprobe()
The function twl4030_sih_setup() references
the function __init set_irq_noprobe().
This is often because twl4030_sih_setup lacks a __init
annotation or the annotation of set_irq_noprobe is wrong.

WARNING: vmlinux.o(.text+0x2c8581): Section mismatch in reference from the function twl_init_irq() to the function .init.text:set_irq_noprobe()
The function twl_init_irq() references
the function __init set_irq_noprobe().
This is often because twl_init_irq lacks a __init
annotation or the annotation of set_irq_noprobe is wrong.

WARNING: vmlinux.o(.devexit.text+0x3e1): Section mismatch in reference from the function mdio_gpio_bus_destroy() to the function .devinit.text:mdio_gpio_bus_deinit()
The function __devexit mdio_gpio_bus_destroy() references
a function __devinit mdio_gpio_bus_deinit().
This is often seen when error handling in the exit function
uses functionality in the init path.
The fix is often to remove the __devinit annotation of
mdio_gpio_bus_deinit() so it may be used outside an init section.




