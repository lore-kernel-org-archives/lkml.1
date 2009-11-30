Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbZK3XdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbZK3XdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 18:33:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZK3XdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 18:33:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:45768 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbZK3XdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 18:33:01 -0500
Message-ID: <4B1455FD.90002@kernel.org>
Date: Mon, 30 Nov 2009 15:32:13 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@hp.com>
CC: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Always set prefetchable base/limit upper32 registers
References: <20091130212228.7555.43533.stgit@debian.lart>	 <4B143AE5.7040702@kernel.org> <1259617381.8949.281.camel@8530w.home>	 <4B143E83.6020105@kernel.org> <1259618496.8949.290.camel@8530w.home>	 <4B144346.50608@kernel.org> <1259619578.8949.295.camel@8530w.home>
In-Reply-To: <1259619578.8949.295.camel@8530w.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Williamson wrote:
> On Mon, 2009-11-30 at 14:12 -0800, Yinghai Lu wrote:
>> Alex Williamson wrote: 
>>> I don't believe the PCI spec dictates whether the upper 32bit base
>>> should be 0 or -1, so it's purely a BIOS initialization choice and Linux
>>> should properly handle both.  If the hardware only supports 32bit
>>> prefetchable windows, the hardware will drop the write, just as it did
>>> for every 2.6 kernel before 1f82de10.  Thanks,
>> current code:
>>
>> #define  PCI_PREF_RANGE_TYPE_MASK 0x0fUL
>> #define  PCI_PREF_RANGE_TYPE_32 0x00     
>> #define  PCI_PREF_RANGE_TYPE_64 0x01
>> #define  PCI_PREF_RANGE_MASK    (~0x0fUL)
>>
>> if the HW state the pref mmio is 64bit, we will touch upper 32bit. otherwise we will not touch it.
> 
> Really, where?  Please paste the code that writes to
> PCI_PREF_BASE_UPPER32 in the case of hardware supporting a 64bit
> prefetchable window.  I only see this happening if we are assigning it
> to an IORESOURCE_MEM_64 resources.

IORESOURCE_MEM_64 get set when PCI_PREF_RANGE_TYPE_64 is set.

in probe.c::pci_read_bridge_bases()
and
setup-bus.c::pci_bridge_check_ranges()

YH
