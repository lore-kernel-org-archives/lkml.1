Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbYG3TZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbYG3TZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbYG3TYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:24:53 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:63939 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753895AbYG3TYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:24:51 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=xiyCTmfX01-w3diBQqEA:9 a=jAtUXHY-ZhGDEHzTHkl1ZIim6iUA:4
Message-ID: <4890C000.8010905@shaw.ca>
Date: Wed, 30 Jul 2008 13:24:48 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Sanka Piyaratna <cesanka@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PCIe device driver question
References: <fa.+kKL98uFtvbcX3ymh2HlJuUDVwY@ifi.uio.no>
In-Reply-To: <fa.+kKL98uFtvbcX3ymh2HlJuUDVwY@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sanka Piyaratna wrote:
> Hi,
> 
> I am currently developing a PCIe data capture card hardware and the
> device drivers to drive this. I have implemented DMA on the data
> capture and the scatter-gather DMA is implemented in the hardware.  I
> am testing this in an X86_64 architecture machine with 4 GB of RAM. I
> am able to successfully dma data into any memory (dma) address >
> 0x0000_0001_0000_0000. However, my problem is to dma data to any
> address less than this. When I try to DMA data to an address less than
> 0x0000_0001_0000_0000, the hardware device hangs indicating that the
> address does not exist.
> 
> I have implemented the DMA mask to be full 64 bit and my hardware is
> capable of transfering data to any address < 8TB. I am using kernel
> version 2.6.23.11. 
> 
> Could you please let me know what I might be doing wrong?

The kernel can't do anything to stop you from DMAing anywhere you want 
(barring the system having special IOMMU hardware). If you overwrite 
something you shouldn't have you'll cause a crash, but the kernel has no 
influence on it really.

Unless you're messing up the DMA addresses somehow and writing into a 
space that's not actually RAM (like the MMIO memory hole or something), 
my guess is it's likely a hardware problem..
