Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbYEOO2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbYEOO2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 10:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbYEOO2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 10:28:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43393 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753470AbYEOO2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 10:28:25 -0400
Date: Thu, 15 May 2008 10:28:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Bryan Wu <cooloney@kernel.org>
cc: Jie Zhang <jie.zhang@analog.com>, Oliver Neukum <oliver@neukum.org>,
       <harvey.harrison@gmail.com>, <david-b@pacbell.net>, <greg@kroah.com>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] [usb/host]: use get/put_unaligned_* helpers to fix
 more potential unaligned issues.
In-Reply-To: <386072610805150254p6161627er9f99910066287f2f@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0805151022570.2107-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Bryan Wu wrote:

> >>>> What is supposed to make all these changes a good idea?
> >>>>
> >>> Since buf might not be 4-byte aligned.
> >>
> >> It is. Please analyze the code before you use these access methods.
> >>
> > You are right. buf has been 4-byte aligned since 2.6.19. My patch was
> > written two years ago. Sorry for the noise I caused.
> >
> 
> I has keeping this patch for a long time.  Jie fixed this patch at
> 2006/09/20 in our svn:
> http://blackfin.uclinux.org/git/?p=readonly-mirrors/linux-kernel.git;a=commit;h=cb3da1243f84b37b53486c7e86da34565b4c5d92
> http://blackfin.uclinux.org/git/?p=readonly-mirrors/linux-kernel.git;a=commit;h=2559298f0dca2cffc0b87390b92a484004f0d85e
> 
> And a similar patch from David Miller was accept in ohci-hub.c
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=92164c5dd1ade33f4e90b72e407910de6694de49
> 
> Also because of the same issue, which was fixed by:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=54bee6e1b455573658972510a76119f279db32b7
> 
> If other functions not only rh_call_control() call this hub_control()
> pointer and the buf is not 4-byte aligned,
> this bug will fire again without the unaligned API. This patch is
> safer for the caller, although not efficient.

But the hub_control routines are almost never called by anything 
other than rh_call_control().  The only exception is in ehci_hub.c, and 
there the buf pointer is NULL.

So I don't see any need for this patch.

On the other hand, Jie could make a bunch of useful changes to
drivers/usb/gadget/file_storage.c, which has its own private routines
for unaligned little-endian access.

Alan Stern

