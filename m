Return-Path: <linux-kernel-owner+w=401wt.eu-S1762855AbZFNUWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762855AbZFNUWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZFNUWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:22:47 -0400
Received: from waste.org ([66.93.16.53]:43956 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbZFNUWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:22:47 -0400
Subject: Re: issue with /dev/random? gets depleted very quick
From: Matt Mackall <mpm@selenic.com>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090614195854.GD7272@vanheusden.com>
References: <20090614125138.GZ7272@vanheusden.com>
	 <1244994669.4496.229.camel@calx> <20090614190417.GC7272@vanheusden.com>
	 <1245008055.4496.255.camel@calx>  <20090614195854.GD7272@vanheusden.com>
Content-Type: text/plain
Date: Sun, 14 Jun 2009 15:22:23 -0500
Message-Id: <1245010943.4496.261.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-14 at 21:58 +0200, Folkert van Heusden wrote:
> [ /dev/random gets emptied very quickly ]
> ...
> > > > Is this a problem? It really shouldn't be. Everyone should be
> > > > using /dev/urandom anyway. And the anti-starvation threshold guarantees
> > > 
> > > Well, if I understood correctly how /dev/*random works, urandom is fed
> > > by /dev/random. So if there's almost nothing left in the main pool and
> > > urandom demands bits then we have an issue.
> > > Also, if you frequently want to generate keys (thing gpg, ssl), I think
> > > you want bits from /dev/random and not urandom.
> > 
> > There is really no difference.
> > In an ideal world, we could accurately estimate input entropy and thus
> > guarantee that we never output more than we took in. But it's pretty
> > clear we don't have a solid theoretical basis for estimating the real
> > entropy in most, if not all, of our input devices. In fact, I'm pretty
> > sure they're all significantly more observable than we're giving them
> > credit for. And without that basis, we can only make handwaving
> > arguments about the relative strength of /dev/random vs /dev/urandom.
> > So if you're running into /dev/random blocking, my advice is to delete
> > the device and symlink it to /dev/urandom.
> 
> Two questions:
> - if the device gets empty constantly, that means that filling
>   applicaties (e.g. the ones that feed /dev/random from /dev/hwrng or
>   from an audio-source or whatever)

This question appears incomplete. Also, your device is not 'getting
empty'.

> - if we don't know if we're accounting correctly, why doing at all?
>   especially if one should use urandom instead of random

Inertia.

> > Also note that if something in the kernel is rapidly consuming entropy
> > but not visibly leaking it to the world, it is effectively not consuming
> > it.
> 
> Then the counter should not be decreased?

There's no way for us to know. In other words, the counter isn't
terribly meaningful in either direction.

-- 
http://selenic.com : development and support for Mercurial and Linux


