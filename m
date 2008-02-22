Return-Path: <linux-kernel-owner+w=401wt.eu-S1759767AbYBVJaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759767AbYBVJaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYBVJac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:30:32 -0500
Received: from mail.hevs.ch ([153.109.23.10]:34923 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbYBVJaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:30:30 -0500
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] atmel_spi: support zero length transfer
Date: Fri, 22 Feb 2008 10:30:31 +0100
User-Agent: KMail/1.9.7
Cc: anemo@mba.ocn.ne.jp, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, hskinnemoen@atmel.com
References: <20080221.005432.07645461.anemo@mba.ocn.ne.jp> <200802211026.17816.marc.pignat@hevs.ch> <20080221192334.EE97A230A58@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
In-Reply-To: <20080221192334.EE97A230A58@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802221030.32263.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave!

On Thursday 21 February 2008, David Brownell wrote:
> > David, do you think writing 0 bytes is a valid use of this API?
> 
> Just a zero byte transfer ... no, though it depends what you mean
> by "valid".  (I'm not sure I'd expect all controller drivers to
> reject such requests.)  That has no effect on bits-on-the-wire,
> and would make trouble for various DMA engines.
So, the behaviour is undefined, something between 'crash my dma engine',
'assert chip select and wait some time', or 'do_nothing'...

...
> This *specific* usage might arguably belong in spi_device, since
> it's a delay required after chipselect goes active and before any
> bytes get transferred.  It's clearly not a per-transfer thing, and
> should also apply after a temporary mid-message chip deselect.
Ack, should be in spi_device (same remark for spi_transfer->delay_usec?).

> 
> And it would probably deserve a mode flag (sigh) unless someone
> can update every master controller driver.
Supporting the zero-len-write means checking and perhpaps updating each driver
for the benefit of having an unknown length delay.

We should add the delay field in the spi_device, but this means more work.

Is this kind of device so common that we need to do all that work? or can we
leave it as is (verified to work only with atmel_spi)?

Regards

Marc
