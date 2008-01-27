Return-Path: <linux-kernel-owner+w=401wt.eu-S1760103AbYA0WeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103AbYA0WeW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 17:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYA0WeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 17:34:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:8052 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbYA0WeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 17:34:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ImS5CjbvARWcpqNBzOpS7OmesviXvHVL9GKyeXZKI446yLIgSK6g/sSQ6/NO7X3aeJpxxxqKvOqFmoOxERCesoJ2U5z0iQC7DRCJe9mzzWiIxDlXQeDVfnB60rxJNI/L4rBRbQbHsQspouHCNMk70dNlmJ37jh2rsLjRtxIpbvQ=
Message-ID: <479D06E0.3090601@gmail.com>
Date: Sun, 27 Jan 2008 23:34:08 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Question about DMA
References: <38b2ab8a0801271251v1a9ea256w8fa4b9fcc620f742@mail.gmail.com>
In-Reply-To: <38b2ab8a0801271251v1a9ea256w8fa4b9fcc620f742@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2008 09:51 PM, Francis Moreau wrote:
> Hello,
> 
> I have 2 questions regarding set_dma_addr(unsigned int channel,
> unsigned int addr) helper.
> 
> 1/  Why does the function take only one address ? I would expect it
> to take both a source and a destination address for the dma controller
> to transfer data.

since your device is responsible for sending data from/to local memory. ISA dma 
controller has only 2 registers -- 16-bit address to put incoming data to (get 
outcoming from) + 8-bit nonincrementing page and 16-bit counter.

> 2/ The type of address parameter is an unsigned int. Why isn't it a dma_addr_t
> type ?

since isa dma controller can address up to 2^24 (16-bit address + 8-bit page) 
bytes of memory, i.e. 16M.

Are you sure, you want use this API?

