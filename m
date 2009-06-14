Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbZFNT7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbZFNT7D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 15:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZFNT6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 15:58:53 -0400
Received: from keetweej.vanheusden.com ([80.126.110.251]:45289 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbZFNT6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 15:58:53 -0400
Date: Sun, 14 Jun 2009 21:58:54 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: issue with /dev/random? gets depleted very quick
Message-ID: <20090614195854.GD7272@vanheusden.com>
References: <20090614125138.GZ7272@vanheusden.com> <1244994669.4496.229.camel@calx> <20090614190417.GC7272@vanheusden.com> <1245008055.4496.255.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1245008055.4496.255.camel@calx>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Tue Jun  9 20:35:32 CEST 2009
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ /dev/random gets emptied very quickly ]
...
> > > Is this a problem? It really shouldn't be. Everyone should be
> > > using /dev/urandom anyway. And the anti-starvation threshold guarantees
> > 
> > Well, if I understood correctly how /dev/*random works, urandom is fed
> > by /dev/random. So if there's almost nothing left in the main pool and
> > urandom demands bits then we have an issue.
> > Also, if you frequently want to generate keys (thing gpg, ssl), I think
> > you want bits from /dev/random and not urandom.
> 
> There is really no difference.
> In an ideal world, we could accurately estimate input entropy and thus
> guarantee that we never output more than we took in. But it's pretty
> clear we don't have a solid theoretical basis for estimating the real
> entropy in most, if not all, of our input devices. In fact, I'm pretty
> sure they're all significantly more observable than we're giving them
> credit for. And without that basis, we can only make handwaving
> arguments about the relative strength of /dev/random vs /dev/urandom.
> So if you're running into /dev/random blocking, my advice is to delete
> the device and symlink it to /dev/urandom.

Two questions:
- if the device gets empty constantly, that means that filling
  applicaties (e.g. the ones that feed /dev/random from /dev/hwrng or
  from an audio-source or whatever)
- if we don't know if we're accounting correctly, why doing at all?
  especially if one should use urandom instead of random

> Also note that if something in the kernel is rapidly consuming entropy
> but not visibly leaking it to the world, it is effectively not consuming
> it.

Then the counter should not be decreased?

> In this case, if no one hears the tree fall, it hasn't actually fallen.
> There is exactly as much 'unknown' data in the entropy pool as before.
> If anything, the pool contents are now harder to guess because it's been
> mixed more.


Folkert van Heusden

-- 
MultiTail ist eine flexible Applikation um Logfiles und Kommando
Eingaben zu überprüfen. Inkl. Filter, Farben, Zusammenführen,
Ansichten etc. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
