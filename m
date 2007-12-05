Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbXLEV2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbXLEV2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 16:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbXLEV22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 16:28:28 -0500
Received: from waste.org ([66.93.16.53]:42518 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbXLEV21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 16:28:27 -0500
Date: Wed, 5 Dec 2007 15:26:47 -0600
From: Matt Mackall <mpm@selenic.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071205212646.GP17536@waste.org>
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <20071204164720.6e4dc2c4@the-village.bc.nu> <475599D6.4030008@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475599D6.4030008@cosmosbay.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 07:17:58PM +0100, Eric Dumazet wrote:
> Alan Cox a ?crit :
> >>No matter what you consider as being better, changing a 12 years old and 
> >>widely used userspace interface like /dev/urandom is simply not an 
> >>option.
> >>    
> >
> >Fixing it to be more efficient in its use of entropy and also fixing the
> >fact its not actually a good random number source would be worth looking
> >at however.
> >  
> Yes, since current behavior on network irq is very pessimistic.

No, it's very optimistic. The network should not be trusted.

The distinction between /dev/random and /dev/urandom boils down to one
word: paranoia. If you are not paranoid enough to mistrust your
network, then /dev/random IS NOT FOR YOU. Use /dev/urandom. Do not
send patches to make /dev/random less paranoid, kthxbye.

> If you have some trafic, (ie more than HZ/2  interrupts per second), 
> then add_timer_randomness() feeds
> some entropy but gives no credit (calling credit_entropy_store() with 
> nbits=0)
> 
> This is because we take into account only the jiffies difference, and 
> not the get_cycles() that should give
> us more entropy on most plaforms.

If we cannot measure a difference, we should nonetheless assume there
is one?
 
> In this patch, I suggest that we feed only one u32 word of entropy, 
> combination of the previous distinct
> words (with some of them being constant or so), so that the nbits 
> estimation is less pessimistic, but also to
> avoid injecting false entropy.

Umm.. no, that's not how it works at all.

Also, for future reference, patches for /dev/random go through me, not
through Dave.

-- 
Mathematics is the supreme nostalgia of our time.
