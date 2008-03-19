Return-Path: <linux-kernel-owner+w=401wt.eu-S943645AbYCTABa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943645AbYCTABa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966851AbYCSWsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:48:05 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:51810 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966845AbYCSWsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:48:02 -0400
Message-ID: <47E068E3.8050908@suse.de>
Date: Wed, 19 Mar 2008 04:14:11 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Guillaume Chazarain <guichaz@gmail.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
       Tim Elliott <tle@holymonkey.com>
Subject: Re: ACPI regression in 2.6.25-rc6 (function keys stop working)
References: <3d8471ca0803171713q31b87939y557f6408543ac881@mail.gmail.com>	 <47DFC0D5.8020104@suse.de> <3d8471ca0803181629h63530825k6087b2a838484dca@mail.gmail.com>
In-Reply-To: <3d8471ca0803181629h63530825k6087b2a838484dca@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guillaume,

There are two new patches in #9998.

Could you check if they help without reverting of patch 2c81ce4c9c3?

Thanks,
Alex.

Guillaume Chazarain wrote:
> Hi Alexey,
> 
> Thanks for your assistance. Here are the results of various tests:
> 
> === vanilla:
>            CPU0
>   0:      14637   IO-APIC-edge      timer
>   1:        213   IO-APIC-edge      i8042
>   3:          2   IO-APIC-edge
>   8:          1   IO-APIC-edge      rtc
>   9:        318   IO-APIC-fasteoi   acpi
>  12:       3534   IO-APIC-edge      i8042
>  14:      12481   IO-APIC-edge      ata_piix
>  15:          0   IO-APIC-edge      ata_piix
>  16:      14609   IO-APIC-fasteoi   uhci_hcd:usb5, firewire_ohci,
> radeon@pci:0000:01:00.0
>  17:       5681   IO-APIC-fasteoi   yenta, ipw2200, Intel ICH6
>  18:          0   IO-APIC-fasteoi   uhci_hcd:usb4, sdhc0:slot0, eth0
>  19:          0   IO-APIC-fasteoi   uhci_hcd:usb3
>  20:          0   IO-APIC-fasteoi   Intel ICH6 Modem
>  23:          4   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
> NMI:          0   Non-maskable interrupts
> LOC:      22742   Local timer interrupts
> TRM:          0   Thermal event interrupts
> SPU:          0   Spurious interrupts
> ERR:          0
> MIS:          0
> 
> ACPI keys don't work at all
> 
> === 2c81ce4c9c3 reverted:
> 
>            CPU0
>   0:      13379   IO-APIC-edge      timer
>   1:        205   IO-APIC-edge      i8042
>   3:          2   IO-APIC-edge
>   8:          1   IO-APIC-edge      rtc
>   9:       3599   IO-APIC-fasteoi   acpi
>  12:       3654   IO-APIC-edge      i8042
>  14:      13034   IO-APIC-edge      ata_piix
>  15:          0   IO-APIC-edge      ata_piix
>  16:      14073   IO-APIC-fasteoi   uhci_hcd:usb5, firewire_ohci,
> radeon@pci:0000:01:00.0
>  17:       7855   IO-APIC-fasteoi   yenta, ipw2200, Intel ICH6
>  18:          0   IO-APIC-fasteoi   uhci_hcd:usb4, eth0, sdhc0:slot0
>  19:          0   IO-APIC-fasteoi   uhci_hcd:usb3
>  20:          0   IO-APIC-fasteoi   Intel ICH6 Modem
>  23:          4   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
> NMI:          0   Non-maskable interrupts
> LOC:      22153   Local timer interrupts
> TRM:          0   Thermal event interrupts
> SPU:          0   Spurious interrupts
> ERR:          0
> MIS:          0
> 
> ACPI keys work fine.
> 
> === 2c81ce4c9c3 reverted + call_psw_on_capable_devices.patch
> 
>            CPU0
>   0:      12372   IO-APIC-edge      timer
>   1:        195   IO-APIC-edge      i8042
>   3:          2   IO-APIC-edge
>   8:          1   IO-APIC-edge      rtc
>   9:       7976   IO-APIC-fasteoi   acpi
>  12:       1824   IO-APIC-edge      i8042
>  14:      12168   IO-APIC-edge      ata_piix
>  15:          0   IO-APIC-edge      ata_piix
>  16:      11829   IO-APIC-fasteoi   uhci_hcd:usb5, firewire_ohci,
> radeon@pci:0000:01:00.0
>  17:       4803   IO-APIC-fasteoi   yenta, ipw2200, Intel ICH6
>  18:          0   IO-APIC-fasteoi   uhci_hcd:usb4, sdhc0:slot0, eth0
>  19:          0   IO-APIC-fasteoi   uhci_hcd:usb3
>  20:          0   IO-APIC-fasteoi   Intel ICH6 Modem
>  23:         58   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
> NMI:          0   Non-maskable interrupts
> LOC:      21962   Local timer interrupts
> TRM:          0   Thermal event interrupts
> SPU:          0   Spurious interrupts
> ERR:          0
> MIS:          0
> 
> ACPI keys work fine.
> 
> === dont_disable_ec_gpe_completely_at_storm.patch
> 
>            CPU0
>   0:      19657   IO-APIC-edge      timer
>   1:        434   IO-APIC-edge      i8042
>   3:          2   IO-APIC-edge
>   8:          1   IO-APIC-edge      rtc
>   9:       3310   IO-APIC-fasteoi   acpi
>  12:       7224   IO-APIC-edge      i8042
>  14:      13055   IO-APIC-edge      ata_piix
>  15:          0   IO-APIC-edge      ata_piix
>  16:      18637   IO-APIC-fasteoi   uhci_hcd:usb5, firewire_ohci,
> radeon@pci:0000:01:00.0
>  17:       7281   IO-APIC-fasteoi   yenta, ipw2200, Intel ICH6
>  18:          0   IO-APIC-fasteoi   uhci_hcd:usb4, eth0, sdhc0:slot0
>  19:          0   IO-APIC-fasteoi   uhci_hcd:usb3
>  20:          0   IO-APIC-fasteoi   Intel ICH6 Modem
>  23:          4   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
> NMI:          0   Non-maskable interrupts
> LOC:      26645   Local timer interrupts
> TRM:          0   Thermal event interrupts
> SPU:          0   Spurious interrupts
> ERR:          0
> MIS:          0
> 
> dmesg contains:
> ACPI: EC: GPE storm detected, throttle EC GPE
> ACPI: EC: missing write data confirmation, don't expect it any longer.
> 
> ACPI keys quite work but are very laggy (in the order of seconds).
> 
> 
> Conclusion: I never experienced acpi interrupts flood in any case, in
> vanilla the interrupt count is much lower but then there are no
> interrupts even when I press acpi keys.
> dont_disable_ec_gpe_completely_at_storm.patch does not correctly fix
> the problem for me. When 2c81ce4c9c3 is reverted,
> call_psw_on_capable_devices.patch makes no difference as it still
> works well.
> 
> Thanks.
> 

