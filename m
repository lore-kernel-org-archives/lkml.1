Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbZDWJob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbZDWJob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 05:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756138AbZDWJoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 05:44:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:63347 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756108AbZDWJoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 05:44:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,235,1239001200"; 
   d="asc'?scan'208";a="134917279"
Subject: Re: [PATCH] [4/4] x86: MCE: Fix EIPV behaviour with !PCC
From: Huang Ying <ying.huang@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <20090407150657.61C4E1D046E@basil.firstfloor.org>
References: <20090407506.675031434@firstfloor.org>
	 <20090407150657.61C4E1D046E@basil.firstfloor.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-L0TUJ+FmIM3HJht/5vls"
Date: Thu, 23 Apr 2009 17:43:58 +0800
Message-Id: <1240479838.6842.555.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-L0TUJ+FmIM3HJht/5vls
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Add some description for the patch, hope that to be more clear.

Best Regards,
Huang Ying
-------------------------------------------------->
Impact: Spec compliance

Tolerant level 0 means: always panic on uncorrected errors, that is,
panic even for recoverable uncorrected errors. This is a useful option
for someone think panic is the better hardware error containment
mechanism than trying to recover.

Current implementation does not comply with the tolerant =3D=3D 0 spec,
that is, it tries to recover (by killing related processes) for
recoverable uncorrected errors (errors triggered in userspace) when
tolerant =3D=3D 0. This patch fixes this by going panic for that case.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -400,7 +400,7 @@ void do_machine_check(struct pt_regs * r
 		 * force_sig() takes an awful lot of locks and has a slight
 		 * risk of deadlocking.
 		 */
-		if (user_space) {
+		if (user_space && tolerant > 0) {
 			force_sig(SIGBUS, current);
 		} else if (panic_on_oops || tolerant < 2) {
 			mce_panic("Uncorrected machine check",


--=-L0TUJ+FmIM3HJht/5vls
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknwOFsACgkQKhFGF+eHlpgWpwCcCvNYCmwwX3b1ydJVorEMg2Mo
2r8An3Fzp3S0cvqsqYX3gT7Id6Ec4sLA
=Ng1e
-----END PGP SIGNATURE-----

--=-L0TUJ+FmIM3HJht/5vls--

