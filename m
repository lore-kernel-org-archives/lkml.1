Return-Path: <linux-kernel-owner+w=401wt.eu-S1761202AbZLLAG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761202AbZLLAG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758394AbZLLAG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:06:58 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:47517 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746AbZLLAG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:06:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BjQoMIhu90gxDztxSip7cUH1O0Q3k6Qi71PrVFJ4RS4Bvs7jyGeidQPLmxM/inBX7O
         mtuBAyisWRv3yoRCyM3DPZWjbV8RBz+dLg6RxG2soasGgpm9/k2E+C76TVn+q/jjafkp
         GHBADuGr6th2tzDQBwQfJaxziLU5UIEkFhobw=
Message-ID: <4B22DEA7.8040202@gmail.com>
Date: Fri, 11 Dec 2009 18:07:03 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Does pci_map_single magicly work on > 32 bit address for 32bit
   capable device?
References: <1260567582.5983.23.camel@maxim-laptop>
In-Reply-To: <1260567582.5983.23.camel@maxim-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2009 03:39 PM, Maxim Levitsky wrote:
> Hi,
>
> I am writing a driver, and I am faced with following problem:
>
> I receive a kernel pointer, and I want device to dma into that memory.
> However, device is only capable of 32 bit dma.
>
> I can create a 'consistent' mapping and use memcpy from/to it, but it
> feels like waste of performance.
>
>
> According to Documentation/DMA-mapping.txt, I can tell that hw supports
> 32 bit dma using pci_set_dma_mask, however, what will happen if I pass
> arbitrary kernel address into pci_map_single.
> What will happen if the address is above 32 bit?

The kernel should set up an IOMMU (either hardware or software) mapping 
for that memory so that the device can access it through an address 
below 4GB. This is assuming it's a 64-bit kernel (on 32-bit, a kernel 
memory address will always be below 4GB).
