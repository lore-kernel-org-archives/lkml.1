Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbZA2Rat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbZA2Rat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbZA2Rak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:30:40 -0500
Received: from omr6.networksolutionsemail.com ([205.178.146.56]:42222 "EHLO
	omr6.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358AbZA2Rak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:30:40 -0500
Message-ID: <4981E7BD.3040507@nerdgrounds.com>
Date: Thu, 29 Jan 2009 09:30:37 -0800
From: Jonathan Campbell <jon@nerdgrounds.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: "Peter W. Morreale" <pmorreale@novell.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, devel@driverdev.osuosl.org,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Vramfs: filesystem driver to utilize extra RAM on VGA devices
References: <497E4531.20800@nerdgrounds.com> <497E4919.60907@zytor.com>	 <497E4C5E.2030201@nerdgrounds.com> <1233248649.7191.130.camel@hermosa.site>
In-Reply-To: <1233248649.7191.130.camel@hermosa.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every VGA device connected to the PCI bus has resources that are known 
to the Linux kernel. One of the memory resources is the video RAM 
(always the largest prefetchable resource listed), with the base and 
length known to the PCI subsystem. So, all vramfs needs on mount is the 
PCI device, and the mountpoint, and it can dole it out to userspace. 
Reading and writing is handled with ioremap(). mmap() is handled by 
directly mmaping() that VRAM into user-space (just like /dev/fb0). Files 
are recorded in system memory as a list of entities with a starting 
block and length, so no fragmentation is possible.

No communication with the GPU is needed to do this, it's possible to use 
VRAM this way even on devices that nobody in the system knows how to 
talk to.
> How do you accomplish that? 
>
> (I haven't yet looked at your code...)
>
> -PWM
>
>   

