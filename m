Return-Path: <linux-kernel-owner+w=401wt.eu-S933167AbYBBK0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbYBBK0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 05:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbYBBK0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 05:26:06 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:58479 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbYBBK0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 05:26:05 -0500
Date: Sat, 2 Feb 2008 11:26:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] pci: fix section mismatch warnings referring to pci_do_scan_bus
Message-ID: <20080202102606.GA22615@uranus.ravnborg.org>
References: <20080131220430.GA4874@uranus.ravnborg.org> <1201817440-5081-1-git-send-email-sam@ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201817440-5081-1-git-send-email-sam@ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 11:10:30PM +0100, Sam Ravnborg wrote:
> Fix following warnings:
> WARNING: o-x86_64/drivers/pci/built-in.o(.text+0xb054): Section mismatch in reference from the function cpci_configure_slot() to the function .devinit.text:pci_do_scan_bus()
> WARNING: o-x86_64/drivers/pci/built-in.o(.text+0x153ab): Section mismatch in reference from the function shpchp_configure_device() to the function .devinit.text:pci_do_scan_bus()
> WARNING: o-x86_64/drivers/pci/built-in.o(__ksymtab+0xc0): Section mismatch in reference from the variable __ksymtab_pci_do_scan_bus to the function .devinit.text:pci_do_scan_bus()
> 
> PCI hotplug were the only user of pci_do_scan_bus()
> so moving this function to the directory of
> PCI Hotplug was a logical way to fix so
> we only include this function in the kernel
> when the CONFIG_HOTPLUG_PCI is enabled.
> 
> Then the abuse of __devinit could be dropped and
> we no longer trigger the above warnings.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Greg KH <gregkh@suse.de>
> Cc: Adrian Bunk <bunk@kernel.org>
> ---

This patch is bogus - I will send an updated version later this weekend.

	Sam
