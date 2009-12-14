Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbZLNKij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbZLNKij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 05:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbZLNKid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 05:38:33 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37095 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756723AbZLNKib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 05:38:31 -0500
Date: Mon, 14 Dec 2009 21:38:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, heiko.carstens@de.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Cc: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Subject: Re: [tip:perf/urgent] hw-breakpoints: Let
 modify_user_hw_breakpoint() return an int
Message-Id: <20091214213817.dea4fe86.sfr@canb.auug.org.au>
In-Reply-To: <tip-4983ee49cf0393fd786891dd53af41146cf9f98b@git.kernel.org>
References: <20091214092412.GA5242@osiris.boeblingen.de.ibm.com>
	<tip-4983ee49cf0393fd786891dd53af41146cf9f98b@git.kernel.org>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Dec_2009_21_38_17_+1100_k+tH1LH=Sgzit=ql"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Dec_2009_21_38_17_+1100_k+tH1LH=Sgzit=ql
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Mon, 14 Dec 2009 09:49:44 GMT tip-bot for Heiko Carstens <heiko.carstens=
@de.ibm.com> wrote:
>
> Commit-ID:  4983ee49cf0393fd786891dd53af41146cf9f98b
> Gitweb:     http://git.kernel.org/tip/4983ee49cf0393fd786891dd53af41146cf=
9f98b
> Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
> AuthorDate: Mon, 14 Dec 2009 10:24:12 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 14 Dec 2009 10:42:57 +0100
>=20
> hw-breakpoints: Let modify_user_hw_breakpoint() return an int
>=20
> Let modify_user_hw_breakpoint return an int to avoid hundreds of
> compile warnings like this one:
>=20
>  include/linux/hw_breakpoint.h: In function 'modify_user_hw_breakpoint':
>  include/linux/hw_breakpoint.h:96:
>   warning: return makes integer from pointer without a cast
>=20
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> LKML-Reference: <20091214092412.GA5242@osiris.boeblingen.de.ibm.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/hw_breakpoint.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
> index 41235c9..3f3ac2f 100644
> --- a/include/linux/hw_breakpoint.h
> +++ b/include/linux/hw_breakpoint.h
> @@ -90,7 +90,7 @@ static inline struct arch_hw_breakpoint *counter_arch_b=
p(struct perf_event *bp)
>  static inline struct perf_event *
>  register_user_hw_breakpoint(struct perf_event_attr *attr,
>  			    perf_overflow_handler_t triggered,
> -			    struct task_struct *tsk)	{ return NULL; }
> +			    struct task_struct *tsk)	{ return 0; }
>  static inline int
>  modify_user_hw_breakpoint(struct perf_event *bp,
>  			  struct perf_event_attr *attr)	{ return -ENOSYS; }

This applied incorrectly ... it was a fix for modify_user_hw_breakpoint(),
but that fix has already bee applied to perf/urgent ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Dec_2009_21_38_17_+1100_k+tH1LH=Sgzit=ql
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksmFZkACgkQjjKRsyhoI8yWcACeNfu+n/AQAs++mJ4IuTMBC176
UxkAn0LAQWnBj9Smkh0rxSSBH3a3R56k
=fzBf
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Dec_2009_21_38_17_+1100_k+tH1LH=Sgzit=ql--
