Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbXLSXWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbXLSXWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 18:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbXLSXWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 18:22:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:36068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbXLSXV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 18:21:59 -0500
Date: Wed, 19 Dec 2007 15:16:09 -0800
From: Greg KH <gregkh@suse.de>
To: tcamuso@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       prarit@redhat.com
Subject: Re: [PATCH 0/5]PCI: x86 MMCONFIG
Message-ID: <20071219231609.GE24219@suse.de>
References: <20071219221746.20362.39243.sendpatchset@dhcp83-188.boston.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219221746.20362.39243.sendpatchset@dhcp83-188.boston.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 05:17:46PM -0500, tcamuso@redhat.com wrote:
> OVERVIEW
> =======
> 
> The patches should be applied in sequence to obviate any
> possible build problems.
> 
> The patch-set was built against 2.6.24-rc5
> 
> Description
> ===========
> 
> There exist devices that do not respond correctly to PCI
> MMCONFIG accesses in x86 platforms.

What devices are these?  Do you have reports of them somewhere?

> This patch-set detects the problem by comparing an MMCONFIG
> read to a Legacy PCI config read of the vendor/device dword
> of every device discovered during the PCI probing sequence.
> 
> A miscompare means that a device does not correctly respond
> to MMCONFIG accesses. When the patch code detects this condition,
> the bus that serves this device, and all subordinate buses, will
> be programmed to use Legacy PCI Config accesses.
> 
> This patch-set DOES NOT detect devices that generate machine
> checks against MMCONFIG accesses. For such systems,
> "pci=nommconf" is required in the boot command.

That sounds like this patchset can cause bad side affects on hardware
that currently works just fine.  That is not a good thing to be adding
to the kernel, right?

thanks,

greg k-h
