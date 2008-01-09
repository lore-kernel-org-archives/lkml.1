Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYAIAHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYAIAHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbYAIAHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:07:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45072 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbYAIAHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:07:18 -0500
Date: Wed, 9 Jan 2008 01:09:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, paolo.ciarrocchi@gmail.com,
       gorcunov@gmail.com, jgarzik@pobox.com, linux-ide@vger.kernel.org
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080109000946.GG2117@one.firstfloor.org>
References: <20080108164015.GC31504@one.firstfloor.org> <47840C57.6000304@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47840C57.6000304@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 07:50:47PM -0400, Kevin Winchester wrote:
> Andi Kleen wrote:
> > Here's a proposal for some useful code transformations the kernel janitors
> > could do as opposed to running checkpatch.pl.
> > 
> <snip>
> 
> I notice that every driver in drivers/ata uses a .ioctl that points to
> ata_scsi_ioctl().  I could add the BKL to that function, and then change

This might be a little more complicated. These
are funnelled through the block/SCSI layers which might not have separate
unlocked ioctl callbacks yet. Would be probably not very difficult
to add though.

> all of the drivers to .unlocked_ioctl, but I assume this would be a
> candidate to actually clean up by determining why the lock is needed and
> removing it if necessary.  Does anyone know off-hand the reason for
> needing the lock (I assume someone does or it wouldn't have survived
> this long)?  If the lock is absolutely required, then I can write the
> patch to add lock_kernel() and unlock_kernel().

Just sending the patch to add lock/unlock_kernel() is probably a good idea anyways --
Jeff will then feel bad over it and eventually remove it when he figures out
it is safe ;-)

-Andi
