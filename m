Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbZIPJro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbZIPJro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 05:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbZIPJrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 05:47:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46046
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568AbZIPJrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 05:47:42 -0400
Date: Wed, 16 Sep 2009 02:47:59 -0700 (PDT)
Message-Id: <20090916.024759.51103835.davem@davemloft.net>
To: dwalker@fifo99.com
Cc: jie.yang@atheros.com, miles.lane@gmail.com, chris.snook@gmail.com,
       jcliburn@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch net-next]atl1e:fix 2.6.31-git4 -- ATL1E 0000:03:00.0:
 DMA-API: device driver frees DMA
From: David Miller <davem@davemloft.net>
In-Reply-To: <1253092251.11643.569.camel@desktop>
References: <12530821133392-git-send-email-jie.yang@atheros.com>
	<1253092251.11643.569.camel@desktop>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walker <dwalker@fifo99.com>
Date: Wed, 16 Sep 2009 02:10:51 -0700

> On Wed, 2009-09-16 at 14:21 +0800, jie.yang@atheros.com wrote:
>> -           pci_unmap_page(pdev, tx_buffer->dma,
>> +           if (tx_buffer->flags & ATL1E_TX_PCIMAP_SINGLE)
>> +               pci_unmap_single(pdev, tx_buffer->dma,
>> +                   tx_buffer->length, PCI_DMA_TODEVICE);
>> +           else if (tx_buffer->flags & ATL1E_TX_PCIMAP_PAGE)
>> +               pci_unmap_page(pdev, tx_buffer->dma,
> 
> Could you run this through checkpatch, and fix any errors if find? It
> looks like you uses spaces for tabs in the code above, maybe in the
> other block too..
> 

It's because of his email client, it corrupted the whole patch
like that.
