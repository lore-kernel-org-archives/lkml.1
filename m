Return-Path: <linux-kernel-owner+w=401wt.eu-S1760162AbYHDCrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162AbYHDCrX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 22:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbYHDCrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 22:47:13 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:55826 "EHLO
	pd2mo1so-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753946AbYHDCrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 22:47:12 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=ITZ0VUDMguGGVmYW-k8A:9 a=RHt2NjLRBuQOv2TB4zUA:7 a=PNI6pQIRIN0RfzR9_Kmzh33CVJcA:4 a=8_TzU-rOkHMA:10 a=haiq3Cp6CaIA:10
Message-ID: <48966DAE.2020203@shaw.ca>
Date: Sun, 03 Aug 2008 20:47:10 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Juergen Kreileder <jk@blackdown.de>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: SW-IOMMU / ata_piix errors with 2.6.27-rc1
References: <fa.64b92XSd5HpCdpOYcDENnJSZJyw@ifi.uio.no> <4896157A.2020907@shaw.ca> <4896500E.2040304@blackdown.de> <48966728.5080901@kernel.org>
In-Reply-To: <48966728.5080901@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Juergen Kreileder wrote:
>> Robert Hancock wrote:
>>> Juergen Kreileder wrote:
>>>> Hi,
>>>>
>>>> I get lots of errors like this with 2.6.27-rc1 on my
>>>> Macbook Pro (3rd generation), 2.6.26 seems to work fine:
>>>>
>>>> [  907.524509] DMA: Out of SW-IOMMU space for 45056 bytes at device 0000:00:1f.2
>>>> [  907.524783] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>>>> [  907.524796] ata3.00: cmd 35/00:50:08:91:5c/00:01:0f:00:00/e0 tag 0 dma 172032 out
>>>> [  907.524798]          res 50/00:00:ff:90:5c/00:00:0f:00:00/ef Emask 0x40 (internal error)
>>>> [  907.524805] ata3.00: status: { DRDY }
>>>> [  907.646590] ata3.00: configured for UDMA/133
>>>> [  907.646624] ata3: EH complete
>>>> Any suggestions?
>>> You can try increasing the swiotlb size by booting with swiotlb=65536 
>>> (for 128MB) or swiotlb=131072 (for 256MB), and see if that makes the 
>>> problem go away.. It's unclear why you'd be running out of SWIOTLB space 
>>> now, though, if 2.6.26 worked fine..
>> Still happening, although 256M make it a bit harder to trigger.
> 
> Hmm... sounds like mapping is leaking.  Eh... iommu leak debug seems to
> support only AMD GART IOMMU.  How long does it take to reproduce the
> bug?  Once it happens, it never recovers, right?  Does the problem
> happen with minimal configuration w/ only libata enabled (no network, no
> sound, no usb...)?

Yes, that would be a good test.. Easiest way might be booting with 
init=/bin/sh and running some processes that do lots of disk access..
