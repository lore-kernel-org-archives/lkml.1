Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZIPG5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZIPG5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 02:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757269AbZIPG5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 02:57:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57231
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754940AbZIPG5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 02:57:04 -0400
Date: Tue, 15 Sep 2009 23:57:21 -0700 (PDT)
Message-Id: <20090915.235721.252164710.davem@davemloft.net>
To: jie.yang@atheros.com
Cc: miles.lane@gmail.com, chris.snook@gmail.com, jcliburn@gmail.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch net-next]atl1e:fix 2.6.31-git4 -- ATL1E 0000:03:00.0:
 DMA-API: device driver frees DMA
From: David Miller <davem@davemloft.net>
In-Reply-To: <12530821133392-git-send-email-jie.yang@atheros.com>
References: <12530821133392-git-send-email-jie.yang@atheros.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <jie.yang@atheros.com>
Date: Wed, 16 Sep 2009 14:21:53 +0800

> 
> [   25.059969] WARNING: at lib/dma-debug.c:816 check_unmap+0x383/0x55c()
> [   25.059976] Hardware name: 1000HE
> [   25.059984] ATL1E 0000:03:00.0: DMA-API: device driver frees DMA
>     memory with wrong function [device address=0x0000000036b92802] 
>     [size=90 bytes] [mapped as single] [unmapped as page]
> 
> use the wrong API when free dma. So when map dma use a flag to demostrate
> whether it is 'pci_map_single' or 'pci_map_page'. When free the dma, check
> the flags to select the right APIs('pci_unmap_single' or 'pci_unmap_page').
>  
> Signed-off-by: Jie Yang <jie.yang@atheros.com>

An 'unsigned long' is an enormous type to use just to store
3 bits of information.  Use a u16 or similar to compact the
size of struct atl1e_tx_buffer

Also, it looks terribly ugle to define the flag macros, some with
three leading zeros in the hexadecimal values and one without.

Please make them consistent, thanks.

Generally, I see that this change was put together very hastily
and without very much care.
