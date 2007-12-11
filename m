Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbXLKBfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbXLKBfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 20:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbXLKBfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 20:35:15 -0500
Received: from thunk.org ([69.25.196.29]:55131 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbXLKBfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 20:35:13 -0500
Date: Mon, 10 Dec 2007 20:34:14 -0500
From: Theodore Tso <tytso@mit.edu>
To: Matt Mackall <mpm@selenic.com>
Cc: Marc Haber <mh+linux-kernel@zugschlus.de>,
       Eric Dumazet <dada1@cosmosbay.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071211013414.GS17037@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Matt Mackall <mpm@selenic.com>,
	Marc Haber <mh+linux-kernel@zugschlus.de>,
	Eric Dumazet <dada1@cosmosbay.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <20071204164720.6e4dc2c4@the-village.bc.nu> <475599D6.4030008@cosmosbay.com> <20071205212646.GP17536@waste.org> <20071209124200.GA31147@torres.zugschlus.de> <20071209161605.GX19691@waste.org> <20071210230643.GC32133@torres.zugschlus.de> <20071210233525.GK19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210233525.GK19691@waste.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 05:35:25PM -0600, Matt Mackall wrote:
> > I must have missed this. Can you please explain again? For a layman it
> > looks like a paranoid application cannot read 500 Bytes from
> > /dev/random without blocking if some other application has previously
> > read 10 Kilobytes from /dev/urandom.
> 
> /dev/urandom always leaves enough entropy in the input pool for
> /dev/random to reseed. Thus, as long as entropy is coming in, it is
> not possible for /dev/urandom readers to starve /dev/random readers.
> But /dev/random readers may still block temporarily and they should
> damn well expect to block if they read 500 bytes out of a 512 byte
> pool.

A paranoid application should only need to read ~500 bytes if it is
generating a long-term RSA private key, and in that case, it would do
well to use a non-blocking read, and if it can't get enough bytes, it
should prompt the user to move the mouse around or bang on the
keyboard.  /dev/random is *not* magic where you can assume that you
will always get an unlimited amount of good randomness.  Applications
who assume this are broken, and it has nothing to do with DOS attacks.

Note that even paranoid applicatons should not be using /dev/random
for session keys; again, /dev/random isn't magic, and entropy isn't
unlimited. Instead, such an application should pull 16 bytes or so,
and then use it to seed a cryptographic random number generator.

    	     	   	  		- Ted
