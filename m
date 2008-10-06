Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbYJFBvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbYJFBvQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 21:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYJFBvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 21:51:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:44884 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbYJFBu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 21:50:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,365,1220252400"; 
   d="asc'?scan'208";a="623674252"
Subject: Re: [RFC PATCH] x86: make 64bit efi to use ioremap_cache for
	efi_ioremap
From: Huang Ying <ying.huang@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: huang ying <huang.ying.caritas@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <86802c440810051104o44f7a3bbu6b37d7727be46772@mail.gmail.com>
References: <1223101400-8819-1-git-send-email-yhlu.kernel@gmail.com>
	 <851fc09e0810040235g2ab97bdai612c0a2829f83f5c@mail.gmail.com>
	 <86802c440810041044m5b950721s8700bb6cd2fe75d@mail.gmail.com>
	 <851fc09e0810050156y114007e4hbdf3e6c5562004d3@mail.gmail.com>
	 <86802c440810051104o44f7a3bbu6b37d7727be46772@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8f1nkOt9BiocT4E5qRPf"
Date: Mon, 06 Oct 2008 09:50:27 +0800
Message-Id: <1223257827.5872.14.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8f1nkOt9BiocT4E5qRPf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-10-05 at 11:04 -0700, Yinghai Lu wrote:
> On Sun, Oct 5, 2008 at 1:56 AM, huang ying <huang.ying.caritas@gmail.com>=
 wrote:
> > On Sun, Oct 5, 2008 at 1:44 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> >> On Sat, Oct 4, 2008 at 2:35 AM, huang ying <huang.ying.caritas@gmail.c=
om> wrote:
> > [...]
> >>> Using __va and efi_ioremap() here is to make EFI support compatible
> >>> with kexec. Because EFI provide only efi_enter_virtual_mode(), no
> >>> efi_leave_virtual_mode(), we should make EFI runtime memory area
> >>> mapped to same virtual memory area in original kernel and kexeced
> >>> kernel, so that the EFI runtime services can be used in kexeced
> >>> kernel.
> >>
> >> so need to make efi range all under direct-mapping like E820-RAM?
> >
> > Some EFI runtime range is just some RAM area used by EFI runtime
> > services, they can be direct-mapped. Some EFI runtime range may be IO
> > MEM range used by EFI runtime services, it is possible that these IO
> > MEM range can not be direct-mapped. So I implement efi_ioremap() to
> > deal with them.
> >
>=20
> i'm confused.
>=20
> so
> --- linux-2.6.orig/arch/x86/kernel/efi.c
> +++ linux-2.6/arch/x86/kernel/efi.c
> @@ -475,10 +475,7 @@ void __init efi_enter_virtual_mode(void)
>                size =3D md->num_pages << EFI_PAGE_SHIFT;
>                end =3D md->phys_addr + size;
>=20
> -               if (PFN_UP(end) <=3D max_low_pfn_mapped)
> -                       va =3D __va(md->phys_addr);
> -               else
> -                       va =3D efi_ioremap(md->phys_addr, size);
> +               va =3D efi_ioremap(md->phys_addr, size);
>=20
>                md->virt_addr =3D (u64) (unsigned long) va;
> should be ok.

I think __va() and efi_ioremap() should be used.

> then how about use ioremap directly to replace fixed mapping in 64bit
> with efi_ioremap?

Because for kexec to work, EFI runtime memory area should be mapped to
same virtual address across reboot.

Best Regards,
Huang Ying


--=-8f1nkOt9BiocT4E5qRPf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjpbt4ACgkQKhFGF+eHlpgrUwCcCGnu+54/Qkt84W1rO9Ln9v78
avkAnA4nTm8II1UramqTnZq+ZiZq+mPT
=28o/
-----END PGP SIGNATURE-----

--=-8f1nkOt9BiocT4E5qRPf--

