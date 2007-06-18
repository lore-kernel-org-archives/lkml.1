Return-Path: <linux-kernel-owner+w=401wt.eu-S1763520AbXFROCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763520AbXFROCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 10:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762239AbXFROCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 10:02:14 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57728 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762151AbXFROCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 10:02:13 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] use __asm__ and __volatile__ in asm-x86_64/msr.h
Date: Mon, 18 Jun 2007 10:02:21 -0400
User-Agent: KMail/1.9.7
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de
References: <200706180209.36762.vapier@gentoo.org> <467635D8.5060202@zytor.com>
In-Reply-To: <467635D8.5060202@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1483978.vGqpevEMar";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706181002.21978.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1483978.vGqpevEMar
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 18 June 2007, H. Peter Anvin wrote:
> Mike Frysinger wrote:
> > Most of the macros in msr.h already use __asm__ and __volatile__, this
> > patch brings the rest into line.  This is needed since these get export=
ed
> > into userspace (need to use strict __asm__ vs asm when gcc compiles with
> > GNU extensions turned off).
> > ---
> > diff --git a/include/asm-x86_64/msr.h b/include/asm-x86_64/msr.h
> > index d5c55b8..ed15d2b 100644
> > --- a/include/asm-x86_64/msr.h
> > +++ b/include/asm-x86_64/msr.h
> > @@ -33,7 +33,7 @@
> >
> >  /* wrmsr with exception handling */
> >  #define wrmsr_safe(msr,a,b) ({ int ret__;			\
> > -	asm volatile("2: wrmsr ; xorl %0,%0\n"			\
> > +	__asm__ __volatile__("2: wrmsr ; xorl %0,%0\n"			\
> >  		     "1:\n\t"					\
> >  		     ".section .fixup,\"ax\"\n\t"		\
> >  		     "3:  movl %4,%0 ; jmp 1b\n\t"		\
> > @@ -50,7 +50,7 @@
> >
> >  #define rdmsr_safe(msr,a,b) \
> >  	({ int ret__;						\
> > -	  asm volatile ("1:       rdmsr\n"			\
> > +	  __asm__ __volatile__ ("1:       rdmsr\n"			\
> >                        "2:\n"					\
> >                        ".section .fixup,\"ax\"\n"		\
> >                        "3:       movl %4,%0\n"			\
>
> NAK.
>
> This is wrong for two reasons:
>
> - MSRs are not accessible in user space.
> - .section .fixup is not applicable to user space.
>
> Anything MSR-related should be protected by __KERNEL__ instead.
>
> This NAK doesn't apply to rdtsc* and rdpmc* changes, however, as those
> instructions are legitimate in userspace.

then someone needs to audit msr.h for this because currently it lacks=20
__KERNEL__ of any kind yet is exported completely to userspace ... i dont=20
know anything about this instructions so that someone !=3D me

this is similar to what i heard last time i tried to fixup msr.h for=20
userspace, but the file still hasnt been updated ...
=2Dmike

--nextPart1483978.vGqpevEMar
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iQIVAwUARnaQbUFjO5/oN/WBAQLBIRAAgt3ro/SQcyYBc5fV/dBepTc2bCarfyaY
DXxFR+Od7lmj2iy39/hSLTC/RcZXZnfeYxwdPaoTF/clgwvz+UvWjGRcCKc1NMBY
bjvGeoUg8Jx1elHil6Pqm/UxHdyhMaSQzfFQoQ121bJLhAvdgObF8KrPQhVrJrLA
sJamxcHBib930rlDVibegNM/UKiDfJLJkrV4eygPeNfBsmD0Vfm88+rcjberuKQ3
5SoxyIjFAfhhF4fPqztS6btKaTcE/vloHwvctnmlqzwY+/rH65OD6+yACaSezxdl
MR5psIUIGudIqoZ8ogP1dl+X1XwC+MLOofRAFiDC+KnYRk0CSFhFG5TEspZ0Qqmx
B8NyQY7keR+sJI70CZ/DdyD1HN2CmcBqIeo3WYDbTt3ZKXncn7BLr2gaScqZY/hT
rR0kWXLg0B3MexuHHxHeHoIYRJ9ZxrIW6VAXIijqjJ3fTnE1Fe8yAYm59Y4tShod
k/ZeQ7LeEXk8w5xgx0C1Czc2uo0Ih3kKRLuncBGli99vB+UjCdtzQRVR6OIHsC/0
AtBqV6QlWjQ93JRAQ9V0dKCruHoESOHEoy+MoNGWg3hjvZISFukezTnVUgkNaEEE
KHGKJV7df9uTSxwoUEqHgxfVV/RdpHJCdHZx37HSPfIBzFC66nZpBOiRXIzb+0RK
FYfJjZ27wvI=
=ev1Z
-----END PGP SIGNATURE-----

--nextPart1483978.vGqpevEMar--
