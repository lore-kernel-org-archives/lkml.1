Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbXKWDuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbXKWDuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 22:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbXKWDuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 22:50:04 -0500
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:25196 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752305AbXKWDuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 22:50:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=H1L1REb2kdKEqlBzLdnnHY4y2AmAAsWeSunu1RbCx4Sx6PLbMQVQA4AQJXq9bCy3WVhdYP7GDNZ45Nbi4S+gmcOoPgrCLkEF/Di7bZ8t0HMK2b9dLChYAnyvy0QpRMwtnCjDv4k6YE1Zu7LC8U5QoWqqRB/Eh/loPB8/GukVuEs=  ;
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Shannon Nelson <shannon.nelson@intel.com>,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] dmaengine: Driver for the AVR32 DMACA controller
Date: Thu, 22 Nov 2007 19:20:51 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <1195558597-23187-1-git-send-email-hskinnemoen@atmel.com>
In-Reply-To: <1195558597-23187-1-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200711221920.52137.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2007, Haavard Skinnemoen wrote:
> This patch depends on "DMA: Correct invalid assumptions in the Kconfig
> text" (without the part that adds AVR32 to the dependency list) and
> "DMAENGINE: Convert from class_device to device".

That regression fix still doesn't seem to be merged, or
even in the MM tree.

Here's a tweaked version of what Haavard sent.

- Dave

========	CUT HERE
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

This patch corrects recently changed (and now invalid) Kconfig
descriptions for the DMA engine framework:

 - Non-Intel(R) hardware also has DMA engines;
 - DMA is used for more than memcpy and RAID offloading.
 
In fact, on most platforms memcpy and RAID aren't factors, and DMA
exists so that peripherals can transfer data to/from memory while
the CPU does other work.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/dma/Kconfig |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- g26.orig/drivers/dma/Kconfig	2007-10-30 23:58:27.000000000 -0700
+++ g26/drivers/dma/Kconfig	2007-11-22 17:43:33.000000000 -0800
@@ -3,11 +3,13 @@
 #
 
 menuconfig DMADEVICES
-	bool "DMA Offload Engine support"
+	bool "DMA Engine support"
 	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
 	help
-	  Intel(R) offload engines enable offloading memory copies in the
-	  network stack and RAID operations in the MD driver.
+	  DMA engines can do asynchronous data transfers without
+	  involving the host CPU.  Currently, this framework can be
+	  used to offload memory copies in the network stack and
+	  RAID operations in the MD driver.
 
 if DMADEVICES
 

