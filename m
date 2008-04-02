Return-Path: <linux-kernel-owner+w=401wt.eu-S1757161AbYDBOPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161AbYDBOPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbYDBOPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:15:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47826 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754843AbYDBOPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:15:45 -0400
Date: Wed, 2 Apr 2008 10:15:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sergey Dolgov <solkaa@gmail.com>, Hans de Goede <j.w.r.degoede@hhs.nl>
cc: Boaz Harrosh <bharrosh@panasas.com>, Oliver Neukum <oliver@neukum.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usb-storage, error reading the last 8 sectors, regression in
 2.6.25-rc7
In-Reply-To: <47F32F4F.2030702@hhs.nl>
Message-ID: <Pine.LNX.4.44L0.0804021011310.14858-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Hans de Goede wrote:

> Maybe we should first determine that the regression is _really_
> caused by this?
> 
> When testing yesterday I did a printk of any (unmodified) reads which would 
> touch the last sector and quite a few where not 8 sector reads, so if this 
> devices goes barf on any last sector including read of a different size then 8, 
> it will have troubles without the work around too.
> 
> First we need to determine what _exactly_ causes this device to become unhappy 
> (which should be trivial to test through dd), if I understand things sofar, the 
> device doesn't like if a read is done which stops one sector short of the last 
> sector. Such  a read being done could happen without my split requests code 
> too, so making that conditional then wouldn't do any good, it would only make 
> the bug (much) less likely to get triggered, but it could still happen en 
> probably be reproduced by a trivial dd command.

That's a good point.  Sergey, by using the "skip=" option in dd you 
should be able to test lots of possible combinations.  Verify that if 
you start 8 sectors from the end, then reading 8 sectors works and 
reading 7 sectors fails.  Then see what other combinations fail; for 
example, how far back before the end do you have to start before 
reading 7 sectors will work?  Or what happens if you start 2 sectors 
before the end and read 1 or 2 sectors?  Or if you start 7 sectors 
before the end and read 6 or 7?

Alan Stern

