Return-Path: <linux-kernel-owner+w=401wt.eu-S1762009AbYALFws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762009AbYALFws (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 00:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYALFwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 00:52:39 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45220 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbYALFwi (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 00:52:38 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm] x86_64 save_i387_ia32 snafu
In-Reply-To: Your message of "Fri, 11 Jan 2008 13:31:47 PST."
             <20080111213147.EBE0C26F9A9@magilla.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <4786A9CA.2090008@zytor.com> <20080111004422.2B3F926F9A6@magilla.localdomain> <4786BE15.6040604@zytor.com> <20080111024929.37FDB26F9A9@magilla.localdomain> <4786DB3B.8070808@zytor.com> <20080111104357.8364826F9A9@magilla.localdomain> <20080111104932.GA1589@elte.hu>
            <20080111213147.EBE0C26F9A9@magilla.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1200117118_4808P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 12 Jan 2008 00:51:58 -0500
Message-ID: <5212.1200117118@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1200117118_4808P
Content-Type: text/plain; charset=us-ascii

On Fri, 11 Jan 2008 13:31:47 PST, Roland McGrath said:
> > thanks, applied. Does this explain the crash/hang problems with 32-bit 
> > apps on 64-bit kernels? What was the exact failure mode?
> 
> It does.  Any 32-bit process trying to run a signal handler when it had
> used the FPU, would clobber "current" with FP bits.  The observed failure
> mode was shortly after this in the signal handler setup code, when it
> crashed due to current->mm being zero (current->pid also being zero, and
> the whole first 512 bytes of the task_struct being garbage).

For what it's worth, this patch fixes a problem I had in 24-rc6-mm1 with
kernel panics when certain X programs exited (Eterm being the biggest cause),
that I had bisected to "somewhere in git-x86.patch"....

--==_Exmh_1200117118_4808P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHiFV+cC3lWbTT17ARAiOSAJ43nCAhmqug1ZoM1qelB+sYdfELlQCg2YRJ
1sQHhGX/oK3ZM5t6aQ8Pgvk=
=vxWm
-----END PGP SIGNATURE-----

--==_Exmh_1200117118_4808P--
