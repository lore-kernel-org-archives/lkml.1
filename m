Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab0COFcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 01:32:14 -0400
Received: from complete.lackof.org ([198.49.126.79]:37590 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab0COFcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 01:32:11 -0400
Date: Sun, 14 Mar 2010 23:32:09 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Grant Grundler <grundler@parisc-linux.org>
Subject: Re: PCI express switch handling ..
Message-ID: <20100315053209.GC28926@lackof.org>
References: <1a297b361003141218g783d1880p98b15749d01bd813@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a297b361003141218g783d1880p98b15749d01bd813@mail.gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 11:18:05PM +0400, Manu Abraham wrote:
> Hi All,
> 
> I have one of these PCIe switches on one of the PCIe cards that I have:
> 
> http://www.plxtech.com/products/expresslane/pex8604
> 
> I was wondering how to handle this thing, ie;
> 
> I have to PCIe devices behind this switch, which looks thus:
> 
> 06:00.0 PCI bridge: PLX Technology, Inc. Device 8604 (rev ba)
> 07:01.0 PCI bridge: PLX Technology, Inc. Device 8604 (rev ba)
> 07:04.0 PCI bridge: PLX Technology, Inc. Device 8604 (rev ba)
> 07:05.0 PCI bridge: PLX Technology, Inc. Device 8604 (rev ba)
> 09:00.0 Multimedia controller: Philips Semiconductors Device 7231 (rev aa)
> 0a:00.0 Multimedia controller: Philips Semiconductors Device 7231 (rev aa)

Can you post "lspci -vt" and "lspci -v" output?
It will tell us alot more about the heirarchy and address space routing.

> I am wondering if i need to access or address the switch specifically
> to forward data specifically to one of the bridges behind the switch.

No. MMIO routing is handling by MMIO "window" register in the bridge.

While it's called a "switch" because it can route MMIO transactions
from one downstream PCI-e link to any other.

> At present I can access one of the Multimedia controllers (09:00.0) ,
> but it seems I can't access the other one and hence my question as to
> determine whether it is something else.

"lspci -vt" will show what is visible in PCI Config space.

"lspci -v" will tell us how the bridge is configured.

hth,
grant
