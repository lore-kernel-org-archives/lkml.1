Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbYFWQLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbYFWQLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 12:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbYFWQLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 12:11:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37789 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199AbYFWQLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 12:11:31 -0400
Date: Tue, 24 Jun 2008 02:11:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 05/19] perfmon2 minimal v2:  X86 generic code
Message-Id: <20080624021120.2bcca593.sfr@canb.auug.org.au>
In-Reply-To: <4858346e.0c58560a.394e.3498@mx.google.com>
References: <4858346e.0c58560a.394e.3498@mx.google.com>
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__24_Jun_2008_02_11_20_+1000_wnELp75WXG/MwiNA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Jun_2008_02_11_20_+1000_wnELp75WXG/MwiNA
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephane,

On Tue, 17 Jun 2008 15:02:22 -0700 (PDT) eranian@googlemail.com wrote:
>
> This patch adds the X86 generic perfmon2 code. It is in charge of
> implementing certain key functionalities required by the generic
> code such as read/write of the PMU registers, low-level interrupt
> handling.

After applying patches 1-5, building an x86_64 allmodconfig produces
these errors:

In file included from include/linux/perfmon_kern.h:167,
                 from arch/x86/perfmon/perfmon.c:25:
include/linux/perfmon_pmu.h:92: warning: =E2=80=98struct pfarg_pmc=E2=80=99=
 declared inside parameter list
include/linux/perfmon_pmu.h:92: warning: its scope is only this definition =
or declaration, which is probably not what you want
include/linux/perfmon_pmu.h:96: warning: =E2=80=98struct pfarg_pmd=E2=80=99=
 declared inside parameter list

Those structures aren't defined until patch 11.

In file included from arch/x86/perfmon/perfmon.c:25:
include/linux/perfmon_kern.h: In function =E2=80=98pfm_copy_thread=E2=80=99:
include/linux/perfmon_kern.h:199: error: =E2=80=98TIF_PERFMON_CTXSW=E2=80=
=99 undeclared (first use in this function)
arch/x86/perfmon/perfmon.c: In function =E2=80=98smp_pmu_interrupt=E2=80=99:
arch/x86/perfmon/perfmon.c:338: error: =E2=80=98LOCAL_PERFMON_VECTOR=E2=80=
=99 undeclared (first use in this function)
arch/x86/perfmon/perfmon.c: In function =E2=80=98pfm_arch_resend_irq=E2=80=
=99:
arch/x86/perfmon/perfmon.c:451: error: =E2=80=98LOCAL_PERFMON_VECTOR=E2=80=
=99 undeclared (first use in this function)
arch/x86/perfmon/perfmon.c: In function =E2=80=98pfm_arch_pmu_acquire_percp=
u=E2=80=99:
arch/x86/perfmon/perfmon.c:475: error: =E2=80=98LOCAL_PERFMON_VECTOR=E2=80=
=99 undeclared (first use in this function)

These are not defined until patch 7.

So I think some rearrangement is still required.

Also, some of the x86 files that you are modifying have had their 32 and
64 bit versions combined in linux-next (which is the stuff of the next
merge window) so just a heads up that there will be more merge work then.
Lastly, some of this will clash with the generic IPIs work.

I don't want to put you off, you have done great work here, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__24_Jun_2008_02_11_20_+1000_wnELp75WXG/MwiNA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhfyykACgkQTgG2atn1QN+f0QCeLWc7xgNTxlqXFqyyY8wWIdqt
TRoAmwQW/r2a8jbbg3cDVWs1eBgqOYmd
=hJT9
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Jun_2008_02_11_20_+1000_wnELp75WXG/MwiNA--
