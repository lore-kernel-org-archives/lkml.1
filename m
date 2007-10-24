Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbXJXPao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbXJXPao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757953AbXJXPac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:30:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:14896 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757842AbXJXPaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:30:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,325,1188802800"; 
   d="scan'208";a="304676278"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Remove bogus default y for DMAR and NET_DMA
Date: Wed, 24 Oct 2007 08:28:29 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C0349A7D2@orsmsx418.amr.corp.intel.com>
In-Reply-To: <471F0F44.4010102@garzik.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Remove bogus default y for DMAR and NET_DMA
Thread-Index: AcgWH67qrnBplUQQQBCFK9qmCZSCTQAMI70A
References: <200710241112.39451.ak@suse.de> <471F0F44.4010102@garzik.org>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Jeff Garzik" <jeff@garzik.org>, "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <akpm@osdl.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
X-OriginalArrivalTime: 24 Oct 2007 15:28:30.0146 (UTC) FILETIME=[87CBAA20:01C81652]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Jeff Garzik [mailto:jeff@garzik.org] 
>
>Andi Kleen wrote:
>> Index: linux-2.6.24-rc1-hack/arch/x86_64/Kconfig
>> ===================================================================
>> --- linux-2.6.24-rc1-hack.orig/arch/x86_64/Kconfig
>> +++ linux-2.6.24-rc1-hack/arch/x86_64/Kconfig
>> @@ -753,7 +753,6 @@ config PCI_DOMAINS
>>  config DMAR
>>  	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
>>  	depends on PCI_MSI && ACPI && EXPERIMENTAL
>> -	default y
>>  	help
>>  	  DMA remapping (DMAR) devices support enables 
>independent address
>>  	  translations for Direct Memory Access (DMA) from devices.
>
>ACK
>
>
>> Index: linux-2.6.24-rc1-hack/drivers/dma/Kconfig
>> ===================================================================
>> --- linux-2.6.24-rc1-hack.orig/drivers/dma/Kconfig
>> +++ linux-2.6.24-rc1-hack/drivers/dma/Kconfig
>> @@ -43,7 +43,6 @@ comment "DMA Clients"
>>  config NET_DMA
>>  	bool "Network: TCP receive copy offload"
>>  	depends on DMA_ENGINE && NET
>> -	default y
>>  	help
>>  	  This enables the use of DMA engines in the network stack to
>>  	  offload receive copy-to-user operations, freeing CPU cycles.
>
>ACK -- but its arguable that given the current code, its worth setting 
>this if DMA_ENGINE is also set.
>

The intent is to give us a DMA offload for NIC-to-user operations.  At
the moment the ioatdma device is the only gizmo supporting this through
NET_DMA, and is the only DMA_ENGINE supported on x86.  As more devices
are made available through DMA_ENGINE on platforms that don't have
ioatdma, removing the "default y" makes sense.  I agree that this is
ACK-able, but under the "it should just work" philosophy, and with the
Intel servers coming out with the hardware support, it may want to wait
until there are more DMA_ENGINE choices.

In any case, I'll ACK this and let the maintainers decide on the timing.

sln
