Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbYLEJIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbYLEJIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 04:08:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbYLEJH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 04:07:57 -0500
Received: from main.gmane.org ([80.91.229.2]:37416 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbYLEJHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 04:07:55 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jari Aalto <jari.aalto@cante.net>
Subject: Re: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory (SOLVED)
Date: Fri, 05 Dec 2008 11:07:40 +0200
Message-ID: <87wsht6e9e.fsf_-_@jondo.cante.net>
References: <48B843CC.1050805@yahoo.com.ar> <87wshza4oo.fsf@jondo.cante.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
Cc: <vmlinuz386@yahoo.com.ar>
X-Gmane-NNTP-Posting-Host: a91-155-187-216.elisa-laajakaista.fi
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.2 (gnu/linux)
Cancel-Lock: sha1:65bqbhLKibJQLYuadunp6LR9JbA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jari Aalto <jari.aalto@cante.net> writes:

> Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar> writes:
>>>
>>>    REF: http://article.gmane.org/gmane.linux.kernel/725293 (thread >start)
>>
>> You have mixed options for "swiotlb" and "amd gart", see the
>> Documentation/x86_64/boot-options.txt
>
> I'll try at next boot with plain:
>
>     iommu=memaper=3

[This is a summary post in case aonyone else needs the information]

It appears that with AMD BE-2400 and ASUS MB[1] plus Debian kernel
2.6.26, the following boot options solve "out of SW-IOMMU" issue:

   iommu=noagp,memaper=3

If the 'iommu' option is left out to kernel to figure out GART defaults,
then the system freezed in short period of time.

Thank you for all the participants, especially to Gerardo,
Jari

[1]
 CPU
        $ cat /proc/cpuinfo
        model name      : AMD Athlon(tm) X2 Dual Core Processor BE-2400
        stepping        : 2
        cpu MHz         : 2310.518
        cache size      : 512 KB
 MB

        Asus M2N32-SLI Deluxe/Wireless Edition
        - nvidia nForce 590 SLI chipset MCP
        - 2 x PCIe (SLI x16), 1 x PCI (x4), 1 x PCI (x1), 2 x PCI 2.2
        - Socket AM2

        http://www.asus.com/products.aspx?l1=3&l2=101&l3=300&model=1163&modelmenu=1

Debian Compiled Kernel

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

