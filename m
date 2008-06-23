Return-Path: <linux-kernel-owner+w=401wt.eu-S1759200AbYFWPMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200AbYFWPMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 11:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbYFWPMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 11:12:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54112 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755238AbYFWPMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 11:12:14 -0400
Date: Mon, 23 Jun 2008 11:12:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Vrabel <david.vrabel@csr.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       AntonioLin <antonio.lin@alcormicro.com>, <linux-usb@vger.kernel.org>,
       "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
Subject: Re: Scatter-gather list constraints
In-Reply-To: <485FB730.2010705@csr.com>
Message-ID: <Pine.LNX.4.44L0.0806231109280.2556-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008, David Vrabel wrote:

> Note that this 1024 byte multiple is for one particular WUSB mass
> storage device.  The WUSB standard permits max packet sizes of up 3584
> (in multiples of 512), but I suspect WUSB mass storage devices will only
> use 512, 1024, or 2048.
> 
> For a solution, we may be able to do something if the HWA host
> controller is passed a single URB with an s-g list (rather than one URB
> per s-g list entry) and was careful about how it segmented the URB into
> transfers to the rpipe.

That would be ideal.  However there is no way to pass an S-G list along 
with an URB; there's no field for it in the data structure.  And none 
of the existing host controller drivers support such a thing.

I suppose we could add a field to struct urb and add a flag indicating 
whether the controller driver supports S-G lists.

Alan Stern

