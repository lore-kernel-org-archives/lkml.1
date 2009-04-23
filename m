Return-Path: <linux-kernel-owner+w=401wt.eu-S1753628AbZDWCNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbZDWCNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 22:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZDWCNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 22:13:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:55626 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbZDWCNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 22:13:22 -0400
Message-ID: <49EFCE15.3030605@kernel.org>
Date: Wed, 22 Apr 2009 19:10:29 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [RFC PATCH 1/2] pci: don't assume pref memio are 64bit -v3
References: <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain>	<49E99054.6050208@kernel.org>	<alpine.LFD.2.00.0904181142530.4042@localhost.localdomain>	<49EA57C4.1000603@kernel.org>	<alpine.LFD.2.00.0904181602030.2199@localhost.localdomain>	<alpine.LFD.2.00.0904182149240.2199@localhost.localdomain>	<20090419090208.GA30211@elte.hu>	<20090419090615.GA30631@elte.hu>	<20090420223305.GA15340@jurassic.park.msu.ru>	<49ED0EBC.4070901@kernel.org>	<20090421105629.GB17904@jurassic.park.msu.ru>	<49EF9C10.6090107@kernel.org>	<20090422154900.08f8f366@hobbes>	<49EFBB0E.3030401@kernel.org> <20090422180505.2518e837@hobbes>
In-Reply-To: <20090422180505.2518e837@hobbes>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Wed, 22 Apr 2009 17:49:18 -0700
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Jesse Barnes wrote:
>>> On Wed, 22 Apr 2009 15:37:04 -0700
>>> Yinghai Lu <yinghai@kernel.org> wrote:
>>>
>>>> one system with 4g installed ( there is 1g hole)
>>>>
>>>> when 4G installed.
>>>> BIOS put ACPI etc need the hole
>>>> [    0.000000] BIOS-provided physical RAM map:
>>>> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009bc00
>>>> (usable) [    0.000000]  BIOS-e820: 000000000009bc00 -
>>>> 00000000000a0000 (reserved) [    0.000000]  BIOS-e820:
>>>> 00000000000e3000 - 0000000000100000 (reserved) [    0.000000]
>>>> BIOS-e820: 0000000000100000 - 00000000bffa0000 (usable)
>>>> [    0.000000]  BIOS-e820: 00000000bffa0000 - 00000000bffae000
>>>> (ACPI data) [    0.000000]  BIOS-e820: 00000000bffae000 -
>>>> 00000000bfff0000 (ACPI NVS) [    0.000000]  BIOS-e820:
>>>> 00000000bfff0000 - 00000000c0000000 (reserved) [    0.000000]
>>>> BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>>>> [    0.000000] BIOS-e820: 00000000ffb00000 - 0000000100000000
>>>> (reserved) [    0.000000]  BIOS-e820: 0000000100000000 -
>>>> 0000000140000000 (usable) so in kernel resource will be reserved
>>>> for 0xbffa0000 - 0xbfff0000 for ACPI 0x100000 -  0xbffa0000 for
>>>> RAM...
>>>>
>>>> and BIOS set
>>>> [    0.240007] pci 0000:00:01.0: bridge 64bit mmio pref:
>>>> [0xbdf00000-0xddefffff] [    0.237102] pci 0000:01:00.0: reg 10
>>>> 32bit mmio: [0xc0000000-0xcfffffff] that is conflict with reserved
>>>> res. so it can not be reserved Kernel.
>>>>
>>>> then Kernel try to get range from 0x140000000 ( above the RAM, 5G
>>>> and above 4g) and set let the bridge to use it, and ATI cards to
>>>> use it.
>>>>
>>>> but the problem is that ATI only support 32bit ...
>>> So Ivan's patch didn't work for you for this problem?  I was
>>> planning on applying it, but it would be nice to get some test
>>> results first.
>> looks like Ivan patch still has some problem. 
> 
> Can you be more specific? :)  I'd like to get this resolved properly as
> well, and I think the principles Ivan outlined are the right ones to
> follow...

also on AMD system with two ht chain, or other system with pci=use_crs to get correct root default res,
will get anonying

PCI: allocations above 4G disabled

even the system does support that.

also will have problem with some calling like request_resource(&iomem_resource, ....)

YH
