Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbYEILAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbYEILAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbYEIK74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 06:59:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:50047 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754512AbYEIK7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 06:59:24 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18oGChlcWco9DaGXZF7VoFn7SoqeDew/HUQLeb/Pz
	eZgtWNin7vWmtJ
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager: multiple definition of `phys_cpu_present_map'
Date: Fri, 9 May 2008 12:59:17 +0200
User-Agent: KMail/1.9.7
Cc: WANG Cong <xiyou.wangcong@gmail.com>,
       James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Travis <travis@sgi.com>
References: <200805091114.00244.toralf.foerster@gmx.de> <20080509095244.GJ2543@hacking> <20080509095837.GB19617@elte.hu>
In-Reply-To: <20080509095837.GB19617@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2807215.df2VtrSccn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200805091259.20126.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2807215.df2VtrSccn
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

At Friday 09 May 2008 11:58:37 Ingo Molnar wrote :
>=20
> * WANG Cong <xiyou.wangcong@gmail.com> wrote:
>=20
> > Sorry. Ignore previous one. This one should be correct, I think.
> >=20
> > ---
> >=20
> > diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyage=
r/voyager_smp.c
> > index 8acbf0c..2e8388b 100644
> > --- a/arch/x86/mach-voyager/voyager_smp.c
> > +++ b/arch/x86/mach-voyager/voyager_smp.c
> > @@ -74,7 +74,7 @@ EXPORT_SYMBOL(cpu_online_map);
> > =20
> >  /* Bitmask of CPUs present in the system - exported by i386_syms.c, us=
ed
> >   * by scheduler but indexed physically */
> > -cpumask_t phys_cpu_present_map =3D CPU_MASK_NONE;
> > +static cpumask_t phys_cpu_present_map =3D CPU_MASK_NONE;
>=20
> i've got the one below queued up but it's stalled as it could easily be=20
> wrong and there's no ack from James yet and there's been discussion back=
=20
> and forth. James, what do you suggest?
>=20
tested config with this patch, again it solves the issue and I got now (as =
expected) :
=2E..
  OBJCOPY arch/x86/boot/setup.bin
  OBJCOPY arch/x86/boot/vmlinux.bin
  HOSTCC  arch/x86/boot/tools/build
  BUILD   arch/x86/boot/bzImage
Root device is (3, 8)
Setup is 11288 bytes (padded to 11776 bytes).
System is 1536 kB
CRC 68d1dbe1
Kernel: arch/x86/boot/bzImage is ready  (#15)
  Building modules, stage 2.
  MODPOST 156 modules
ERROR: "i2c_master_send" [drivers/media/video/tuner.ko] undefined!
ERROR: "i2c_detach_client" [drivers/media/video/tuner.ko] undefined!
ERROR: "i2c_del_driver" [drivers/media/video/tuner.ko] undefined!
ERROR: "v4l2_i2c_attach" [drivers/media/video/tuner.ko] undefined!
ERROR: "i2c_register_driver" [drivers/media/video/tuner.ko] undefined!
ERROR: "i2c_master_recv" [drivers/media/video/tuner.ko] undefined!
ERROR: "i2c_probe" [drivers/media/video/tuner.ko] undefined!
ERROR: "i2c_transfer" [drivers/media/common/tuners/xc5000.ko] undefined!
ERROR: "i2c_transfer" [drivers/media/common/tuners/tuner-xc2028.ko] undefin=
ed!
ERROR: "i2c_transfer" [drivers/media/common/tuners/tuner-simple.ko] undefin=
ed!
ERROR: "i2c_clients_command" [drivers/media/common/tuners/tuner-simple.ko] =
undefined!
ERROR: "i2c_transfer" [drivers/media/common/tuners/tea5767.ko] undefined!
ERROR: "i2c_transfer" [drivers/media/common/tuners/tea5761.ko] undefined!
ERROR: "i2c_transfer" [drivers/media/common/tuners/tda9887.ko] undefined!
ERROR: "i2c_transfer" [drivers/media/common/tuners/tda8290.ko] undefined!
ERROR: "i2c_transfer" [drivers/media/common/tuners/mt20xx.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2


> 	Ingo
>=20
> -------------------->
> Subject: x86, voyager: build fix
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sun May 04 23:56:30 CEST 2008
>=20
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/mach-voyager/voyager_smp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> Index: linux-x86.q/arch/x86/mach-voyager/voyager_smp.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-x86.q.orig/arch/x86/mach-voyager/voyager_smp.c
> +++ linux-x86.q/arch/x86/mach-voyager/voyager_smp.c
> @@ -74,7 +74,7 @@ EXPORT_SYMBOL(cpu_online_map);
> =20
>  /* Bitmask of CPUs present in the system - exported by i386_syms.c, used
>   * by scheduler but indexed physically */
> -cpumask_t phys_cpu_present_map =3D CPU_MASK_NONE;
> +extern cpumask_t phys_cpu_present_map;
> =20
>  /* The internal functions */
>  static void send_CPI(__u32 cpuset, __u8 cpi);
>=20



=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart2807215.df2VtrSccn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkgkLogACgkQhyrlCH22naMy/ACfbyBtgjXKIXsOBpWiYfPqYdYg
q1gAoL7awV3dcFNuaMKfM/6FLDYqtUss
=6zAL
-----END PGP SIGNATURE-----

--nextPart2807215.df2VtrSccn--
