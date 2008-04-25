Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYDYFfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYDYFfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 01:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbYDYFf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 01:35:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:42244 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753500AbYDYFf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 01:35:28 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1/8vWNQlbD87cAktV4t0fuihjyBN/a5oKZHT3+Pn9
	rs8YrAy1JrEmwC
Subject: Re: [Bug 10328] New: [regression] performance drop for glx
From: Alexey Fisher <bug-track@fisher-privat.net>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       venkatesh.pallipadi@intel.com
In-Reply-To: <47E9D42F.5080506@linux.intel.com>
References: <bug-10328-27@http.bugzilla.kernel.org/>
	 <20080325152809.e2b07251.akpm@linux-foundation.org>
	 <20080326003912.GB3313@linux-os.sc.intel.com>
	 <47E9D42F.5080506@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xuNXBkXTRn3WpmfR0QqM"
Date: Fri, 25 Apr 2008 07:35:23 +0200
Message-Id: <1209101723.21553.1.camel@zwerg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xuNXBkXTRn3WpmfR0QqM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Am Dienstag, den 25.03.2008, 21:42 -0700 schrieb Arjan van de Ven:
> Suresh Siddha wrote:
> > On Tue, Mar 25, 2008 at 03:28:09PM -0700, Andrew Morton wrote:
> >> (switched to email.  Please respond via emailed reply-to-all, not via =
the
> >> bugzilla web interface).
> >>
> >> On Tue, 25 Mar 2008 15:11:15 -0700 (PDT)
> >> bugme-daemon@bugzilla.kernel.org wrote:
> >>
> >>> http://bugzilla.kernel.org/show_bug.cgi?id=3D10328
> >>>
> >>>            Summary: [regression] performance drop for glx
> >>>
> >>> after commit 4138cc3418f5eaa7524ff8e927102863f1ba0ea5 i expirience so=
me grafik
> >>> related perfomance issues.
> >>>
> >>> I used glxgears for test.
> >>> before this patch: 1281.005 FPS
> >>> and after: 765.000 FPS
> >> It nearly halved.
> >>
> >>> latest tested commit a4083c9271e0a697278e089f2c0b9a95363ada0a
> >>> still hase bad performance.
> >>>
> >>> I use Pentium D with 2GB RAM, Grafick: i945G, ICH7
> >>>
> >> That's=20
> >>
> >> : commit 4138cc3418f5eaa7524ff8e927102863f1ba0ea5
> >> : Author: Siddha, Suresh B <suresh.b.siddha@intel.com>
> >> : Date:   Wed Jan 30 13:33:43 2008 +0100
> >> :=20
> >> :     x86: set strong uncacheable where UC is really desired
> >> :    =20
> >> :     Also use _PAGE_PWT for all the mappings which need uncache mappi=
ng.
> >> :     Instead of existing PAT2 which is UC- (and can be overwritten by=
 MTRRs),
> >> :     we now use PAT3 which is strong uncacheable.
> >> :    =20
> >> :     This makes it consistent with pgprot_noncached()
> >=20
> > Alexey, Can you please try the appended patch?
> >=20
> > Andrew, can you please push the appended patch for 2.6.25? Thanks.
> > ---
> >=20


This issue come again with commit:

commit 2e5d9c857d4e6c9e7b7d8c8c86a68a7842d213d6
Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
Date:   Tue Mar 18 17:00:14 2008 -0700

    x86: PAT infrastructure patch

    Sets up pat_init() infrastructure.

    PAT MSR has following setting.
        PAT
        |PCD
        ||PWT
        |||
        000 WB          _PAGE_CACHE_WB
        001 WC          _PAGE_CACHE_WC
        010 UC-         _PAGE_CACHE_UC_MINUS
        011 UC          _PAGE_CACHE_UC

    We are effectively changing WT from boot time setting to WC.
    UC_MINUS is used to provide backward compatibility to existing /dev/mem
    users(X).

    reserve_memtype and free_memtype are new interfaces for maintaining
alias-free
    mapping. It is currently implemented in a simple way with a linked list=
 and
    not optimized. reserve and free tracks the effective memory type, as a
result
    of PAT and MTRR setting rather than what is actually requested in PAT.

    pat_init piggy backs on mtrr_init as the rules for setting both pat and
mtrr
    are same.

    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

--=-xuNXBkXTRn3WpmfR0QqM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIEW2bVVCoNUmKuAcRAgorAKDFgfR5jRTPiyzohmGVkgCTU3ocYwCfS/06
WapHyXdZ+s219mSum4Szykg=
=5//2
-----END PGP SIGNATURE-----

--=-xuNXBkXTRn3WpmfR0QqM--

