Return-Path: <linux-kernel-owner+w=401wt.eu-S1759601AbZFBHTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601AbZFBHTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbZFBHT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:19:27 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:38819 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199AbZFBHT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:19:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=eebZ8A/S+6Y00ce10Bf+LlJ4ALwLU/lBKCRLsMngpjgcfU69xy9qGEs3GUOzoT4F1V
         ryhTlnAMFNCbGyP2gVHf3ykTUCwBtH07NVqggelK6AkT+m0a7aLSdVPYiOjYJoL103BC
         tZ6tDKYTO9CTgMFcPOBOOeoGVMFMMDcyZoO+w=
From: Florian Fainelli <florian@openwrt.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/9] kernel: export sound/core/pcm_timer.c gcd implementation
Date: Tue, 2 Jun 2009 09:19:22 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
       linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200906011357.09966.florian@openwrt.org> <20090601215034.7352ddca.akpm@linux-foundation.org>
In-Reply-To: <20090601215034.7352ddca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1733965.8q685CKkAD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200906020919.25162.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1733965.8q685CKkAD
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le Tuesday 02 June 2009 06:50:34 Andrew Morton, vous avez =E9crit=A0:
> On Mon, 1 Jun 2009 13:57:09 +0200 Florian Fainelli <florian@openwrt.org>=
=20
wrote:
> > This patch exports the gcd implementation from
> > sound/core/pcm_timer.c into include/linux/kernel.h.
> > AR7 uses it in its clock routines.
> >
> > ...
> >
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > index 883cd44..878a27a 100644
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -147,6 +147,22 @@ extern int _cond_resched(void);
> >  		(__x < 0) ? -__x : __x;		\
> >  	})
> >
> > +/* Greatest common divisor */
> > +static inline unsigned long gcd(unsigned long a, unsigned long b)
> > +{
> > +        unsigned long r;
> > +        if (a < b) {
> > +                r =3D a;
> > +                a =3D b;
> > +                b =3D r;
> > +        }
> > +        while ((r =3D a % b) !=3D 0) {
> > +                a =3D b;
> > +                b =3D r;
> > +        }
> > +        return b;
> > +}
>
> a) the name's a bit sucky.   Is there some convention for this name?

We might want something better like greatest_common_divisor which is a bit=
=20
more self-explanatory ?

>
> b) It looks too large to be inlined.  lib/gdc.c?

And its users select it in order not to increase the size of kernel.h, soun=
ds=20
good.

>
> b) there's an implementation of gcd() in
>    net/netfilter/ipvs/ip_vs_wrr.c.  I expect that this patch broke the
>    build.

I did forget about this. That gcd implementation only treats the a > b case.

What do you prefer, each user keeps its gcd implementation locally or we ma=
ke=20
a lib/gcd.c for it ?

Thanks
=2D-=20
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
=2D------------------------------

--nextPart1733965.8q685CKkAD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkok0nsACgkQlyvkmBGtjyYOSQCgl2miLsK5IoByk8+x64m8/F9s
vNwAoKHAoFAWk6L5hN3P8c8uAdtmp3Gn
=gSD5
-----END PGP SIGNATURE-----

--nextPart1733965.8q685CKkAD--
