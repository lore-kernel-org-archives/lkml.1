Return-Path: <linux-kernel-owner+w=401wt.eu-S1762675AbZLKVjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762675AbZLKVjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760950AbZLKVjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:39:42 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:42787 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758440AbZLKVjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:39:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=BERCFj8dhfG/LjCw3fM0neLzexy6ZRmFxf/zGQoh6q9vFilC8S9FvBb8T91OYCtgye
         gRR80Utn2QnJADP99iRhb/oDXGVocoBdMr6uTFvxo5vCKUJM5hNpHss3WG9asUL3RWkr
         /wf7ZS+bOcJmGfJodk0YuOhoVVCgqpTh06tQU=
Subject: Does pci_map_single magicly work on > 32 bit address for 32bit
 capable device?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Dec 2009 23:39:42 +0200
Message-ID: <1260567582.5983.23.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am writing a driver, and I am faced with following problem:

I receive a kernel pointer, and I want device to dma into that memory.
However, device is only capable of 32 bit dma.

I can create a 'consistent' mapping and use memcpy from/to it, but it
feels like waste of performance.


According to Documentation/DMA-mapping.txt, I can tell that hw supports
32 bit dma using pci_set_dma_mask, however, what will happen if I pass
arbitrary kernel address into pci_map_single.
What will happen if the address is above 32 bit?

I tried to follow source of pci_map_single, but it is quite strongly
buried.
Also note that I don't need any scatter gather lists, because buffer
will always be 512 bytes long.


Note that I don't write the block driver itself, but a small driver that
plugs into that driver.
I am writing a driver for mtd subsystem and more precisely a nand
driver.

Unfortunately mtd system can call the driver with arbitrary kernel
pointer, although I am sure its not vmalloc'ed.
Usually it passes the pointer that is received from block subsystem.



Thanks in advance,
Maxim Levitsky

