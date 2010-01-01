Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654Ab0AAAms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab0AAAms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 19:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441Ab0AAAmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 19:42:47 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54527 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab0AAAmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 19:42:46 -0500
Date: Fri, 1 Jan 2010 11:42:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Balaji T K <balajitk@ti.com>, Rajendra Nayak <rnayak@ti.com>
Subject: linux-next: origin tree build warnings
Message-Id: <20100101114238.83108321.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__1_Jan_2010_11_42_38_+1100_RZeojJ_Q3aH=a7dR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Jan_2010_11_42_38_+1100_RZeojJ_Q3aH=a7dR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (powerpc allyesconfig) produced these warnings:

drivers/mfd/twl4030-irq.c: In function 'twl4030_sih_do_edge':
drivers/mfd/twl4030-irq.c:571: warning: passing argument 1 of 'spin_lock_ir=
q' from incompatible pointer type
include/linux/spinlock.h:304: note: expected 'struct spinlock_t *' but argu=
ment is of type 'struct raw_spinlock_t *'
drivers/mfd/twl4030-irq.c:576: warning: passing argument 1 of 'spin_unlock_=
irq' from incompatible pointer type
include/linux/spinlock.h:329: note: expected 'struct spinlock_t *' but argu=
ment is of type 'struct raw_spinlock_t *'

Introduced by commit 239007b8440abff689632f50cdf0f2b9e895b534 ("genirq:
Convert irq_desc.lock to raw_spinlock").  I guess that this file was
missed in the conversion.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__1_Jan_2010_11_42_38_+1100_RZeojJ_Q3aH=a7dR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAks9RP4ACgkQjjKRsyhoI8xriQCgkx8oJd4OG1ASDji9KiuWxnfL
BTIAnA+z7zic+sT06KVO1dQgyQ44de3y
=oFTc
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Jan_2010_11_42_38_+1100_RZeojJ_Q3aH=a7dR--
