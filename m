Return-Path: <linux-kernel-owner+w=401wt.eu-S1750766AbXBRRN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750766AbXBRRN6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 12:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbXBRRN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 12:13:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:42886 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbXBRRN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 12:13:57 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: e2b2rom_init_one():  Unable to register resource
Date: Sun, 18 Feb 2007 18:13:38 +0100
User-Agent: KMail/1.9.5
Cc: Dan Aloni <da-x@monatomic.org>,
       linux-kernel-list <linux-kernel@vger.kernel.org>, dwmw2@infradead.org
References: <20070217212918.GA26554@localdomain> <20070218104222.GC10865@cvg>
In-Reply-To: <20070218104222.GC10865@cvg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702181813.38814.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[adding mtd maintainer]

On Sunday 18 February 2007 11:42, Cyrill Gorcunov wrote:
> On Sat, Feb 17, 2007 at 11:29:19PM +0200, Dan Aloni wrote:
> | Hello,
> | 
> | I'm running the x86_64 arch of Linux 2.6.20 on a Supermicro X6DH8-XG2 
> | board and I got this during boot:
> | 
> | [248660.950695] device id = 2440
> | [248660.950699] device id = 2480
> | [248660.950703] device id = 24c0
> | [248660.950706] device id = 24d0
> | [248660.950709] matched device = 24d0
> | [248660.950712] matched device id 24d0
> | [248660.950716] pci_read_config_byte : 4
> | [248660.950723] esb2rom: esb2rom_init_one(): Unable to register resource 
> | 0xffffffffffc00000-0xffffffff - kernel bug?
> | [248660.950729] esb2rom: ioremap(ffffffffffc00000, 100400000) failed
> | [248660.956859] retVal = -19
> | 
> | Looks like some kind of a 64-bit portability bug...
> | 
> | -- 
> | Dan Aloni
> | XIV LTD, http://www.xivstorage.com
> | da-x (at) monatomic.org, dan (at) xiv.co.il
> | -
> | To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> | the body of a message to majordomo@vger.kernel.org
> | More majordomo info at  http://vger.kernel.org/majordomo-info.html
> | Please read the FAQ at  http://www.tux.org/lkml/
> | 
> 
> Hi,
> 
> here is a patch attached to the mail. You may test it. Actually
> I have no 64bit machine to test it and I'm worried about the
> patch accuracy. So be carefull testing it. I sent a copy of the
> message to Andi Kleen (who is a maintainer of X86-64 port) may be
> we should wait for its answer ;)

Making window->phys u32 seems like a cleaner fix.
(untested) 

-Andi

Fix 64bit arithmetic bug in esb2rom.c 

Index: linux/drivers/mtd/maps/esb2rom.c
===================================================================
--- linux.orig/drivers/mtd/maps/esb2rom.c
+++ linux/drivers/mtd/maps/esb2rom.c
@@ -95,8 +95,8 @@
 
 struct esb2rom_window {
 	void __iomem* virt;
-	unsigned long phys;
-	unsigned long size;
+	u32 phys;
+	u32 size;
 	struct list_head maps;
 	struct resource rsrc;
 	struct pci_dev *pdev;


