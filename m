Return-Path: <linux-kernel-owner+w=401wt.eu-S1761957AbXHQIKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761957AbXHQIKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 04:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757734AbXHQIKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 04:10:14 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45269 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918AbXHQIKI (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 04:10:08 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH]: proc: export a processes resource limits via proc/<pid>
In-Reply-To: Your message of "Thu, 16 Aug 2007 08:35:38 EDT."
             <20070816123538.GA10430@hmsreliant.think-freely.org>
From: Valdis.Kletnieks@vt.edu
References: <20070813140044.GB1960@hmsreliant.think-freely.org>
            <20070816123538.GA10430@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187338165_3142P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 17 Aug 2007 04:09:26 -0400
Message-ID: <4379.1187338166@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187338165_3142P
Content-Type: text/plain; charset=us-ascii

On Thu, 16 Aug 2007 08:35:38 EDT, Neil Horman said:
> Hey again-
> 	Andrew requested that I repost this cleanly, after running the patch
> through checkpatch.  As requested here it is with the changelog.
> 
> Currently, there exists no method for a process to query the resource
> limits of another process.  They can be inferred via some mechanisms but they
> cannot be explicitly determined.  Given that this information can be usefull 
to
> know during the debugging of an application, I've written this patch which
> exports all of a processes limits via /proc/<pid>/limits.  
> 
> Tested successfully by myself on x86 on top of 2.6.23-rc2-mm1.

I had only one comment the first time around, and Neil addressed it.

I've also tested on x86_64 23-rc2-mm1, and it works here too.  I saw where this
uses units of 'bytes' while the shell 'ulimit' uses 1024-byte units in some
places, but (a) this lists the units and (b) it's consistent with setrlimit().
Testing with values >4G show it's 64-bit clean as well.

One question:  Is the units milliseconds, or seconds here:

+	[RLIMIT_CPU] = {"Max cpu time", "ms"},

Other than that, feel free to stick either/both of these on:

Reviewed-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--==_Exmh_1187338165_3142P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGxVe1cC3lWbTT17ARAv7SAKDmXVa1ssY0YC5dvx6X5B4gnX2dDQCg0YNn
Sg3S8TDBQgukfQG7li/h/pk=
=wGdK
-----END PGP SIGNATURE-----

--==_Exmh_1187338165_3142P--
