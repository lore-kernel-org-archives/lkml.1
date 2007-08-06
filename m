Return-Path: <linux-kernel-owner+w=401wt.eu-S933609AbXHFO6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609AbXHFO6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932558AbXHFO6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 10:58:16 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:56259 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601AbXHFO6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 10:58:15 -0400
Date: Mon, 6 Aug 2007 16:58:09 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sdio: parameterize SDIO FBR register defines
Message-ID: <20070806165809.1d0b2791@poseidon.drzeus.cx>
In-Reply-To: <46B6F46B.8050707@csr.com>
References: <11858961933491-git-send-email-david.vrabel@csr.com>
	<11858961931710-git-send-email-david.vrabel@csr.com>
	<20070804152613.1f190abc@poseidon.drzeus.cx>
	<46B6F46B.8050707@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Aug 2007 11:14:03 +0100
David Vrabel <david.vrabel@csr.com> wrote:

> 
> I really don't follow you objection to this.  If one is maintaining
> the SDIO core then I would expect some familiarity with the spec and
> an understanding the FBRs are per-function but contained in the same
> CCCR/F0 register space.
> 

If we can reduce that barrier, then I think we should. People can't be
expected to keep everything fresh in memory all the time. And we won't
have a team dedicated to hacking this all the time.

> Also, I would consider the start of the CCCR as the "base address".
> 

In some sense, but there are also several identical FBR chunks on the
card. So by most definitions of a base address, the start of each chunk
would be it.

> > Would you be content with replacing "func->num * 0x100" with a
> > macro so that the code becomes something like:
> > 
> > 	SDIO_FBR_BASE(func->num) + SDIO_FBR_STD_IF
> 
> I think this is less readable than SDIO_FBR_STD_IF(func->num).
> 

It's subjective. But the longer version is more understandable for
someone who doesn't have the details of the SDIO protocol fresh in his
mind.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
