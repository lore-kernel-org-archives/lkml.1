Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbZCOX3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbZCOX3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 19:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757137AbZCOX2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 19:28:53 -0400
Received: from ozlabs.org ([203.10.76.45]:60520 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbZCOX2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 19:28:52 -0400
Subject: Re: more than 50 percent of dmesg belongs only to PCI and USB
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
       linux-pci <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1237016485.2935.12.camel@ht.satnam>
References: <1237016485.2935.12.camel@ht.satnam>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-G+PDcNMIkOitsOnDNzX+"
Date: Mon, 16 Mar 2009 10:28:49 +1100
Message-Id: <1237159729.8619.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-G+PDcNMIkOitsOnDNzX+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-14 at 13:11 +0530, Jaswinder Singh Rajput wrote:
> Can we make dmesg little bit better and remove some noise and put these
> debug messages on /sys/kernel/debug/ :

I think they should just be KERN_DEBUG, that way they won't be displayed
to most users, except people who want to see them.

The problem is it's easier to write:

  dev_info(&dev->dev, "transparent bridge\n");

than:

  dev_printk(KERN_DEBUG, &dev->dev, "transparent bridge\n");

and, dev_dbg() does not do what you want in this case.


What about:

#define dev_quietly(dev, format, arg...)            \
        dev_printk(KERN_DEBUG , dev , format , ## arg)

:)

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-G+PDcNMIkOitsOnDNzX+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm9jzEACgkQdSjSd0sB4dK0SgCeKoxjqzSeheIk/eR8yMaMBt1D
Q28AoKsQ6pcLHI+3mnYwrCosjjfVVSot
=s32B
-----END PGP SIGNATURE-----

--=-G+PDcNMIkOitsOnDNzX+--

