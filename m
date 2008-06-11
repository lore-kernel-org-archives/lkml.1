Return-Path: <linux-kernel-owner+w=401wt.eu-S1759875AbYFKOy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875AbYFKOy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 10:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759559AbYFKOx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 10:53:56 -0400
Received: from brick.kernel.dk ([87.55.233.238]:12228 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759552AbYFKOxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 10:53:55 -0400
Date: Wed, 11 Jun 2008 16:53:52 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: AntonioLin <antonio.lin@alcormicro.com>,
       David Vrabel <david.vrabel@csr.com>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [S] Re: [linux-uwb] packet size problem
Message-ID: <20080611145349.GD20851@kernel.dk>
References: <00b401c8cbc1$ebd48800$5108a8c0@alcormicro.com> <Pine.LNX.4.44L0.0806111032330.2459-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0806111032330.2459-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11 2008, Alan Stern wrote:
> On Wed, 11 Jun 2008, AntonioLin wrote:
> 
> > Hi All,
> > 
> > I checked srb->device->request_queue->dma_alignment in usb_stor_bulk_Bulk_transport() routine. , the value is 1023.
> > 
> > But in usb_stor_bulk_transfer_sglist, the length of first element in sg array is 3584 which is not divisible by 1024.
> > 
> > 
> > Can you post your /proc/bus/usb/devices ?
> > 
> > I don't know how to do this, could you descript moe about it ?
> > (Sorry,I have few experience about Linux.)
> 
> All you have to do is:
> 
> 	cat /proc/bus/usb/devices
> 
> Or even just tell your email client to include /proc/bus/usb/devices as
> an attachment.  However some Linux distributions don't automatically
> mount /proc/bus/usb.  If yours doesn't, you will have to do (as root):
> 
> 	mount -t usbfs none /proc/bus/usb
> 
> before you can access /proc/bus/usb/devices.  But in any case it
> doesn't matter, since you have checked that the value of dma_alignment
> really is 1023.
> 
> Jens, this is a question for you.  How come we're getting an SG element
> whose lenth is 3584 when the request_queue's dma_alignment mask is set
> to 1023?  Is dma_alignment not the right parameter to set?

dma_alignment mask is the buffer address alignment, so they are not
completely the same. But it does sound odd, since you would then be
spanning two pages for that sg element. Is this before or after dma
mapping the sg table?

-- 
Jens Axboe

