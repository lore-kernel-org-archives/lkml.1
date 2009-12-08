Return-Path: <linux-kernel-owner+w=401wt.eu-S937332AbZLHRhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937332AbZLHRhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 12:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937316AbZLHRhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 12:37:03 -0500
Received: from cantor.suse.de ([195.135.220.2]:44901 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935972AbZLHRhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 12:37:01 -0500
Date: Tue, 8 Dec 2009 09:34:16 -0800
From: Greg KH <gregkh@suse.de>
To: Erez Shitrit <erezsh@mellanox.co.il>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: SR-IOV enabling process failed in kernel 2.6.32
Message-ID: <20091208173416.GA25957@suse.de>
References: <2ED289D4E09FBD4D92D911E869B97FDD01E6E538@mtlexch01.mtl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ED289D4E09FBD4D92D911E869B97FDD01E6E538@mtlexch01.mtl.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 11:02:22AM +0200, Erez Shitrit wrote:
> Hi Greg,
>  
> We are working on InfiniBand device that supports SR-IOV.
> and lately (from version 2.6.32 ) we faced a problem:
> When the driver tried to enable SR-IOV it failed to allocate resources
> for the 2 BARS the device needs.

Hm, you do realize I'm no longer the PCI maintainer, and havn't been for
about 1 1/2 years, right?  :)

> The situation is when there are 2 BARS, the first asks for little amount
> of memory and the second asks for much larger memory requirements.
> I saw in the code (drivers/pci/iov.c) that the order of the allocation
> starts from the first BAR to the last
> The code:
> for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
>   res = iov->res + i;
>   if (!res->flags)
>       continue;
>   rc = pci_assign_resource(dev, i + PCI_IOV_RESOURCES);
> 
> This process failed for the second BAR (The big one). (in the log: "not
> enough MMIO resources for SR-IOV")
>  
> I think (IMHO) it because the allocation of the first BAR (the little)
> one was from the allocated slot of the big one (the allocation from the
> sriov_init function)
> and when the kernel tries to allocate the slot for he second BAR (the
> big one) in the place of the little one it failed.
>  
> when I changed the code to start the allocation from the last to the
> first: for (i = PCI_SRIOV_NUM_BARS; i >= 0; i--) 
> It works fine.
>  
> Is it a bug ? 

I don't know, care to make a patch that shows your exact change?

thanks,

greg k-h
