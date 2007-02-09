Return-Path: <linux-kernel-owner+w=401wt.eu-S2992442AbXBIRID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992442AbXBIRID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:08:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992436AbXBIRIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:08:01 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:51317 "EHLO
	outbound4-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992442AbXBIRIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:08:00 -0500
X-BigFish: V
Message-ID: <45CCA568.6090607@am.sony.com>
Date: Fri, 09 Feb 2007 08:46:32 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Geoff Levand <geoffrey.levand@am.sony.com>
CC: Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] ps3 usb missed the addition of new argument to	ps3_alloc_io_irq()
References: <E1HFYFg-0004rz-19@ZenIV.linux.org.uk> <45CC9DDC.2060305@am.sony.com>
In-Reply-To: <45CC9DDC.2060305@am.sony.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2007 16:46:33.0105 (UTC) FILETIME=[DAE4C010:01C74C69]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geoff Levand wrote:
> Al Viro wrote:
>> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Greg had this same change queued for his usb tree.
> 
> Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>
> 

Update the PS3 irq allocation routines to take an argument indicating which
cpu (processor thread) the interrupt should be serviced on.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>

---
I fixed Al's patch to have the proper line lengths.

-Geoff

 drivers/usb/host/ehci-ps3.c |    3 ++-
 drivers/usb/host/ohci-ps3.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- ps3-linux-dev.orig/drivers/usb/host/ehci-ps3.c
+++ ps3-linux-dev/drivers/usb/host/ehci-ps3.c
@@ -104,7 +104,8 @@ static int ps3_ehci_sb_probe(struct ps3_
 	dev_dbg(&dev->core, "%s:%d: mmio mapped_addr %lxh\n", __func__,
 		__LINE__, dev->m_region->lpar_addr);
 
-	result = ps3_alloc_io_irq(dev->interrupt_id, &virq);
+	result = ps3_alloc_io_irq(PS3_BINDING_CPU_ANY, dev->interrupt_id,
+		&virq);
 
 	if (result) {
 		dev_dbg(&dev->core, "%s:%d: ps3_construct_io_irq(%d) failed.\n",
--- ps3-linux-dev.orig/drivers/usb/host/ohci-ps3.c
+++ ps3-linux-dev/drivers/usb/host/ohci-ps3.c
@@ -107,7 +107,8 @@ static int ps3_ohci_sb_probe(struct ps3_
 	dev_dbg(&dev->core, "%s:%d: mmio mapped_addr %lxh\n", __func__,
 		__LINE__, dev->m_region->lpar_addr);
 
-	result = ps3_alloc_io_irq(dev->interrupt_id, &virq);
+	result = ps3_alloc_io_irq(PS3_BINDING_CPU_ANY, dev->interrupt_id,
+		&virq);
 
 	if (result) {
 		dev_dbg(&dev->core, "%s:%d: ps3_construct_io_irq(%d) failed.\n",


