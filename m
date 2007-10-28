Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbXJ1UER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbXJ1UER (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 16:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbXJ1UEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 16:04:05 -0400
Received: from mx1.suse.de ([195.135.220.2]:59070 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbXJ1UEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 16:04:04 -0400
Date: Sun, 28 Oct 2007 13:03:36 -0700
From: Greg KH <gregkh@suse.de>
To: Barak Fargoun <barak@neocleus.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Guy Zana <guy@neocleus.com>
Subject: Re: [PATCH] Align PCI memory regions to page size (4K) - Fix
Message-ID: <20071028200336.GA14563@suse.de>
References: <9392A06CB0FDC847B3A530B3DC174E7B03C96F1D@mse10be1.mse10.exchange.ms> <20071028193104.GA13956@suse.de> <9392A06CB0FDC847B3A530B3DC174E7B03C96F36@mse10be1.mse10.exchange.ms>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9392A06CB0FDC847B3A530B3DC174E7B03C96F36@mse10be1.mse10.exchange.ms>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 03:53:20PM -0400, Barak Fargoun wrote:
> Hi!
> 
> Regarding all the technical stuff (documentation, coding style, etc.) -
> I thought I did it correctly :( I will fix it ASAP, 
> and send an update when I will finish it.
> 
> About your question: today, some of the hypervisors are using linux
> kernel as their domain-0 (e.g. Xen). In order to implement direct
> hardware access for these native domains (e.g.  running windows in a
> virtual machine above Xen), the PCI memory regions should be aligned
> at-least at the page-level (so, a virtual machine - can't see data of
> other devices which may not be assigned to it). So, for that reason,
> we wanted a boot parameter to let us force the kernel to align PCI
> memory regions at-least at a PAGE_SIZE alignment. It is very useful
> for hypervisors which are developed at Linux environment (e.g.: Xen).

But doesn't aligning such regions on that alignment break some devices
as that is not what the device is asking for in the BIOS?

And if not, why would we not do this for all devices not just for
virtual machines, if it is such a benefit?

Also, how does this play with the hardware IOMMU chips that provide such
virtualization in hardware for you?

And, we can't accept a patch for 2.6.18, there is no development tree to
apply it to anymore, that is a dead kernel tree.  It needs to be against
2.6.24-rc1 at the latest to have a chance for approval.

Is this a patch that distros are shipping in their Xen versions?

And how does this play with KVM?

thanks,

greg k-h
