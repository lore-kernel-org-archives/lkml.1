Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbYJFBsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbYJFBsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 21:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYJFBrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 21:47:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:38102 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbYJFBry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 21:47:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,365,1220252400"; 
   d="asc'?scan'208";a="344267901"
Subject: Re: [RFC PATCH] x86: make 64bit efi to use ioremap_cache for
	efi_ioremap
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: huang ying <huang.ying.caritas@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20081005100444.GG29909@elte.hu>
References: <1223101400-8819-1-git-send-email-yhlu.kernel@gmail.com>
	 <851fc09e0810040235g2ab97bdai612c0a2829f83f5c@mail.gmail.com>
	 <86802c440810041044m5b950721s8700bb6cd2fe75d@mail.gmail.com>
	 <851fc09e0810050156y114007e4hbdf3e6c5562004d3@mail.gmail.com>
	 <20081005100444.GG29909@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Uto+PaqPehNtseVTj1Cd"
Date: Mon, 06 Oct 2008 09:47:50 +0800
Message-Id: <1223257670.5872.11.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Uto+PaqPehNtseVTj1Cd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-10-05 at 12:04 +0200, Ingo Molnar wrote:
> * huang ying <huang.ying.caritas@gmail.com> wrote:
[...]
> > Some EFI runtime range is just some RAM area used by EFI runtime=20
> > services, they can be direct-mapped. Some EFI runtime range may be IO=20
> > MEM range used by EFI runtime services, it is possible that these IO=20
> > MEM range can not be direct-mapped. So I implement efi_ioremap() to=20
> > deal with them.
>=20
> hm, but in the "some RAM area" case, that area should not be listed in=20
> the e820 map (or any EFI memory map), and hence it should never be=20
> mapped directly. I.e. you should be able to just standardize on=20
> ioremap() and have no parallel facility for this.

EFI runtime memory area will be E820_RESERVED in e820 map and
EFI_RUNTIME_SERVICES_CODE/DATA in EFI memory map. In general they will
be mapped directly.

ioremap() should not used here, because for kexec to work, EFI runtime
memory area should be mapped to same virtual address across reboot.

Best Regards,
Huang Ying


--=-Uto+PaqPehNtseVTj1Cd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEABECAAYFAkjpbkEACgkQKhFGF+eHlpiXIwCfbJGITDwt3RiLHjDYgy8qnfiw
KvAAliKPhBXMNaqArvoOxxSI88je5SE=
=cOwv
-----END PGP SIGNATURE-----

--=-Uto+PaqPehNtseVTj1Cd--

