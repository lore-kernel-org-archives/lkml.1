Return-Path: <linux-kernel-owner+w=401wt.eu-S1760702AbYBSTA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702AbYBSTA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759096AbYBSTAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:00:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:34472 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759023AbYBSTAB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:00:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,377,1199692800"; 
   d="scan'208";a="521180270"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: ioatdma Self-test copy timeout
Date: Tue, 19 Feb 2008 10:59:09 -0800
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C040CB64C@orsmsx418.amr.corp.intel.com>
In-Reply-To: <47B8EBB2.7060807@elfove.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ioatdma Self-test copy timeout
Thread-Index: Achx1k5KgPdHHp+xRg6+iERjETg4TwBUaPrw
References: <47B8EBB2.7060807@elfove.cz>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Tomas Hlavacek" <brill@elfove.cz>, <linux-kernel@vger.kernel.org>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
X-OriginalArrivalTime: 19 Feb 2008 18:59:10.0107 (UTC) FILETIME=[828B26B0:01C87329]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Tomas Hlavacek [mailto:brill@elfove.cz] 
>Sent: Sunday, February 17, 2008 6:22 PM
>To: Nelson, Shannon; linux-kernel@vger.kernel.org
>Subject: ioatdma Self-test copy timeout
>
>Short description: In 2.6.25-rc2 ioatdma driver fails to 
>initialize due 
>to Self-test timeout when the ioatdma is linked into the kernel.
>
>
>Long descr: When I select to compile ioatdma into the kernel I get:
>
>ACPI: PCI Interrupt 0000:00:08.0[A] -> GSI 16 (level, low) -> IRQ 16
>PCI: Setting latency timer of device 0000:00:08.0 to 64
>ioatdma 0000:00:08.0: Intel(R) I/OAT DMA Engine found, 4 channels, 
>device version 0x12, driver version 2.04
>ioatdma: ioat_dma_test_callback(0000000000008086)
>ioatdma 0000:00:08.0: Self-test copy timed out, disabling
>ioatdma 0000:00:08.0: Intel(R) I/OAT DMA Engine initialization failed
>ACPI: PCI interrupt for device 0000:00:08.0 disabled
>
>As a kernel module ioatdma initializes just fine with the same 
>kernel on 
>the same HW without any other changes than selecting it to be 
>a module. 
>And it also succeeded to initialize when i tried to do this:
>
>--- a/drivers/dma/ioat_dma.c    2008-02-17 01:52:19.000000000 +0100
>+++ b/drivers/dma/ioat_dma.c    2008-02-18 02:47:27.000000000 +0100
>@@ -1089,7 +1089,7 @@
>                goto free_resources;
>        }
>        device->common.device_issue_pending(dma_chan);
>-       msleep(1);
>+       msleep(100);
> 
>        if (device->common.device_is_tx_complete(dma_chan, 
>cookie, NULL, 
>NULL)
>                                        != DMA_SUCCESS) {

Hmmm - interesting.  I'm not good enough with the kernel startup
sequence to know what it might be waiting for.  I don't see any problem
with a longer wait other than perhaps delaying the kernel startup.  We
left it a module and never really worked with it linked into the kernel,
primarily because its performance can be dependant on the work load, and
some folks will want the flexibility that a module gives.  We didn't let
it autoload at boot time for a similar reason.

If you want it to autoload at boot, you might want to add a modprobe
command to an init script.

sln
