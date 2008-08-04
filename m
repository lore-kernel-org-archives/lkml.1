Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbYHDCUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbYHDCUV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 22:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbYHDCUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 22:20:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:58097 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbYHDCUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 22:20:06 -0400
Message-ID: <48966728.5080901@kernel.org>
Date: Mon, 04 Aug 2008 11:19:20 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Juergen Kreileder <jk@blackdown.de>
CC: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: SW-IOMMU / ata_piix errors with 2.6.27-rc1
References: <fa.64b92XSd5HpCdpOYcDENnJSZJyw@ifi.uio.no> <4896157A.2020907@shaw.ca> <4896500E.2040304@blackdown.de>
In-Reply-To: <4896500E.2040304@blackdown.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 04 Aug 2008 02:19:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Juergen Kreileder wrote:
> Robert Hancock wrote:
>> Juergen Kreileder wrote:
>>> Hi,
>>>
>>> I get lots of errors like this with 2.6.27-rc1 on my
>>> Macbook Pro (3rd generation), 2.6.26 seems to work fine:
>>>
>>> [  907.524509] DMA: Out of SW-IOMMU space for 45056 bytes at device 0000:00:1f.2
>>> [  907.524783] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>>> [  907.524796] ata3.00: cmd 35/00:50:08:91:5c/00:01:0f:00:00/e0 tag 0 dma 172032 out
>>> [  907.524798]          res 50/00:00:ff:90:5c/00:00:0f:00:00/ef Emask 0x40 (internal error)
>>> [  907.524805] ata3.00: status: { DRDY }
>>> [  907.646590] ata3.00: configured for UDMA/133
>>> [  907.646624] ata3: EH complete
> 
>>>
>>> Any suggestions?
>> You can try increasing the swiotlb size by booting with swiotlb=65536 
>> (for 128MB) or swiotlb=131072 (for 256MB), and see if that makes the 
>> problem go away.. It's unclear why you'd be running out of SWIOTLB space 
>> now, though, if 2.6.26 worked fine..
> 
> Still happening, although 256M make it a bit harder to trigger.

Hmm... sounds like mapping is leaking.  Eh... iommu leak debug seems to
support only AMD GART IOMMU.  How long does it take to reproduce the
bug?  Once it happens, it never recovers, right?  Does the problem
happen with minimal configuration w/ only libata enabled (no network, no
sound, no usb...)?

-- 
tejun
