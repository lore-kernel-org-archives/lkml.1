Return-Path: <linux-kernel-owner+w=401wt.eu-S1764386AbXHCWZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764386AbXHCWZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 18:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763338AbXHCWZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 18:25:16 -0400
Received: from colo.lackof.org ([198.49.126.79]:42714 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762605AbXHCWZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 18:25:15 -0400
Date: Fri, 3 Aug 2007 16:24:58 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Greg KH <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Engraf <david.engraf@netcom.eu>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] USB BIOS early handoff only when the
	we the driver is configured
Message-ID: <20070803222458.GB27130@colo.lackof.org>
References: <46B1844B.8090007@netcom.eu> <Pine.LNX.4.44L0.0708021009460.3611-100000@iolanthe.rowland.org> <20070802164329.GD28721@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802164329.GD28721@suse.de>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.15+20070515 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 09:43:29AM -0700, Greg KH wrote:
...
> It wasn't just MIPS.  IBM has a very popular blade system that has huge
> issues with this, and I think there are some other IBM systems based on
> the same BIOS that also do bad things if we don't grab the USB
> controller away from the BIOS as soon as possible (nasty interrupt and
> other messes happen...)

PA-RISC has the same problem with USB. We can't reprogram the IOMMU
windows at boot time unless the USB controller is forcefully stopped
from doing DMA. "BIOS" leaves the USB DMA enabled to avoid loosing
activity between polls for input.

PA-RISC solves this by calling back into the "BIOS" (aka PDC) to cleanly stop
all possible DMA devices. Other arches probably don't have this luxury.

grant
