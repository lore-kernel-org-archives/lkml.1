Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbYFKPRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbYFKPRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYFKPQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:16:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40714 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751148AbYFKPQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:16:50 -0400
Date: Wed, 11 Jun 2008 11:16:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <jens.axboe@oracle.com>
cc: AntonioLin <antonio.lin@alcormicro.com>,
       David Vrabel <david.vrabel@csr.com>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [S] Re: [linux-uwb] packet size problem
In-Reply-To: <20080611145349.GD20851@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.0806111112370.3218-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008, Jens Axboe wrote:

> > Jens, this is a question for you.  How come we're getting an SG element
> > whose lenth is 3584 when the request_queue's dma_alignment mask is set
> > to 1023?  Is dma_alignment not the right parameter to set?
> 
> dma_alignment mask is the buffer address alignment, so they are not
> completely the same.

Well then, put it this way: We don't care particularly about the
address alignment as such, but we do need the buffer length to be a
multiple of 1024 for all but the last element in the SG list.  Is there
a better way to accomplish this?

> But it does sound odd, since you would then be
> spanning two pages for that sg element. Is this before or after dma
> mapping the sg table?

Both.

Alan Stern

