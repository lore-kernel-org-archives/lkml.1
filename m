Return-Path: <linux-kernel-owner+w=401wt.eu-S1761776AbYA2BLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761776AbYA2BLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 20:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbYA2BLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 20:11:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:4955 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbYA2BLq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 20:11:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,264,1199692800"; 
   d="scan'208";a="331212751"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Force enable HPET on (some?) ICH9 boards
Date: Mon, 28 Jan 2008 17:12:33 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE6CD87A@orsmsx423.amr.corp.intel.com>
In-Reply-To: <1201444379-4223-1-git-send-email-alistair@devzero.co.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Force enable HPET on (some?) ICH9 boards
Thread-Index: Achg8YapU3CXJE6qS42rvJBDjsSgSgBITDqA
References: <1201444379-4223-1-git-send-email-alistair@devzero.co.uk>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Alistair John Strachan" <alistair@devzero.co.uk>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 29 Jan 2008 01:11:26.0597 (UTC) FILETIME=[DF0A8B50:01C86213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Patch looks good.
If BIOS does not report HPET on more of such systems we may have to add
other chipsets in ICH9 family (ICH9_8, ...) as well.

Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com> 


>-----Original Message-----
>From: Alistair John Strachan [mailto:alistair@devzero.co.uk] 
>Sent: Sunday, January 27, 2008 6:33 AM
>To: Pallipadi, Venkatesh
>Cc: Ingo Molnar; Linux Kernel Mailing List; Alistair John Strachan
>Subject: [PATCH] Force enable HPET on (some?) ICH9 boards
>
>Some consumer ICH9 boards (such as the Abit IP35 Pro) do not 
>provide a BIOS
>option for enabling the HPET. The same ICH workaround used for 
>6,7,8 can be
>applied to 9. Here I enable the only PCI id that was visible 
>on my system.
>
>I have confirmed the HPETs work both from userspace and as a 
>clocksource for
>the running kernel (2.6.24 here) after applying this patch.
>
>Force enabled HPET at base address 0xfed00000
>hpet clockevent registered
>hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
>hpet0: 4 64-bit timers, 14318180 Hz
>
>Signed-off-by: Alistair John Strachan <alistair@devzero.co.uk>
>
>---
> arch/x86/kernel/quirks.c |    2 ++
> 1 files changed, 2 insertions(+), 0 deletions(-)
>
>diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
>index fab30e1..150ba29 100644
>--- a/arch/x86/kernel/quirks.c
>+++ b/arch/x86/kernel/quirks.c
>@@ -162,6 +162,8 @@ 
>DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 
>PCI_DEVICE_ID_INTEL_ICH7_31,
> 			 ich_force_enable_hpet);
> DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 
>PCI_DEVICE_ID_INTEL_ICH8_1,
> 			 ich_force_enable_hpet);
>+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 
>PCI_DEVICE_ID_INTEL_ICH9_7,
>+			 ich_force_enable_hpet);
> 
> 
> static struct pci_dev *cached_dev;
>
>-- 
>Cheers,
>Alistair.
>
>137/1 Warrender Park Road, Edinburgh, UK.
>
