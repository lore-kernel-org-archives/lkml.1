Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbXLJXhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbXLJXhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 18:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbXLJXg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 18:36:58 -0500
Received: from waste.org ([66.93.16.53]:55017 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbXLJXg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 18:36:57 -0500
Date: Mon, 10 Dec 2007 17:35:25 -0600
From: Matt Mackall <mpm@selenic.com>
To: Marc Haber <mh+linux-kernel@zugschlus.de>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071210233525.GK19691@waste.org>
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <20071204164720.6e4dc2c4@the-village.bc.nu> <475599D6.4030008@cosmosbay.com> <20071205212646.GP17536@waste.org> <20071209124200.GA31147@torres.zugschlus.de> <20071209161605.GX19691@waste.org> <20071210230643.GC32133@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210230643.GC32133@torres.zugschlus.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 12:06:43AM +0100, Marc Haber wrote:
> On Sun, Dec 09, 2007 at 10:16:05AM -0600, Matt Mackall wrote:
> > On Sun, Dec 09, 2007 at 01:42:00PM +0100, Marc Haber wrote:
> > > On Wed, Dec 05, 2007 at 03:26:47PM -0600, Matt Mackall wrote:
> > > > The distinction between /dev/random and /dev/urandom boils down to one
> > > > word: paranoia. If you are not paranoid enough to mistrust your
> > > > network, then /dev/random IS NOT FOR YOU. Use /dev/urandom.
> > > 
> > > But currently, people who use /dev/urandom to obtain low-quality
> > > entropy do a DoS for the paranoid people.
> > 
> > Not true, as I've already pointed out in this thread.
> 
> I must have missed this. Can you please explain again? For a layman it
> looks like a paranoid application cannot read 500 Bytes from
> /dev/random without blocking if some other application has previously
> read 10 Kilobytes from /dev/urandom.

/dev/urandom always leaves enough entropy in the input pool for
/dev/random to reseed. Thus, as long as entropy is coming in, it is
not possible for /dev/urandom readers to starve /dev/random readers.
But /dev/random readers may still block temporarily and they should
damn well expect to block if they read 500 bytes out of a 512 byte
pool.

-- 
Mathematics is the supreme nostalgia of our time.
