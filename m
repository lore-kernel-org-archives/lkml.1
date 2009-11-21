Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbZKUKIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbZKUKIb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 05:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZKUKIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 05:08:30 -0500
Received: from nn7.de ([85.214.94.156]:52350 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbZKUKI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 05:08:29 -0500
Subject: Re: [SOLVED] kernel module loading does not work with
 binutils-gold (was Re: [Bug #14626] oops on boot starting udev)
From: Soeren Sonnenburg <sonne@debian.org>
To: "Justin P\. Mattock" <justinmattock@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Greg KH <greg@kroah.com>,
       "Rafael J\. Wysocki" <rjw@sisk.pl>, linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <4B07B9BA.2070607@gmail.com>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
	 <xXQGFmujPl.A.fpF.zSdALB@chimera> <20091117011455.GA7977@kroah.com>
	 <20091117020451.GA27967@core.coreip.homeip.net>
	 <1258426743.9883.53.camel@no>
	 <20091117040104.GA5792@core.coreip.homeip.net>
	 <1258430807.12721.12.camel@no>
	 <20091119025938.GB20172@core.coreip.homeip.net>
	 <1258793809.4814.4.camel@no> <1258796110.6842.10.camel@no>
	 <4B07B9BA.2070607@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-APHzIMw1WrAiONaNJrOF"
Date: Sat, 21 Nov 2009 11:08:33 +0100
Message-ID: <1258798113.6842.16.camel@no>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-APHzIMw1WrAiONaNJrOF
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-11-21 at 01:58 -0800, Justin P. Mattock wrote:
> Soeren Sonnenburg wrote:
> > On Sat, 2009-11-21 at 09:56 +0100, Soeren Sonnenburg wrote:
> >   =20
> >> On Wed, 2009-11-18 at 18:59 -0800, Dmitry Torokhov wrote:
> >>     =20
> >>> On Tue, Nov 17, 2009 at 05:06:47AM +0100, Soeren Sonnenburg wrote:
> >>>       =20
> >>>> On Mon, 2009-11-16 at 20:01 -0800, Dmitry Torokhov wrote:
> >>>>         =20
> >>>>> On Tue, Nov 17, 2009 at 03:59:03AM +0100, Soeren Sonnenburg wrote:
> >>>>>           =20
> >>>>>> On Mon, 2009-11-16 at 18:04 -0800, Dmitry Torokhov wrote:
> >>>>>>             =20
> >>>>>>> On Mon, Nov 16, 2009 at 05:14:55PM -0800, Greg KH wrote:
> >>>>>>>               =20
> >>>>>>>> On Mon, Nov 16, 2009 at 11:37:48PM +0100, Rafael J. Wysocki wrot=
e:
> >>>>>>>>                 =20
> >>>>>>>>> This message has been generated automatically as a part of a re=
port
> >>>>>>>>> of recent regressions.
> >>>>>>>>>
> >>>>>>>>> The following bug entry is on the current list of known regress=
ions
> >>>>>>>>> from 2.6.31.  Please verify if it still should be listed and le=
t me know
> >>>>>>>>> (either way).
> >>>>>>>>>
> >>>>>>>>>
> >>>>>>>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14626
> >>>>>>>>> Subject		: oops on boot starting udev
> >>>>>>>>> Submitter	: Soeren Sonnenburg<sonne@debian.org>
> >>>>>>>>> Date		: 2009-11-14 10:16 (3 days old)
> >>>>>>>>> References	: http://marc.info/?l=3Dlinux-kernel&m=3D12581938020=
6800&w=3D4
> >>>>>>>>>                   =20
> >>>>>>>> This looks like an input core problem, as the evdev module was j=
ust
> >>>>>>>> loaded and died.
> >>>>>>>>
> >>>>>>>> Any input developers have any ideas?
> >>>>>>>>
> >>>>>>>>                 =20
> >>>>>>> Hmm, evdev does:
> >>>>>>>
> >>>>>>> 	dev_set_name(&evdev->dev, "event%d", minor);
> >>>>>>>
> >>>>>>> Not sure how it can go wrong...
> >>>>>>>               =20
> >>>>>> Anything I should/could do to narrow it down a bit (apart from
> >>>>>> bisecting?).
> >>>>>>
> >>>>>>             =20
> >>>>> Umm, I looked through the changes between -rc6 and 7 but nothing ju=
mped
> >>>>> out at me... You don't happen to have any local changes in your tre=
e?
> >>>>>           =20
> >>>> Well only the mouse button #1 emulation - though I don't see what co=
uld
> >>>> go wrong there.
> >>>>
> >>>>         =20
> >>> I have been looking through the changes and I really don't see anythi=
ng
> >>> suspicious. I am also not hittign this oops on any of my boxes. Any
> >>> chance you could bisect?
> >>>
> >>> Thanks.
> >>>       =20
> >> Alright so I tried to do a bisect when I noticed that building a knwon
> >> to work -rc5 did no longer work either. Thought it might be a gcc
> >> problem (gcc-4.3 here) so upgraded to 4.4 - same thing.
> >> Then I recognized that it crashes on loading basically *any* module,
> >> tried tun and applesmc. Attaching the crashes...
> >>
> >> I am starting to run out of ideas...
> >>     =20
> >
> > OK, I've found the culprit: binutils-gold
> >
> > I build all kernels upto and including -rc6 with the old binutils and
> > since then have upgraded to binutils gold 2.20-4 which - in contrast to
> > the old binutils - uses --no-add-needed per default.
> >
> > So I suspect it triggers an error(?) in the way how the kernel links
> > modules: It is now required to provide all needed libraries to the
> > linker when building the modules. I guess this problem could be worked
> > around by adding --add-needed to the LDFLAGS_MODULE ...
> >
> > Soeren
> >   =20
> tough to say... some how your hitting
>   __wait_status during your initial boot.
>=20
> by looking at the comment(in applesmc.c):
> __wait_status - Wait up to 32ms for the status port to get a certain valu=
e
>   * (masked with 0x0f), returning zero if the value is obtained.
>=20
> maybe your hitting a different value because of binutls.

It could be anything missing...

> (keep in mind I have the latest binutils running on the macbook,
> but nothing switched to gold during compilation time)

Note that everything works fine with the old binutils here too.You will
need binutils gold to see the problem and it is described here too

http://wiki.debian.org/qa.debian.org/FTBFS#A2009-11-02Packagesfailingbecaus=
ebinutils-gold.2BAC8-indirectlinking

Soeren
--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-APHzIMw1WrAiONaNJrOF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJLB7waAAoJEH82z1Wqh6p3xG8P/24oHzsWK9T+iwLlFXvb6PyE
u024UywR0xkHOLI10AOauap9L4w/gBlgSn/48qRZ1oCLvqcfl7fzbBx/Evbkqx6R
j1fRZXE9Y7EWSJ+zmPCQNHgvdxXN5cD/g8TwCWXy3DZ7HZ/+ZFG3OEiPDgxY9sQe
cSjMjSbu93Xv29070BD8k8IuE/GSENjBjAnv7yd0gKuICLWCJ8XQF15YKHlB4QQy
4H+EN2SqIoIYAK7jmQ57BwbKZttGWbsegsIXlQ1k8TzTGIhXeqYEhMxk5RKHVgjz
zjT8hhsdOs+3dWK9D9RIs+7D+RuyCL+ZSXRa3EMDJSiRPZK6h/G1wZ3DBfxzMYN3
ASOfq0sMWKwlzfY3hwiV8+bg5z9T64GNryvUeaEbpHZT5QzqfxxxaYfC4xk1gKby
FC7JxlY8D+h9jDd0AMERRWYB4J34HPE1Qx1Ljdp9oNR5Z53zKHSB+TmtrL6RYKjr
5FUmWPSAStVrknhevhf1ggtSmQmpV9npxsgtmf/f4za5d8R3rzTj4R5zBRcsAjCk
4XiOkHag8HZ/If3MS9tC0cQy34QdovJn+RteO0cohSD786JCly0Y8YvVF27eNlpP
jeBsGb10gx54EvkpLBHU1vUQ+1viV7XXWPpK/qC3b7k8TBRkhJ2kYcocgDLLCoXA
JGcl7KVMtzz60+4S5kKJ
=zd0X
-----END PGP SIGNATURE-----

--=-APHzIMw1WrAiONaNJrOF--
