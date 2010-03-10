Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab0CJPQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:16:13 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59003 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751248Ab0CJPQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:16:11 -0500
Date: Wed, 10 Mar 2010 10:16:09 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mel Gorman <mel@csn.ul.ie>
cc: Markus Rechberger <mrechberger@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: USBFS Memory allocation Bug
In-Reply-To: <20100310135722.GL4883@csn.ul.ie>
Message-ID: <Pine.LNX.4.44L0.1003101007410.1516-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010, Mel Gorman wrote:

> On Tue, Mar 09, 2010 at 10:09:57PM +0100, Markus Rechberger wrote:
> > Hi,
> > 
> > I just stumbled around following issue:
> > 
> > <SNIP to have one full message>
> >
> > [275835.491094] mediasrv: page allocation failure. order:6, mode:0x40d0
> 
> This is massive. Why is usbdev_ioctl requiring an order-6 allocation?
> Does it have the option to fall back to vmalloc() for example?

We needed to implement an upper limit on the buffer size, and the value
chosen was sufficient for 8 ms of data.  There is no fallback to
vmalloc().

Of course, the mediasrv program could always make multiple smaller
data submissions instead of a single big one.

> So, it's a high-order allocation but no swap is configured. As the
> system has a big mix of both anonymous and file memory, it is likely it
> was unable to find a large enough contiguous range of file-backed memory
> it could discard. There is pretty much nothing the memory manager could
> do here. 
> 
> FWIW, if swap was configured I'd think there was more the memory manager
> could have done.
> 
> Is usb falling back to vmalloc() or order-0 pages possible?

No.  It's not possible since the buffer has to be contiguous for DMA
purposes (this is a requirement of the driver interface).

Alan Stern

