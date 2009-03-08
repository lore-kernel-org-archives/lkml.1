Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbZCHUVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbZCHUVK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 16:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbZCHUU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 16:20:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40392 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbZCHUUz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 16:20:55 -0400
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] A simple way to determine if the kernel needs HIGHMEM64G to be able to use all the installed memory
From: Andi Kleen <andi@firstfloor.org>
References: <49B254C6.8010507@pardus.org.tr>
	<20090307193026.GA2165@x200.localdomain>
	<49B2CE44.4060305@pardus.org.tr>
Date: Sun, 08 Mar 2009 21:20:49 +0100
In-Reply-To: <49B2CE44.4060305@pardus.org.tr> (Ozan =?utf-8?B?w4dhxJ9sYXlh?=
 =?utf-8?B?bidz?= message of "Sat, 07 Mar 2009 21:43:00 +0200")
Message-ID: <87r617ojfi.fsf@firstfloor.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ozan Çağlayan <ozan@pardus.org.tr> writes:
>
> So, the PAE enabled kernel should be installed by distribution installers or
> package management systems if the processor honors the PAE bit. Because PAE
> is an extension mechanism for 32bit processors, AFAIK it has some overhead.
> So enabling it if the user doesn't have a memory size >=4GB would not make
> much sense if a proper noexecute (NX) support is not intended.

The general recommendation is to always use PAE when the machine 
is NX capable. Or at least use it by default.

> Fedora installer parses /proc/iomem to see if any address listed is bigger than
> 0x100000000h. I checked it on a machine having 4GB of memory, and it failed.

Newer kernels have the memmap in /sys/firmware/memmap to export the memory
map. If anything is in there >4GB you need PAE.

But there's also the problem that a few systems have MMIO mappings above 4GB.
If you're lucky they are in the memmap too, but sometimes they are not.

For those you also always need PAE. The only way to check for that
would be to load all drivers and then check /proc/iomem or walk
the PCI resources (in /sys/bus/pci). That would be still not 100% fool
proof, but probably as good as you can get.

-Andi
