Return-Path: <linux-kernel-owner+w=401wt.eu-S937103AbXHHQzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937103AbXHHQzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764391AbXHHQzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:55:15 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:48649 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764324AbXHHQzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:55:13 -0400
Date: Wed, 8 Aug 2007 18:55:06 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org, David Vrabel <david.vrabel@csr.com>
Subject: Re: [patch 3/4] sdio: extend sdio_readsb() and friends to handle
 any length of buffer
Message-ID: <20070808185506.1f9c2114@poseidon.drzeus.cx>
In-Reply-To: <46B9C38C.1030708@csr.com>
References: <11858961933491-git-send-email-david.vrabel@csr.com>
	<20070804152304.65ed8f1b@poseidon.drzeus.cx>
	<46B6F877.7060504@csr.com>
	<20070806171207.59fafa18@poseidon.drzeus.cx>
	<46B73F18.5030109@csr.com>
	<20070806220145.66b97559@poseidon.drzeus.cx>
	<46B86ADB.90000@csr.com>
	<46B86BB0.4000100@csr.com>
	<20070807221719.7c89e5b6@poseidon.drzeus.cx>
	<46B998B5.9040203@csr.com>
	<20070808123759.26a74b2a@poseidon.drzeus.cx>
	<46B9C38C.1030708@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Aug 2007 14:22:20 +0100
David Vrabel <david.vrabel@csr.com> wrote:

> 
> Setting the block size in io_rw_ext_helper() has several drawbacks,
> namely:
> 
> 1. Reduces the flexibility of drivers to manage what commands are
> performed. 2. A performance penalty on the first transfer.
> 3. Greater code complexity.
> 4. Non-intuitive location for card initialization code.
> 
> Sure we could just through hoops and add (much) extra complexity to
> the core, to improve item 1 but 2, 3 and 4 are insoluble. Given that
> setting block size before the first command has /zero/ benefits[1],
> why bother?

3 and 4 are subjective, and for 2, the performance penalty has to come
some place. The upside, as explained, is that drivers aren't penalized
for setting the block size and then failing to use it. Something that
gives us the flexibility to write cleaner code.

As for benefits, there are other issues. We might want to deal with
things like alignment problems in the future.

> 
> Your insistence on this stupid idea baffles me, particularly in the
> light of your other useful comments.
> 
> I would also like to advise that until a larger number of function
> drivers become available that the core is kept as simple and as
> flexible as possible.  Without knowing how different cards operate it
> is difficult to know what's common behaviour and what's card specific.
> 

Agreed, we're doing a bit more guessing than one would like. But I
don't agree in keeping the core simple and flexible. Rather the
opposite. Any guarantee that we give drivers now and need to remove in
the future needs to be tested with all drivers that rely on it (a
difficult task as it often takes some effort to find people with
hardware and the ability to test patches).

As such, the guarantees should be kept at a minimum. Code is easily
changed, API is not.

IMO, the best way to achieve this is with an API that describes _what_
the drivers want to do, not _how_. Hence my insistence on allowing
drivers to specify the difference between "I want this data
transferred" and "I want this data transferred with an exact block size
of 32 bytes".

> My latest (and hopefully final) patch set follows.
> 

These looks good. The only part I'm really attached to is the blksz ==
0 case, which you have.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
