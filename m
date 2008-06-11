Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbYFKOjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbYFKOjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 10:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757419AbYFKOjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 10:39:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42796 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754521AbYFKOjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 10:39:03 -0400
Date: Wed, 11 Jun 2008 10:39:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: AntonioLin <antonio.lin@alcormicro.com>, Jens Axboe <axboe@kernel.dk>
cc: David Vrabel <david.vrabel@csr.com>, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [S] Re: [linux-uwb] packet size problem
In-Reply-To: <00b401c8cbc1$ebd48800$5108a8c0@alcormicro.com>
Message-ID: <Pine.LNX.4.44L0.0806111032330.2459-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008, AntonioLin wrote:

> Hi All,
> 
> I checked srb->device->request_queue->dma_alignment in usb_stor_bulk_Bulk_transport() routine. , the value is 1023.
> 
> But in usb_stor_bulk_transfer_sglist, the length of first element in sg array is 3584 which is not divisible by 1024.
> 
> 
> Can you post your /proc/bus/usb/devices ?
> 
> I don't know how to do this, could you descript moe about it ?
> (Sorry,I have few experience about Linux.)

All you have to do is:

	cat /proc/bus/usb/devices

Or even just tell your email client to include /proc/bus/usb/devices as
an attachment.  However some Linux distributions don't automatically
mount /proc/bus/usb.  If yours doesn't, you will have to do (as root):

	mount -t usbfs none /proc/bus/usb

before you can access /proc/bus/usb/devices.  But in any case it
doesn't matter, since you have checked that the value of dma_alignment
really is 1023.

Jens, this is a question for you.  How come we're getting an SG element
whose lenth is 3584 when the request_queue's dma_alignment mask is set
to 1023?  Is dma_alignment not the right parameter to set?

Alan Stern

