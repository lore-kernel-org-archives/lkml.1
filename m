Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbXKSCtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbXKSCtV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 21:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbXKSCtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 21:49:15 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:49858 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753304AbXKSCtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 21:49:14 -0500
Message-ID: <4740F9A6.1030802@lwfinger.net>
Date: Sun, 18 Nov 2007 20:49:10 -0600
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression in 2.6.24-rc3 - 64-bit DMA fails for BCM94311MCG rev
 02
References: <4740D323.3090107@lwfinger.net> <20071118161727.106e7eea@laptopd505.fenrus.org>
In-Reply-To: <20071118161727.106e7eea@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sun, 18 Nov 2007 18:04:51 -0600
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
>> I get a failure of 64-bit DMA on a BCM94311MCG rev 02 wireless
>> interface running on x86_64 using an AMD Turion 64 X2 processor on an
>> HP Pavilion dv2125nr laptop. The error code indicates that the
>> interface is getting a descriptor read error, even though the
>> descriptor ring and all the DMA buffers have been checked when
>> allocated. This particular card version is newly supported; however,
>> it was working correctly on 2.6.24-rc2.
>>
> 
> 
> worth adding a pci_set_dma_mask(pdev, DMA_32BIT_MASK); in the driver,
> just after pci_enable_device(); (also check if there's other
> pci_set_dma_mask functions, to make sure it doesn't get set back to 64
> bit)

The hardware for this driver comes in 30-, 32-, and 64-bit flavors. After determining which flavor
we have, the driver sends that information to the ssb driver, which actually handles the PCI
enabling. For the device that fails, I'm passing DMA_BIT_MASK(64) to the appropriate routine in ssb,
which calls dma_supported() with that mask. There are no other calls to any of the dma or pci mask
routines. I changed the dma_supported() to a set_dma_mask(), but it didn't make any difference. My
32-bit device works OK - just the 64-bit one fails.

Larry


