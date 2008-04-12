Return-Path: <linux-kernel-owner+w=401wt.eu-S1761011AbYDLIwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761011AbYDLIwz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 04:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757322AbYDLIwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 04:52:47 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:46743 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539AbYDLIwr (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 04:52:47 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc8-mm2 - CONFIG_PROFILE_LIKELY broke again...
In-Reply-To: Your message of "Thu, 10 Apr 2008 20:33:54 PDT."
             <20080410203354.f0a6f464.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1207990361_3279P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 12 Apr 2008 04:52:41 -0400
Message-ID: <4045.1207990361@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1207990361_3279P
Content-Type: text/plain; charset=us-ascii

On Thu, 10 Apr 2008 20:33:54 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm2/

OK, I found the issue I was chasing when I noticed the WARN from genapic_64.c.

After seeing that I'd gotten all the way to remove-div_long_long_rem.patch I
took a close look at the remaining several dozen patches, and took a wild
stab in the dark.. .and ta-da...

PROFILE_LIKELY broke between -rc8-mm1 and -rc8-mm2.  Setting it to 'y'
gets me an instant reboot similar to what I was seeing against -rc2-mm.

And changed between -mm1 and -mm2 (datestamp of 04/08):

patches/profile-likely-unlikely-macros.patch
patches/profile-likely-unlikely-macros-fix.patch

I found the profile-likely-unlikely-macros-fix-2.patch from last time around,
but the code has changed a bunch since then so it isn't a clean apply (and in
fact, it's so different it's not even easily hand-patchable - stuff like
!!(foo) has appeared).  




--==_Exmh_1207990361_3279P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIAHhZcC3lWbTT17ARAvEjAKCvHLnNXI9rRajaXmkQGP9FHMU8XQCgmytn
D1QIuPFnOsihNOekUsu5200=
=JxiI
-----END PGP SIGNATURE-----

--==_Exmh_1207990361_3279P--
