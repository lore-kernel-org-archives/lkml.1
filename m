Return-Path: <linux-kernel-owner+w=401wt.eu-S1759414AbXEKDW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414AbXEKDW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 23:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757576AbXEKDWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 23:22:52 -0400
Received: from h80ad2262.async.vt.edu ([128.173.34.98]:52679 "EHLO
	h80ad2262.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbXEKDWv (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 23:22:51 -0400
X-Greylist: delayed 1766 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2007 23:22:51 EDT
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org,
       "James P. Ketrenos" <ipw2100-admin@linux.intel.com>
Subject: Re: 2.6.21-mm2 - 100% CPU on ksoftirqd/1
In-Reply-To: Your message of "Wed, 09 May 2007 12:08:43 EDT."
             <4123.1178726923@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <20070509012322.199f292b.akpm@linux-foundation.org>
            <4123.1178726923@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1178851964_3480P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 10 May 2007 22:52:44 -0400
Message-ID: <5314.1178851964@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1178851964_3480P
Content-Type: text/plain; charset=us-ascii

On Wed, 09 May 2007 12:08:43 EDT, Valdis.Kletnieks@vt.edu said:

> On Wed, 09 May 2007 01:23:22 PDT, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm2/
> 
> Boots up to multiuser mostly OK.  However...
> 
> It comes up with a screaming ksoftirqd - usually /1 but one boot had /0.
> Just sitting there, 100% CPU according to 'top'.  Tried 'echo t > /proc/sysrq-trigger' to get
> a trace, but it was always running on the other CPU - even after I reniced
> it down to 19 and launched 2 'for(;;)' C programs to suck the cycles.  It would
> be failing to get any CPU - until I did the 'echo t' and then it would be
> "running" again.  Anybody got any good debugging ideas here?

OK, finally tracked this one down - the out-of-tree iwlwifi git tree for the
Intel 3945ABG card had some disagreements with the 2.6.21-mm2 git-wireless.patch

Unfortunately, the last known-working for this was -r5-mm2, as I didn't test
-rc6-mm* or -rc7-mm* for this (I hit other issues with those so I didn't
notice this one).  I'll try to work up some of those tomorrow and see if
I can narrow it down at least a *little* bit.




--==_Exmh_1178851964_3480P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGQ9p8cC3lWbTT17ARAqriAJ0ZLzDHf7w4i958KtQsGc6FCu6FrwCg0G+w
uBaiusJuOiNZkWPihaCegKk=
=hDeS
-----END PGP SIGNATURE-----

--==_Exmh_1178851964_3480P--
