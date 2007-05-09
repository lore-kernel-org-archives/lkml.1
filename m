Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbXEIQIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbXEIQIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 12:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbXEIQIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 12:08:48 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58050 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbXEIQIr (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 12:08:47 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm2 - 100% CPU on ksoftirqd/1
In-Reply-To: Your message of "Wed, 09 May 2007 01:23:22 PDT."
             <20070509012322.199f292b.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070509012322.199f292b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1178726923_3418P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 09 May 2007 12:08:43 -0400
Message-ID: <4123.1178726923@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1178726923_3418P
Content-Type: text/plain; charset=us-ascii

On Wed, 09 May 2007 01:23:22 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm2/

Boots up to multiuser mostly OK.  However...

It comes up with a screaming ksoftirqd - usually /1 but one boot had /0.
Just sitting there, 100% CPU according to 'top'.  Tried 'echo t > /proc/sysrq-trigger' to get
a trace, but it was always running on the other CPU - even after I reniced
it down to 19 and launched 2 'for(;;)' C programs to suck the cycles.  It would
be failing to get any CPU - until I did the 'echo t' and then it would be
"running" again.  Anybody got any good debugging ideas here?

Oddly enough, the kernel panic I was seeing at X server shutdown, related to
-x86_64-mm-reloc64-__pa-and-__pa_symbol-address-space-separation.patch,
seems to be gone now (not extensively tested - but it did survive one shutdown
without crashing at a point that *had* been a 100% fatal from -rc5-mm3 to 21-mm1.
I wish I understood why.

Replicated with a boot to single-user and an untainted kernel - by that point,
it was spinning at 100% already.

Any ideas how to debug this one?  


--==_Exmh_1178726923_3418P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGQfILcC3lWbTT17ARAspTAKCwtWNDpoKPxx8HhFzxsc2XCDq82ACgsDVh
Nf0jpCTcom2FQPniPjpoATw=
=rxZ6
-----END PGP SIGNATURE-----

--==_Exmh_1178726923_3418P--
