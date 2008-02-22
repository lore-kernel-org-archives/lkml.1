Return-Path: <linux-kernel-owner+w=401wt.eu-S935506AbYBVOPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935506AbYBVOPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbYBVOOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:14:51 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:49364 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764643AbYBVOOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:14:49 -0500
Date: Fri, 22 Feb 2008 23:15:10 +0900 (JST)
Message-Id: <20080222.231510.56565462.anemo@mba.ocn.ne.jp>
To: marc.pignat@hevs.ch
Cc: david-b@pacbell.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, hskinnemoen@atmel.com
Subject: Re: [PATCH] atmel_spi: support zero length transfer
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <200802221030.32263.marc.pignat@hevs.ch>
References: <200802211026.17816.marc.pignat@hevs.ch>
	<20080221192334.EE97A230A58@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<200802221030.32263.marc.pignat@hevs.ch>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008 10:30:31 +0100, Marc Pignat <marc.pignat@hevs.ch> wrote:
> > > David, do you think writing 0 bytes is a valid use of this API?
> > 
> > Just a zero byte transfer ... no, though it depends what you mean
> > by "valid".  (I'm not sure I'd expect all controller drivers to
> > reject such requests.)  That has no effect on bits-on-the-wire,
> > and would make trouble for various DMA engines.
> So, the behaviour is undefined, something between 'crash my dma engine',
> 'assert chip select and wait some time', or 'do_nothing'...

If the driver could not handle zero length transfer, then the driver
should reject it (just like unsupported transfer mode).  Then the
behavior will be 'assert chip select and wait some time' or 'rejected
by the driver'.

> > And it would probably deserve a mode flag (sigh) unless someone
> > can update every master controller driver.
> Supporting the zero-len-write means checking and perhpaps updating
> each driver for the benefit of having an unknown length delay.
> 
> We should add the delay field in the spi_device, but this means more work.
> 
> Is this kind of device so common that we need to do all that work? or can we
> leave it as is (verified to work only with atmel_spi)?

I think my case is not so common.  But if the driver could support
zero length transfer easily, there is no reason to reject it.

And if nobody wanted to support zero length transfer on that driver,
it would be no reason to update it ;)

---
Atsushi Nemoto
