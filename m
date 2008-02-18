Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbYBRQts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbYBRQts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbYBRQtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:49:41 -0500
Received: from ik-out-1112.google.com ([66.249.90.180]:45117 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYBRQtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:49:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=BCsvEqyPbmrWKxpLtW3VtOO17wRUNA5gwfOpWL3v1TTCg+pdHMGabi/YGnq9HfaoX5sxaiJR8f+pypHOWNhF78ujoq1jLNwOlNVPQBtJvY3px4mwRGWhRttx3QnUMnGYKzBzQsWkc6kNtcx8CnQHw9AyjdWT2EqHYHEHYhdOxHg=
Message-ID: <47B9B720.9020000@gmail.com>
Date: Mon, 18 Feb 2008 17:49:36 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ke <kecore@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PCI DMA address
References: <63aa4aaa0802180705i76229711v8ed9fb2b1ea242df@mail.gmail.com>
In-Reply-To: <63aa4aaa0802180705i76229711v8ed9fb2b1ea242df@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2008 04:05 PM, Ke wrote:
> Hello all,
>       How can kernel get the PCI DMA address above 16MB or 64MB?

Documentation/DMA*

>       I hope that the all PCI devices can use a dma address above
> 0x1000000 at a higher memory.

Depends on how much is the device broken or what it can do.

IIRC you'll always get memory from DMA-zone for < ~0U dma_masks on kernels older 
than 2.6.(around 10). If you set dma_masks to < ~0U, you will probably (in the 
meaning, kernel will try to allocate from higher space and fall back to the 
dma-zone) get higher pages nowadays. However I don't know how far this applies 
also to systems with iommu in retrospective.
