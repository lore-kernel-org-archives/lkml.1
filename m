Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab0BDHKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 02:10:40 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41403 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab0BDHKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 02:10:39 -0500
Date: Thu, 4 Feb 2010 18:10:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: linux-next: driver-core tree build warning
Message-Id: <20100204181032.1b5cbfb2.sfr@canb.auug.org.au>
In-Reply-To: <20100203022247.GA11904@kroah.com>
References: <20100119172741.2dd81553.sfr@canb.auug.org.au>
	<20100119210417.GC10928@kroah.com>
	<20100120104525.752a790f.sfr@canb.auug.org.au>
	<20100120172543.e884a8af.sfr@canb.auug.org.au>
	<20100120174441.e1b12fd7.sfr@canb.auug.org.au>
	<20100121231010.GB29796@kroah.com>
	<20100129182115.99918a0e.sfr@canb.auug.org.au>
	<20100203022247.GA11904@kroah.com>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__4_Feb_2010_18_10_32_+1100__/b=AmP+JDX/Lk_4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Feb_2010_18_10_32_+1100__/b=AmP+JDX/Lk_4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 2 Feb 2010 18:22:47 -0800 Greg KH <greg@kroah.com> wrote:
>
> On Fri, Jan 29, 2010 at 06:21:15PM +1100, Stephen Rothwell wrote:
> >=20
> > > -static CLASS_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
> > > -static CLASS_ATTR(release, S_IWUSR, NULL, cpu_release_store);
> > > +static SYSDEV_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
> >=20
> > This defines attr_probe as a "struct sysdev_attribute" whose attr eleme=
nt
> > is a "struct attribute".
> >=20
> > > +static SYSDEV_ATTR(release, S_IWUSR, NULL, cpu_release_store);
> > >  #endif /* CONFIG_ARCH_CPU_PROBE_RELEASE */
> > > =20
> > >  #else /* ... !CONFIG_HOTPLUG_CPU */
> > > @@ -261,8 +261,8 @@ int __init cpu_dev_init(void)
> > > =20
> > >  static struct sysdev_class_attribute *cpu_sysdev_class_attrs[] =3D {
> > >  #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
> > > -	&class_attr_probe.attr,
> > > -	&class_attr_release.attr,
> > > +	&attr_probe.attr,
> >=20
> > so here we are initialising a "struct sysdev_class_attribute *" with a
> > "struct attribute *".  Thus the warning.
>=20
> Doh, sorry about that.  I've fixed it up now and pushed it out.

Still not right :-( &attr_probe and &attr_release are "struct
sysdev_attribute *" after this patch, but are being assigned to "struct
sysdev_class_attribute *" ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__4_Feb_2010_18_10_32_+1100__/b=AmP+JDX/Lk_4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktqcugACgkQjjKRsyhoI8yR/QCgqDvuA6z5ZgPWLOZBODKo45li
4EYAnR3JV+qaTJijerd/UJrfcEHWPlNw
=UGfJ
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Feb_2010_18_10_32_+1100__/b=AmP+JDX/Lk_4--
