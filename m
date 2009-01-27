Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbZA0VQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbZA0VQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZA0VPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:15:54 -0500
Received: from omr7.networksolutionsemail.com ([205.178.146.57]:51392 "EHLO
	omr7.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753124AbZA0VPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:15:53 -0500
Message-ID: <497F7981.4010400@nerdgrounds.com>
Date: Tue, 27 Jan 2009 13:15:45 -0800
From: Jonathan Campbell <jon@nerdgrounds.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Mark Knecht <markknecht@gmail.com>
CC: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Vramfs: filesystem driver to utilize extra RAM on VGA devices
References: <497E4531.20800@nerdgrounds.com>	 <5bdc1c8b0901261859g58a413e1x52208a6f2c1f9ccd@mail.gmail.com>	 <497E968F.3020708@nerdgrounds.com>	 <5bdc1c8b0901271018k7603e413o92de334e8d28d1d7@mail.gmail.com>	 <497F60A3.6020608@nerdgrounds.com> <5bdc1c8b0901271249n467a8835n645da642bccd170a@mail.gmail.com>
In-Reply-To: <5bdc1c8b0901271249n467a8835n645da642bccd170a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> If I was to build this and try it our (not saying I have time right
> now though) then as root how do I determine what size file system I
> can build? Do I run fdisk against /dev/fb0 and look at what portion is
> unallocated?
>
>   
The capacity is automatically set to the amount of VRAM out there, based 
on what the PCI subsystem says the resource length is. So if you mount 
your ATI Radeon's VRAM and it has 512MB on it, you'll get a filesystem 
with a capacity of 512MB.

Fdisk is not necessary, the filesystem structures are maintained in 
system memory not VRAM. Like tmpfs/shmemfs the filesystem structures are 
discarded on unmount, though the contents are not cleared from VRAM.

Adding a mount parameter to override the PCI system reported length 
wouldn't be hard either.


