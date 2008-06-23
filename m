Return-Path: <linux-kernel-owner+w=401wt.eu-S1758413AbYFWPyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413AbYFWPyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 11:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbYFWPyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 11:54:23 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:54542 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbYFWPyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 11:54:22 -0400
X-Greylist: delayed 4057 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jun 2008 11:54:22 EDT
Message-ID: <485FB730.2010705@csr.com>
Date: Mon, 23 Jun 2008 15:46:08 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Kernel development list <linux-kernel@vger.kernel.org>,
       AntonioLin <antonio.lin@alcormicro.com>, linux-usb@vger.kernel.org,
       "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
Subject: Re: Scatter-gather list constraints
References: <Pine.LNX.4.44L0.0806201623080.2133-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0806201623080.2133-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jun 2008 14:46:08.0922 (UTC) FILETIME=[DF7CE7A0:01C8D53F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> Is there any way to express the constraint that for a particular 
> request queue, all members of a scatter-gather list (except the last) 
> must be a multiple of a particular length?
> 
> This question arises in connection with wireless USB mass-storage
> devices.  The controller driver requires that all DMA segments
> in a transfer, other than the last one, have a multiple of 1024 bytes.  
> But we're sometimes getting s-g lists where an element contains an odd
> number of 512-byte sectors, and of course it doesn't work.

Note that this 1024 byte multiple is for one particular WUSB mass
storage device.  The WUSB standard permits max packet sizes of up 3584
(in multiples of 512), but I suspect WUSB mass storage devices will only
use 512, 1024, or 2048.

For a solution, we may be able to do something if the HWA host
controller is passed a single URB with an s-g list (rather than one URB
per s-g list entry) and was careful about how it segmented the URB into
transfers to the rpipe.

Inaky, you know more about WAs that me.  Could you comment on this?

A similar solution for WHCI host controllers would require a revision of
the WHCI spec to support full scatter-gather DMA.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
