Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622Ab0ATGZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab0ATGZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 01:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109Ab0ATGZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 01:25:50 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48149 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab0ATGZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 01:25:49 -0500
Date: Wed, 20 Jan 2010 17:25:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: linux-next: driver-core tree build warning
Message-Id: <20100120172543.e884a8af.sfr@canb.auug.org.au>
In-Reply-To: <20100120104525.752a790f.sfr@canb.auug.org.au>
References: <20100119172741.2dd81553.sfr@canb.auug.org.au>
	<20100119210417.GC10928@kroah.com>
	<20100120104525.752a790f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Jan_2010_17_25_43_+1100_BhMZ_Om4Cd35fxxZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Jan_2010_17_25_43_+1100_BhMZ_Om4Cd35fxxZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 20 Jan 2010 10:45:25 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Tue, 19 Jan 2010 13:04:17 -0800 Greg KH <greg@kroah.com> wrote:
> >
> > On Tue, Jan 19, 2010 at 05:27:41PM +1100, Stephen Rothwell wrote:
> > >=20
> > > Today's linux-next build (powerpc ppc64_defconfig) produced this warn=
ing:
> > >=20
> > > drivers/base/cpu.c:264: warning: initialization from incompatible poi=
nter type
> > > drivers/base/cpu.c:265: warning: initialization from incompatible poi=
nter type
> > >=20
> > > Introduced by commit 380567d3dc35a62f5cc0ec640a45dfc238238417 ("sysde=
v:
> > > Convert node driver")?
> >=20
> > No, I don't think that patch causes the warning, I can't duplicate it
> > here.
> >=20
> > I don't know what patch causes that problem, as I can't duplicate it in
> > my tree at all.  Maybe some 'const' patch snuck in from some other tree?
> >=20
> > strange,
>=20
> OK, if it is still there today, I will look deeper.

I still get those warnings.  The two referenced lines are added by the comm=
it above.  The relevant parts of the file (in the version I have) are:

(lines 98 and 99)
static CLASS_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
static CLASS_ATTR(release, S_IWUSR, NULL, cpu_release_store);

...

(lines 262-266)
static struct sysdev_class_attribute *cpu_sysdev_class_attrs[] =3D {
#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
        &class_attr_probe.attr,
        &class_attr_release.attr,
#endif


class_attr_probe.attr is a "struct attribute" not a "struct
sysdev_class_attribute".

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Jan_2010_17_25_43_+1100_BhMZ_Om4Cd35fxxZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktWoecACgkQjjKRsyhoI8w/RgCgsv49rilqOespBMnU18jdLH0P
mHAAoLPIOZbjtW6WM2kRASKtBXxrf7aO
=UGY/
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jan_2010_17_25_43_+1100_BhMZ_Om4Cd35fxxZ--
