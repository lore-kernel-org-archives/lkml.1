Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbZDTFPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbZDTFPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 01:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbZDTFPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 01:15:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:3580 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbZDTFPj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 01:15:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wIKir9POdaPOxMFM5TwGGO1lJJ8sFu03wTK6TR/pw9EhdPC9l3ZxPZZdGxT8ayvaoI
         sMxYqaqA75NRDe7aQUuYCPCIuYaTSJQx+/Ls2aGyqgrug3O4CYV9KDXiX2+/PyL/BeiW
         C5NpSPjmLfXkBwj2teMrhFJmbQVotA/tXekCo=
MIME-Version: 1.0
In-Reply-To: <8db1092f0904171003u462b9d90pe874cd63c7a22a1d@mail.gmail.com>
References: <8db1092f0904171003u462b9d90pe874cd63c7a22a1d@mail.gmail.com>
Date: Sun, 19 Apr 2009 22:15:36 -0700
Message-ID: <86802c440904192215k4a2fedb1s9587cee52d685f5b@mail.gmail.com>
Subject: Re: Spontaneous reboots since 2.6.29-rc*
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 10:03 AM, Maciej Rutecki
<maciej.rutecki@gmail.com> wrote:
> Sometimes I observed spontaneous reboots during booting kernel, after
> this message:
> [...]
> [    0.024996] ... PM-Timer delta = 357949
> [    0.024996] ... PM-Timer result ok
> [    0.024996] ..... delta 1249983
> [    0.024996] ..... mult: 53694522
> [    0.024996] ..... calibration result: 199997
> [    0.024996] ..... CPU clock speed is 1999.0972 MHz.
> [    0.024996] ..... host bus clock speed is 199.0997 MHz.
> [    0.024996] Booting processor 1 APIC 0x1 ip 0x6000
>
> after this should be:
> [    0.000999] Initializing CPU#1
> [    0.000999] masked ExtINT on CPU#1
> [    0.000999] Calibrating delay using timer specific routine..
> 4067.56 BogoMIPS (lpj=2033784)
> [    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.000999] CPU: L2 cache: 1024K
>
>
> Also I found this message in dmesg:
> [    0.000000] 4 Processors exceeds NR_CPUS limit of 2
> [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs

your config has
CONFIG_NR_CPUS=2

ACPI MADT said:
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)

so it should be ok

but the MTRR looks weird...

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf5e0000 (usable)
[    0.000000]  BIOS-e820: 00000000bf5e0000 - 00000000bf5e3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf5e3000 - 00000000bf5f0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf5f0000 - 00000000bf600000 (reserved)
[    0.000000]  BIOS-e820: 00000000c0000000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0xbf5e0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CAFFF write-protect
[    0.000000]   CB000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   2 base 0BF800000 mask FFF800000 uncachable
[    0.000000]   3 base 0BF700000 mask FFFF00000 uncachable
[    0.000000]   4 base 0BF600000 mask FFFF00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled

[   17.421843] [drm] Initialized drm 1.1.0 20060810
[   17.431172] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   17.431179] pci 0000:00:02.0: setting latency timer to 64
[   17.433356] mtrr: type mismatch for d0000000,10000000 old:
write-back new: write-combining
[   17.433360] [drm] MTRR allocation failed.  Graphics performance may suffer.
[   17.433388] pci 0000:00:02.0: irq 27 for MSI/MSI-X
[   17.433409] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   17.452114] mtrr: type mismatch for d0000000,10000000 old:
write-back new: write-combining
[   17.749084] set status page addr 0x00043000

maybe you could enable
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1

YH
