Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYIWQnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYIWQnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 12:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYIWQnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 12:43:25 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:48612 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbYIWQnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 12:43:24 -0400
Date: Tue, 23 Sep 2008 09:43:22 -0700
From: Ira Snyder <iws@ovro.caltech.edu>
To: Timur Tabi <timur@freescale.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problems with Freescale DMA driver
Message-ID: <20080923164322.GC7449@ovro.caltech.edu>
References: <20080825165133.GA20446@ovro.caltech.edu> <e9c3a7c20809181458p4cabccblfde6a92bf35976ee@mail.gmail.com> <48D2D00B.3010001@freescale.com> <20080922230435.GA20825@ovro.caltech.edu> <48D8F73A.4050004@freescale.com> <20080923155935.GA7449@ovro.caltech.edu> <48D914DD.7080702@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D914DD.7080702@freescale.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Tue, 23 Sep 2008 09:43:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 11:10:05AM -0500, Timur Tabi wrote:
> (Removing various CC:'s since this thread is changing topic)
> 
> Ira Snyder wrote:
> 
> > I hope that makes sense. I can post the code if anyone would like to see
> > it. It is not ready for mainline inclusion yet, but it is in a fairly
> > good state.
> 
> Well, it's a bit goofy, but it does make sense.  Since you don't have an actual
> single-function PCI device, you need to use the MPC8349's DMA controller.
> 
> I don't see where you need the ability to reserve a DMA channel, though.  You're
> using fsldma.c as its intended.
> 

Ok. I don't really care which channel I get, just that I get one. I
won't be adding or removing DMA devices from the system, so it shouldn't
be a problem.

> > Ok. I was just wondering, since drivers/dma/fsl_dma.c has some code that
> > appears to handle external master. It is 85XX specific though. There are
> > no users in the kernel tree showing example uses.
> 
> Indeed it does.  It looks like a feature that was thrown in but never given much
> thought or testing.  It appears that the current code just lets you turn on the
> external master pause bit in the MR register, but there's nothing to make sure
> that it actually works in a meaningful way.  If there's a queue of transfers for
> a given channel, I don't see where the fsldma avoids stalled queues.
> 

That was also my impression. I'll probably start by programming the
registers directly, and hopefully come up with a nice interface. When I
figure it out, I'll send patches.

In this case, I probably would like to reserve a DMA channel for my
exclusive use. That way I won't run into problems by programming the DMA
by hand.

Thanks for all the input.
Ira
