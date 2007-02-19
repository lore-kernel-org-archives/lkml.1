Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915AbXBSFct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbXBSFct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 00:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbXBSFct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 00:32:49 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:63049 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbXBSFcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 00:32:48 -0500
Date: Sun, 18 Feb 2007 21:28:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>
Subject: Re: [patch/rfc 2.6.20-git] parport reports physical devices
Message-Id: <20070218212835.3bf2f248.randy.dunlap@oracle.com>
In-Reply-To: <200702182108.08217.david-b@pacbell.net>
References: <200702182108.08217.david-b@pacbell.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Feb 2007 21:08:07 -0800 David Brownell wrote:

> Currently a parport_driver can't get a handle on the device node for the
> underlying parport (PNPACPI, PCI, etc).  That prevents correct placement
> of sysfs child nodes, which can affect things like power management.
> 
> This patch resolves that issue for non-legacy configurations:
> 
>     * "struct parport" now has a field pointing to that device node,
>       and non-legacy port drivers now initialize that device pointer:
> 	- parport_mfc3 (can't test or build; no Amiga + Zorro here)
> 	- parport_pc (and stop using only pci_device internally)
> 	- parport_serial
> 	- parport_sunbpp (can't test or build, no SPARC + SBUS here)
> 
>     * pnp now initializes device dma masks (24bits), preventing oopses
>       when generic dma calls are made using pnp device nodes
> 
>     * some of the layered parport_driver code now uses that pointer:
> 	- i2c-parport (parent of i2c_adapter)
> 	- spi_butterfly (parent of spi_master, allowing cruft removal)
> 	- lp (creating class_device)
> 	- ppdev (parent of parportN device)
> 	- tipar (creating class_device)
> 
> Sanity tested on a PC, where PNPACPI provides the device to parport_pc,
> using spi_butterfly.  But I've got to wonder about parport DMA...

Does this patch address http://bugzilla.kernel.org/show_bug.cgi?id=5496 ?

What are you wondering about parport DMA?
Please see http://bugzilla.kernel.org/show_bug.cgi?id=7491
and http://bugzilla.kernel.org/show_bug.cgi?id=7492

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
