Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbYH1Ut1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbYH1Ut1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbYH1UtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:49:19 -0400
Received: from main.gmane.org ([80.91.229.2]:34911 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755800AbYH1UtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:49:18 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jari Aalto <jari.aalto@cante.net>
Subject: Re: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory
Date: Thu, 28 Aug 2008 23:49:00 +0300
Message-ID: <87bpzcj26b.fsf_-_@jondo.cante.net>
References: <fa.c8YPWdZHXAabbZwTVLAgq9ahOlE@ifi.uio.no>
	<fa.9B7J3O7801PlFtm4WwuBX/J0kU8@ifi.uio.no>
	<fa.ES0QYHe349FfrOTaqTun1n3qaYk@ifi.uio.no>
	<fa.8FK+C3lDiXBnZCV9FTofTkm6PJE@ifi.uio.no>
	<fa.cN6j0N4TRlTlG7oLEhhT8Wj2N7A@ifi.uio.no>
	<fa.XwRqZTkk0olSp3UUnbSFZahR4TI@ifi.uio.no> <48B1D82C.5000107@shaw.ca>
	<87d4jyys7y.fsf@jondo.cante.net>
        <m3hc9akkt9.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: a91-155-179-127.elisa-laajakaista.fi
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.2 (gnu/linux)
Cancel-Lock: sha1:RFvvjDDUEe32k7tAxmVI1HTtuHI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa <khc@pm.waw.pl> writes:

> Jari Aalto <jari.aalto@cante.net> writes:
>
>> What, if after booting to 2.6.26 and without any 'iommu' boot parameters,
>> there still appears "Out of Iommu space" messages? What kind of logs
>> should I post?
>
> You shouldn't be getting "Out of SW-IOMMU space" messages when not
> using SW-IOMMU.

REF: http://article.gmane.org/gmane.linux.kernel/725293 (thread start)

I regret to report that:

- Upgraded to kernel 2.6.26-1-amd64 (Debian/unstable 2.6.26-3)

$ grep -Ei 'iommu|agp' /boot/config-2.6.26-1-amd64
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_IOMMU_HELPER=y
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=m
CONFIG_AGP_SIS=m
CONFIG_AGP_VIA=m
# CONFIG_IOMMU_DEBUG is not set

- Rebooted without 'iommu' parameter. dmesg:

[    0.000000] Kernel command line: root=UUID=cb9d814f-d885-435b-8e6d-ac17c0ac5aa1 ro quiet vga=0x317 swiotlb=32768
[    0.004000] Checking aperture...
[    0.004000] Node 0: aperture @ 4000000 size 32 MB
[    0.004000] Aperture pointing to e820 RAM. Ignoring.
[    0.004000] No AGP bridge found
[    0.004000] Your BIOS doesn't leave a aperture memory hole
[    0.004000] Please enable the IOMMU option in the BIOS setup
[    0.004000] This costs you 64 MB of RAM
[    0.004000] Mapping aperture over 65536 KB of RAM @ 4000000
...
[    0.374935] PCI-DMA: Disabling AGP.
[    0.374935] PCI-DMA: aperture base @ 4000000 size 65536 KB
[    0.374935] PCI-DMA: using GART IOMMU.
[    0.374935] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture


- The syslog after boot reads:

Aug 28 20:18:28 jondo kernel: [972060.192696] DMA: Out of SW-IOMMU space for 24576 bytes at device 0000:00:0d.0
Aug 28 20:18:28 jondo kernel: [972060.192760] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Aug 28 20:18:28 jondo kernel: [972060.196705] ata3.00: cmd ca/00:60:c1:91:5f/00:00:00:00:00/e8 tag 0 dma 49152 out
Aug 28 20:18:28 jondo kernel: [972060.196707]          res 50/00:00:bf:cf:b5/00:00:71:00:00/ea Emask 0x40 (internal error)
Aug 28 20:18:28 jondo kernel: [972060.200700] ata3.00: status: { DRDY }
Aug 28 20:18:28 jondo kernel: [972060.231128] ata3.00: configured for UDMA/133
Aug 28 20:18:28 jondo kernel: [972060.231137] ata3: EH complete
Aug 28 20:18:28 jondo kernel: [972060.231148] DMA: Out of SW-IOMMU space for 24576 bytes at device 0000:00:0d.0
Aug 28 20:18:28 jondo kernel: [972060.233247] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Aug 28 20:18:28 jondo kernel: [972060.237246] ata3.00: cmd
ca/00:60:c1:91:5f/00:00:00:00:00/e8 tag 0 dma 49152 out

>> I'm a bit nervous due to past experience of complete hardd disk
>> corruption. But if that was problem with the old kernel and more later
>> versions are safer in this repect, I could once more.
>
> I'm not sure if the newer versions are safer. It may be a hardware/BIOS
> problem and it may happen again. Make sure you have a usable backup
> first.

If there is anything I can do, please let me know. This must be a kernel
issue somewhere.

My BE-2400 processor still continues to freeze after few days.

Jari

