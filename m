Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbZEYVIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbZEYVIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 17:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbZEYVIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 17:08:13 -0400
Received: from netrider.rowland.org ([192.131.102.5]:40439 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751998AbZEYVIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 17:08:12 -0400
Date: Mon, 25 May 2009 17:08:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: Kay Sievers <kay.sievers@vrfy.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.a.30-rc7: fat filesystem misdetected as amiga
In-Reply-To: <20090525205353.GB6856@redhat.com>
Message-ID: <Pine.LNX.4.44L0.0905251704490.27717-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 May 2009, Michael S. Tsirkin wrote:

> > So apparently this is a bug in the device; it doesn't respond correctly
> > to the first READ command.  But since it does respond correctly to 
> > later commands, everything works okay thereafter.  You ought to be able 
> > to recover from the error by running
> > 
> > 	blockdev --rereadpt /dev/sdb
> > 
> > manually.
> 
> Yes, this helps.
> Would it make sense for kernel to retry automatically?
> Why doesn't it?

I don't know the details in this case.  Most likely the error code 
(Logical Block Address Out of Range) is interpreted as a fatal 
non-retryable error.  For other sorts of errors, the kernel does retry.

> > As far as I can tell, this has nothing to do with any user programs in 
> > the distribution.  It appears to be entirely the device's fault.
> > 
> > Alan Stern
> 
> BTW, any idea how come I later get errors apparently from amiga fs?

Not a clue.  Unless it was some odd side effect of the partition code 
trying to interpret an uninitialized buffer.

Alan Stern

