Return-Path: <linux-kernel-owner+w=401wt.eu-S1759837AbZDWVST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837AbZDWVST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756462AbZDWVSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:18:04 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:52989 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbZDWVSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:18:01 -0400
Date: Thu, 23 Apr 2009 18:17:55 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, e1000-devel@lists.sourceforge.net,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [E1000-devel] e1000: "eeprom checksum is not valid" after kexec
Message-ID: <20090423211754.GD4017@vespa.holoscopio.com>
References: <49F06EEB.9060500@gmail.com> <20090423141026.GB4046@vespa.holoscopio.com> <49F07B69.1020305@gmail.com> <20090423144145.GA3749@vespa.holoscopio.com> <49F0D22E.6050101@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vEao7xgI/oilGqZ+"
Content-Disposition: inline
In-Reply-To: <49F0D22E.6050101@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vEao7xgI/oilGqZ+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 23, 2009 at 10:40:14PM +0200, Jiri Slaby wrote:
> On 04/23/2009 04:41 PM, Thadeu Lima de Souza Cascardo wrote:
> > On Thu, Apr 23, 2009 at 04:30:01PM +0200, Jiri Slaby wrote:
> >> On 04/23/2009 04:10 PM, Thadeu Lima de Souza Cascardo wrote:
> >>> Have you tried b43fcd7dc7b, found in v2.6.30-rc3?
> >> I've tried 2.6.30-rc3-next-20090423 without success.
> >=20
> > You mean next-20090423. The patch is really found there.
> >=20
> > But, then, I realize you mean reverting these patches for the kernel
> > that is running or the kernel that is being kexec'd?
>=20
> The latter.
>=20
> > If b43fcd7dc7b is applied to the running kernel, it fixes the shutdown
> > issue, and the next loaded kernel probes e1000 fine.
>=20
> Makes sense.
>=20
> > If you are reverting 4a865905f in the kexec'd kernel and the running
> > kernel does not have b43fcd7dc7b, then I'd like to test the revert for
> > my case here, which is e100.
>=20
> To make things clear: on that machine, there was stock opensuse 11.1
> distro kernel which is 2.6.27-based (no b43fcd7dc7b). I needed to debug
> a wireless bug, so I kexec'ed wireless-testing (contains 4a865905f alread=
y).
>=20
> So in fact, 4a865905f from the testing kernel triggered a bug fixed in
> near past by b43fcd7dc7b.
>=20
> Did the other two e100* drivers suffer from the same and were fixed
> recently? It would render kexec pretty unusable from the older kernels
> if this is not going to be fixed anyhow :(.

Yes, as well as some other network drivers, it seems. My fix for e100
should be in Jeffrey Kirsher's tree by now and go into netdev and rc4
soon, I expect.

But, since I also thought that it would be good to fix that and allow
people to kexec from earlier kernels, I did a followup to e100-devel,
linux-pci, netdev and Rafael Wysocki. I didn't include linux-kernel,
which I have just fixed, bouncing the message (oops!). I may bounce it
to you too, if you want that.

Your findings shed a light into that problem. But I could find it in
very early kernels too for some configurations, and these commits you
are reverting may only fix the issue for the most common configurations
out there. That is, it was very easy to trigger the shutdown bug with
these patches. But I think there are some other bugs out there that will
trigger it, and they are not that easy bisecting, it seems, since only
some very particular configurations trigger it.

I will do some tests with the commits you mention and reproduce the
problem using as earlier kernels as I can and send the config.

Regards,
Cascardo.

--vEao7xgI/oilGqZ+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknw2wIACgkQyTpryRcqtS3O4ACdEyY+/fqj/BWzEWnBH2Rl3kmg
95wAn2SYOsQ3zebP+IBKC3FFtiW3RhG7
=Wela
-----END PGP SIGNATURE-----

--vEao7xgI/oilGqZ+--
