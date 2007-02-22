Return-Path: <linux-kernel-owner+w=401wt.eu-S1751805AbXBVTvC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbXBVTvC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 14:51:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXBVTvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 14:51:01 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:53710 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbXBVTvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 14:51:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Sender:Reply-To;
	b=N2hsLH1uL1lSni/jFWUW8mR/StegzW0zf3ydIj1q+sZ3qjGlzVB8ldAMjee+IDFqxvH3uSsGpAWG2+sLifMLjP+BtSyBbl/rhrsz8+zwb4QJReGF1q0vvB/tPbUthSPR;
Message-ID: <45DDF3EA.3040407@simon.arlott.org.uk>
Date: Thu, 22 Feb 2007 19:50:02 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Duncan Sands <duncan.sands@math.u-psud.fr>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] usbatm: Increment module refcount when atm device
 is opened.
References: <45DCBB4E.8000502@simon.arlott.org.uk> <200702221048.01623.duncan.sands@math.u-psud.fr>
In-Reply-To: <200702221048.01623.duncan.sands@math.u-psud.fr>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig1E513409FFEF6EAE1C35371A"
Reply-To: Simon Arlott <9b8ea2f16ca756b7641hkjxy0006dn1i@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1E513409FFEF6EAE1C35371A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 22/02/07 09:48, Duncan Sands wrote:
> What for?  Did you see any problems with the way it works right now?

It didn't make sense to be able to unload a module while it's actually in=
 use, how does this work with automatic module loading/unloading (althoug=
h I can't see how it's going to automatically load one of the sub drivers=
=2E..)?


> How it works now is that if the module is unloaded while the device is
> in use, then the device is deregistered from the USB and ATM layers
> before the module unload completes.  Thus there should be no problem
> unloading the device at any moment. =20
Ok.


> I'm guessing that you want this because of the better proc support you
> would like to add, which adds an extra callback into the module.

Actually it was partly because of the urb warning messages on unload... w=
hich the change doesn't even affect.


> This too should cause no problems as long as the appropriate tweaks are=

> made to the shutdown code. I plan to make those adjustments, but I didn=
't
> find time yet - sorry.

I intend to export all the data via sysfs instead, since the current meth=
od of using proc (requiring several large enough read()s and no seeking) =
isn't very good and I can't see any way to improve it without caching the=
 whole output from file open to close which atm doesn't support.

I was thinking that the MAC address/AAL stats should be removed from the =
proc output since they're already available from the atm devices proc fil=
e?


> PS: I plan to work on the drivers this weekend.

I don't expect to require any changes to usbatm to support sysfs, since t=
he attributes should go with the usb device itself (and not the atm devic=
e). Perhaps there could be symlinks in each direction between the usb dev=
ice and the atm device (like dvb/v4l do, e.g. atm:cxacru0 in the usb devi=
ce)?

--=20
Simon Arlott


--------------enig1E513409FFEF6EAE1C35371A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iQIVAwUBRd3z7aRtx1WjQ8ihAQrrAhAApDV21kkNH8XZUxOjpRK2V9zmoFi+Ob9p
0shFy12bEuG+cWiXhDFr7MHTEKyEsAVWuDX66IPAL1DwSxSOeBIs6qPd5cLLY+sl
VnWWtaUs71yIz3qBziT63ZV7DgxDJofuksYIQfYBLFW4Z5ws2PiE6KzbhiyIPpwM
Un4WfSHrEeyDWazDgJhgRonyCRHn/YegrrVhZvNDC3unC1kfH76EXT0CxrmvBs/j
ZmV5XRprYEpltrL8tRLZS6z2RnGU3AKwqNVQyXbypwFA6/XYj3DEGVmyqp/dRU5R
y7hdwR6Xw9Ow7hIDYr+3+NGHopggZZ+LQBgtd7yRunvmemjAwY4wt+bnZSyHQskE
3ZIt6UU3lVGPseyoeVKsoCqjarKSoeOUGPLqwJgz/48yuB8dQfPclvqMAhJhQRmb
aXoJS5wEJTdap9d+kIJ50V4v9qVy+2SgTF8/zDp6LIjmxV2gx87fE+VT0OxfsU6n
2s2E0SlQT2NjroL7jAQAqI7nKlJ9CSHsk1jCtamBh/nz2auO0tancNubfHALXxD8
W8RFfrS9l81E6mypx/aW1qGIbb6ZWROTsqFxlFxDacLOb1vGKuDuY9eKipviaZNx
K0pAeaSFYqWWOFyQU/llWV1gEeAmYQdWGJSCN86tIGxs59v3sd9Rr4neprgPDiM3
XfFWvLFUy5I=
=paif
-----END PGP SIGNATURE-----

--------------enig1E513409FFEF6EAE1C35371A--
