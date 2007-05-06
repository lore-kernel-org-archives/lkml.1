Return-Path: <linux-kernel-owner+w=401wt.eu-S1751750AbXEFQBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbXEFQBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 12:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbXEFQBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 12:01:22 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:60922 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751750AbXEFQBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 12:01:21 -0400
Date: Sun, 6 May 2007 18:01:04 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>, Stefan Roese <ml@stefan-roese.de>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: Correct location for ADC/DAC drivers
Message-ID: <20070506160104.GV22585@pengutronix.de>
References: <8fZXU-3EI-11@gated-at.bofh.it> <8haHG-6zd-19@gated-at.bofh.it> <8hd2U-1Ca-39@gated-at.bofh.it> <8heii-3GM-37@gated-at.bofh.it> <E1Hkfia-0000cJ-18@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <E1Hkfia-0000cJ-18@be1.lrz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 02:19:59PM +0200, Bodo Eggert wrote:
> Since you ask for random thoughts:
> 
> IO of data streams from or to a DAC/ADC is essentially what soundcards do.
> I'm wondering if these cards are similar enough to use alsa, and if using
> that interface would ease or hinder programming the driver.

I had a short look at ALSA and it looks like it is a little bit too
focussed towards "normal" audio. For example, if follows an asynchronous
model in the sense that an application can read/write to a buffer at any
time, taken that the ringbuffer doesn't overflow. That's not enough for
example for control applications; you need the option for real
synchronous operation there.

IMHO we need an API which offers

- kernel ring buffers (to make it sure no data gets lost)
- generic data types (streaming plain ADC values is just the simplest
  case; we also have for example streaming FPGA data containing 
  preprocessed data sets)
- optional timestamping for each sample
- zero-copy from hardware into userspace memory, with DMA support
- application notification every N samples (N >= 1)

v4l2 may also be worth a look; but in the end I suppose they are all
specialized sub-cases of what we'd need for fast DAQ.

Robert
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

