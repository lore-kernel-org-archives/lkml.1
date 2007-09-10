Return-Path: <linux-kernel-owner+w=401wt.eu-S965411AbXIJTHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965411AbXIJTHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbXIJTHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:07:38 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34839 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbXIJTHh (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:07:37 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andi Kleen <ak@suse.de>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, jakub@redhat.com,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1 - vdso and gettimeofday issues with glibc
In-Reply-To: Your message of "Sun, 09 Sep 2007 09:27:06 +0200."
             <200709090927.07069.ak@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46D6EFDE.4020107@redhat.com> <7671.1189297449@turing-police.cc.vt.edu>
            <200709090927.07069.ak@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1189451250_3507P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 10 Sep 2007 15:07:30 -0400
Message-ID: <5026.1189451250@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1189451250_3507P
Content-Type: text/plain; charset=us-ascii

On Sun, 09 Sep 2007 09:27:06 +0200, Andi Kleen said:
> > Updating on this issue:   Both myself and another person have reported on
> > the RedHat bugzilla that it's a clocksource issue - if you are using the
> > hpet clocksource, the time warps, but booting with clocksource=acpi_pm works.
> > 
> > This ring any bells?
> 
> Does this patch fix it? 
> -Andi
> 
> Add missing mask operation to vdso
> 
> vdso vgetns() didn't mask the time source offset calculation, which could
> lead to time problems with 32bit HPET. Add the masking.
> 
> Thanks to Chuck Ebbert for tracking down.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>

Confirming that does indeed fix it - booted with hpet clocksource and vdso=1,
and the time didn't warp at the 5-minute mark.

Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--==_Exmh_1189451250_3507P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG5ZXycC3lWbTT17ARAg3BAKCtfadk54xhoqXqYKhgJY1Bams+RgCgwo26
9xMBg+JgWwtKSOAZaj0l/4U=
=VfYj
-----END PGP SIGNATURE-----

--==_Exmh_1189451250_3507P--
