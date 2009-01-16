Return-Path: <linux-kernel-owner+w=401wt.eu-S934272AbZAPBuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934272AbZAPBuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 20:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932093AbZAPBuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 20:50:13 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51428 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765239AbZAPBuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 20:50:11 -0500
Date: Fri, 16 Jan 2009 12:49:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
       David Howells <dhowells@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Tony Luck <tony.luck@intel.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: linux-next: build problem with nfs tree (Was: Re: [mmotm][PATCH]
 fix ia64 build error)
Message-Id: <20090116124949.7828a559.sfr@canb.auug.org.au>
In-Reply-To: <20090115093514.f3f6b8ff.akpm@linux-foundation.org>
References: <20090115200315.EBE3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20090115093514.f3f6b8ff.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__16_Jan_2009_12_49_49_+1100_GJbIO4u/muZTDHew"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Jan_2009_12_49_49_+1100_GJbIO4u/muZTDHew
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 15 Jan 2009 09:35:14 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Thu, 15 Jan 2009 20:05:08 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro=
@jp.fujitsu.com> wrote:
>=20
> > Applied after: linux-next.patch
> > =3D=3D
> > Subject: [PATCH] remove duplicate EXPORT_SYMBOL()
> > Impact: fix build error
> >=20
> > In past, ia64_ksyms.c had EXPORT_SYMBOL(copy_page) in wrong place.
> >=20
> > old code was
> >=20
> > 	#include <asm/uaccess.h>
> > 	EXPORT_SYMBOL(__copy_user);
> > 	EXPORT_SYMBOL(__do_clear_user);
> > 	EXPORT_SYMBOL(__strlen_user);
> > 	EXPORT_SYMBOL(__strncpy_from_user);
> > 	EXPORT_SYMBOL(__strnlen_user);
> > 	EXPORT_SYMBOL(copy_page);
> >=20
> > (but actually, copy_page is declared in asm/page.h)
> >=20
> > And recently, commit bdc2619ab95d45d434c16d5c216bc6243761f6fb insert
> > EXPORT_SYMBOL(copy_page) into correct place.
> >=20
> > then, duplicate EXPORT_SYMBOL create following build error.
> >=20
> > arch/ia64/kernel/ia64_ksyms.c:65: error: redefinition of '__kcrctab_cop=
y_page'
> > arch/ia64/kernel/ia64_ksyms.c:43: error: previous definition of '__kcrc=
tab_copy_page' was here
> > arch/ia64/kernel/ia64_ksyms.c:65: error: redefinition of '__kstrtab_cop=
y_page'
> > arch/ia64/kernel/ia64_ksyms.c:43: error: previous definition of '__kstr=
tab_copy_page' was here
> > arch/ia64/kernel/ia64_ksyms.c:65: error: redefinition of '__ksymtab_cop=
y_page'
> > arch/ia64/kernel/ia64_ksyms.c:43: error: previous definition of '__ksym=
tab_copy_page' was here
>=20
> Yes, this is a strange bug added by
>=20
> commit 7aed50e09223e7623c7ab826efd53f097bed2f73
> Author:     Prarit Bhargava <prarit@redhat.com>
> AuthorDate: Sat Jan 10 02:25:44 2009 +0000
> Commit:     David Howells <dhowells@redhat.com>
> CommitDate: Sat Jan 10 02:25:44 2009 +0000
>=20
>     CacheFiles: Add missing copy_page export for ia64
>=20
> I don't see how it could have been tested :(
>=20
> I also don't know which linux-next tree added that commit.  There's a
> way of working this out but I forgot it.

In gitk you can search backwards for a merge commit containing "sfr" :-)

I have dropped the nfs tree from linux-next for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__16_Jan_2009_12_49_49_+1100_GJbIO4u/muZTDHew
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklv570ACgkQjjKRsyhoI8y7RgCcDNfn1Mkh8oN6I2CpRpQnN6Nl
YqsAnjp3YHIMibugJylbNr0T8xItUVz9
=D5Uy
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Jan_2009_12_49_49_+1100_GJbIO4u/muZTDHew--
