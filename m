Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbZA3DUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbZA3DUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 22:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZA3DUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 22:20:37 -0500
Received: from omr6.networksolutionsemail.com ([205.178.146.56]:34076 "EHLO
	omr6.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508AbZA3DUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 22:20:36 -0500
Message-ID: <498271DF.6090406@nerdgrounds.com>
Date: Thu, 29 Jan 2009 19:19:59 -0800
From: Jonathan Campbell <jon@nerdgrounds.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Peter W. Morreale" <pmorreale@novell.com>, devel@driverdev.osuosl.org,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Vramfs: filesystem driver to utilize extra RAM on VGA devices
References: <497E4531.20800@nerdgrounds.com> <497E4919.60907@zytor.com>	 <497E4C5E.2030201@nerdgrounds.com> <1233248649.7191.130.camel@hermosa.site> <4981E7BD.3040507@nerdgrounds.com> <4981E99F.30001@zytor.com>
In-Reply-To: <4981E99F.30001@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't really see the similarity between the MTD subsystem and dividing 
vram up by files. Video cards don't have "erase blocks". And MTD is not 
a filesystem. And the onboard memory mtd driver (map system RAM) only 
handles one fixed region determined at load time.

Vramfs on the other hand determines what resources to use at mount time. 
It supports multiple mounts, one per PCI device, if you want the 
combined VRAM of two VGA cards in your system.

I don't think vramfs would fit well into the MTD subsystem.
> Jonathan Campbell wrote:
>   
>> Every VGA device connected to the PCI bus has resources that are known
>> to the Linux kernel. One of the memory resources is the video RAM
>> (always the largest prefetchable resource listed), with the base and
>> length known to the PCI subsystem. So, all vramfs needs on mount is the
>> PCI device, and the mountpoint, and it can dole it out to userspace.
>> Reading and writing is handled with ioremap(). mmap() is handled by
>> directly mmaping() that VRAM into user-space (just like /dev/fb0). Files
>> are recorded in system memory as a list of entities with a starting
>> block and length, so no fragmentation is possible.
>>
>> No communication with the GPU is needed to do this, it's possible to use
>> VRAM this way even on devices that nobody in the system knows how to
>> talk to.
>>     
>
> There still seems to be quite a bit of overlap between this and the MTD
> subsystem...
>
> 	-hpa
>
>   

