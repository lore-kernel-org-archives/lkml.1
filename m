Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbZK3WBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbZK3WBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 17:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZK3WBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 17:01:42 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:42988 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbZK3WBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 17:01:41 -0500
Subject: Re: [PATCH] PCI: Always set prefetchable base/limit upper32
 registers
From: Alex Williamson <alex.williamson@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4B143E83.6020105@kernel.org>
References: <20091130212228.7555.43533.stgit@debian.lart>
	 <4B143AE5.7040702@kernel.org> <1259617381.8949.281.camel@8530w.home>
	 <4B143E83.6020105@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: HP OSLO R&D
Date: Mon, 30 Nov 2009 15:01:36 -0700
Message-ID: <1259618496.8949.290.camel@8530w.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 13:52 -0800, Yinghai Lu wrote:
> Alex Williamson wrote:
> > On Mon, 2009-11-30 at 13:36 -0800, Yinghai Lu wrote:
> >> Alex Williamson wrote: 
> >>> -	if (pref_mem64) {
> >>> -		/* Set the upper 32 bits of PREF base & limit. */
> >>> -		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
> >>> -		pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
> >>> -	}
> >>> +	/* Set the upper 32 bits of PREF base & limit. */
> >>> +	pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
> >>> +	pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
> >>>  
> >>>  	pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, bus->bridge_ctl);
> >>>  }
> >> when pref_mem64=0 it means that pref register is only 32 bit, we should not touch upper 32bits.
> > 
> > Did you read my patch description?  In that case bu = lu = 0 and we
> > clear whatever state the BIOS left for those registers.
> 
> if HW state that reg is only 32bit pref, why should we care about the upper 32bit?

In my case, we're programming a 32bit prefetchable range into a 64bit
capable bridge.  We can't just assume the upper 32bits are already zero.

> looks like that your bridge device need quirk to clear that so called upper 32bit for it.

I don't believe the PCI spec dictates whether the upper 32bit base
should be 0 or -1, so it's purely a BIOS initialization choice and Linux
should properly handle both.  If the hardware only supports 32bit
prefetchable windows, the hardware will drop the write, just as it did
for every 2.6 kernel before 1f82de10.  Thanks,

Alex

