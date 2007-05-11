Return-Path: <linux-kernel-owner+w=401wt.eu-S934166AbXEKTuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934166AbXEKTuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762876AbXEKTnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:43:45 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:47891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030823AbXEKTnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:43:43 -0400
Subject: Re: [patch 7/7] tidy up usermode helper waiting a bit
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Ralf Baechle <ralf@linux-mips.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Joel Becker <joel.becker@oracle.com>, Tony Luck <tony.luck@intel.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       David Howells <dhowells@redhat.com>
In-Reply-To: <20070511000028.927787000@goop.org>
References: <20070510235708.155502000@goop.org>
	 <20070511000028.927787000@goop.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sFFcLZ1GwqbCQHq0GBUJ"
Date: Fri, 11 May 2007 21:45:35 +0200
Message-Id: <1178912735.28304.4.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sFFcLZ1GwqbCQHq0GBUJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[/me wonders why he was CC'ed]

>  	/* CLONE_VFORK: wait until the usermode helper has execve'd
>  	 * successfully We need the data structures to stay around
>  	 * until that is done.  */
> -	if (wait)
> +	if (wait =3D=3D UMH_WAIT_PROC)
>  		pid =3D kernel_thread(wait_for_helper, sub_info,
>  				    CLONE_FS | CLONE_FILES | SIGCHLD);
>  	else
>  		pid =3D kernel_thread(____call_usermodehelper, sub_info,
>  				    CLONE_VFORK | SIGCHLD);

Isn't that a change in behaviour? Previously it said
	if (wait)
 <=3D>	if (wait !=3D 0)
 <=3D>	if (wait !=3D UMH_WAIT_EXEC)
or am I missing something?

johannes

--=-sFFcLZ1GwqbCQHq0GBUJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGRMff/ETPhpq3jKURAqLhAJwIXv4q2Q+f8cg5H+PZ/PyXpRqxmwCcDvRb
+SVTDL8+lIE7jrEXsW3cTWA=
=0PuZ
-----END PGP SIGNATURE-----

--=-sFFcLZ1GwqbCQHq0GBUJ--

