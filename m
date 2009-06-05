Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbZFEDNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbZFEDNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 23:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZFEDN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 23:13:26 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:2293 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbZFEDNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 23:13:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FHY2ecMSeAJrYFJz0gLrigqF2uIzhOVIll2+4EbRsCO7wIdhymBep8kABDp8xUa/RV
         e6XiRXL06J/KQvla/5I7AMJUQUZVZHYCtr2ew/3DENcRbcCMlNNZ/kxI1oPzwtTef+D6
         CjDG7Ch8gEjz+YX0dkUb2GOgVBi91LlO4ywXc=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0906041949030.7953@asgard>
References: <alpine.DEB.1.10.0906041949030.7953@asgard>
Date: Thu, 4 Jun 2009 20:13:26 -0700
Message-ID: <86802c440906042013i492ca887h4dda99a166082f45@mail.gmail.com>
Subject: Re: only a single core (out of 8) initialized
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: david@lang.hm
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 4, 2009 at 7:52 PM,  <david@lang.hm> wrote:
> this is 2.6.30-rc7 with a patch added to debug a nv sata driver
> incompatibility with the Intel SSDs on a tyan motherboard
>
> on one system it sees all 8 cores, on the other system it only initializes
> one core.
>
> can anyone help me spot what's going wrong in the one that's only seeing a
> single core? If I'm reading things correctly it's seeing both sockets for
> the NUMA setup, but then only initializing one core on the first socket.

the works
ACPI: RSDP 00000000000fa8d0 00024 (v02 ACPIAM)
ACPI: XSDT 00000000d7fd0100 0005C (v01 112707 XSDT1716 20071127 MSFT 00000097)
ACPI: FACP 00000000d7fd0290 000F4 (v03 112707 FACP1716 20071127 MSFT 00000097)
ACPI: DSDT 00000000d7fd0470 04D61 (v01  0AAAA 0AAAA000 00000000 INTL 20051117)
ACPI: FACS 00000000d7fde000 00040
ACPI: APIC 00000000d7fd0390 000A0 (v01 112707 APIC1716 20071127 MSFT 00000097)
ACPI: MCFG 00000000d7fd0430 0003C (v01 112707 OEMMCFG  20071127 MSFT 00000097)
ACPI: OEMB 00000000d7fde040 00091 (v01 112707 OEMB1716 20071127 MSFT 00000097)
ACPI: SRAT 00000000d7fd51e0 00110 (v01 AMD    HAMMER   00000001 AMD  00000001)
ACPI: HPET 00000000d7fd52f0 00038 (v01 112707 OEMHPET0 20071127 MSFT 00000097)
ACPI: SSDT 00000000d7fd5330 002E0 (v01 A M I  POWERNOW 00000001 AMD  00000001)
ACPI: Local APIC address 0xfee00000

it is using MADT aka APIC

other one

ACPI: RSDP 00000000000f9af0 00024 (v02 ACPIAM)
ACPI: XSDT 00000000d7ff0100 0003C (v01 100108 XSDT0856 20081001 MSFT 00000097)
ACPI: FACP 00000000d7ff0290 000F4 (v03 100108 FACP0856 20081001 MSFT 00000097)
ACPI: DSDT 00000000d7ff0470 04D4E (v01  0AAAA 0AAAA000 00000000 INTL 20051117)
ACPI: FACS 00000000d7ffe000 00040
ACPI: MCFG 00000000d7ff0430 0003C (v01 100108 OEMMCFG  20081001 MSFT 00000097)
ACPI: HPET 00000000d7ff51c0 00038 (v01 100108 OEMHPET0 20081001 MSFT 00000097)
Scanning NUMA topology in Northbridge 24
it is using MPTABLE

looks that you update that BIOS the one.
please check if you loaded optimal setting in BIOS setup. and check
MADT and ACPI v3.0 option in BIOS

YH
