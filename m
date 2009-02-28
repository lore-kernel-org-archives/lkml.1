Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbZB1WNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbZB1WNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 17:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbZB1WNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 17:13:09 -0500
Received: from mail.openmoko.org ([88.198.124.205]:46011 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbZB1WNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 17:13:09 -0500
Date: Sun, 1 Mar 2009 03:42:49 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       Andy Green <andy@openmoko.com>
Subject: Re: [PATCH 0/2] spi: Add support for non-blocking synchronous
	transfers
Message-ID: <20090228221247.GA3107@fedora.yogi>
References: <20090228081036.31964.80618.stgit@fedora.yogi> <200902281233.50612.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902281233.50612.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 12:33:50PM -0800, David Brownell wrote:
> Note that $SUBJECT concept is nonsense.
> Synchronous calls are by definition blocking ones...
> 
> 

FWIW, it is exactly this that we want to change.

> On Saturday 28 February 2009, Balaji Rao wrote:
> > During the course of development of an accelerometer driver, we saw the
> > necessity to execute spi transfers synchronously within an interrupt handler.
> 
> This sounds like a bad design.  How can you know that no other
> transfers are going on ... or are queued in front of the transfer
> you're requesting?
> 
> You'd need to wait for all the other transfers to work their
> way through the transfer queue.  There are *much* better things
> to do in interrupt handlers.
> 

Please do look at the patches. We *don't* use a transfer queue.
Transfers requested through our proposed function should/will complete the
transfer when it returns without sleeping in between. (Which is the whole
point of this patch).

> 
> > When using a workqueue instead, we observed a huge number of overruns
> > with very high cpu utlization, which is unacceptable.
> 
> Sure, but at least part of that seems to be caused by some
> broken design assumptions.
> 

No, it's not. Read below.

> Why are you even trying to touch SPI devices from hardirq
> context?  That's never going to be OK; "can't-sleep" contexts
> don't mix with "must-sleep" calls.
> 
> 

Accelerometers can produce a huge amount of data and we need to quickly
read them to avoid overruns. Also, scheduling workers for this greatly
increases the number of context switches, unnecessarily.

> > This series adds a new interface for this and modifies no existing ones.
> 
> NAK on these two patches.
> 

Ok, it will be helpful if you please suggest an alternative keeping in
mind the huge amount of data produced by the accelerometer and the need
to read them quickly ?

Thanks,
Balaji
