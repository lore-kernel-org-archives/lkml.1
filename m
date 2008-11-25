Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbYKYVtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbYKYVtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbYKYVrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:47:07 -0500
Received: from kroah.org ([198.145.64.141]:41339 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754290AbYKYVrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:47:06 -0500
Date: Tue, 25 Nov 2008 13:43:24 -0800
From: Greg KH <greg@kroah.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fakephp: Allocate PCI resources before adding the
	device
Message-ID: <20081125214324.GA23177@kroah.com>
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 01:24:22PM -0800, Darrick J. Wong wrote:
> For PCI devices, pci_bus_assign_resources() must be called to set up the
> pci_device->resource array before pci_bus_add_devices() can be called, else
> attempts to load drivers results in BAR collision errors where there are none.
> This is not done in fakephp, so devices can be "unplugged" but scanning the
> parent bus won't bring the devices back due to resource unallocation.  Move the
> pci_bus_add_device-calling logic into pci_rescan_bus and preface it with a call
> to pci_bus_assign_resources so that we only have to (re)allocate resources once
> per bus where a new device is found.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Darrick, I am no longer the PCI maintainer, Jesse is.

Please resend this to him, and the linux-pci mailing list if you want it
to have a chance to get accepted.

thanks,

greg k-h
