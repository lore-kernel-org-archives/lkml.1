Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbXFVOXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbXFVOXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757846AbXFVOXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:23:22 -0400
Received: from mail02.vsnet.ch ([153.109.10.41]:42894 "EHLO mail02.vsnet.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757803AbXFVOXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:23:21 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Subject: Re: [PATCH] mmc-atmel : fix kunmap wrong usage
Date: Fri, 22 Jun 2007 16:21:40 +0200
User-Agent: KMail/1.9.5
Cc: Hugh Dickins <hugh@veritas.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <andrew@sanpeople.com>, Pierre Ossman <drzeus@drzeus.cx>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706221237330.26363@blonde.wat.veritas.com> <467BCFCF.6020509@rfo.atmel.com>
In-Reply-To: <467BCFCF.6020509@rfo.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706221621.42000.marc.pignat@hevs.ch>
X-VSnet-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 June 2007 15:34, Nicolas Ferre wrote:
> Hugh Dickins :
> > Aren't you just guessing there?  Those kunmap_atomics in at91_mci.c
> > may look wrong to you, but they're not incorrect (so long as sg->offset
> > falls within the page, as it must do here to make sense of the page).
> > Especially not on ARM, where kunmap_atomic actually has no interest
> > in the argument passed.  And the oops was in the flush_dcache_page.
> > 
> > If you actually reproduced Nicolas' problem on ARM, and verified
> > that your patch then fixes it, please let us know: that will be
> > remarkably interesting.
> 
> Patch tested without success. Indeed, I always see the Oops with 
> Marc's patch.
So, it's really interesting, it worked really for me (oops without patch) and
no oops with it. My hardware is a custom board with an at91rm9200.

I had a look the the kunmap_atomic function, and I _really_ don't understand
how this patch can do something :-/

And last but not least, my patch is completly wrong...
void *kmap_atomic(...);
unsigned int *buffer = kmap_atomic(...) + sg->offset; // addition in u8*
kunmap_atomic(buffer - sg->offset); // <- sub in u32*

-> please forget my patch

Regards

Marc


