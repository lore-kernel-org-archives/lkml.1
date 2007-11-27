Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbXK0H1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbXK0H1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 02:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbXK0H1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 02:27:15 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56537 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbXK0H1O (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 02:27:14 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] get rid of NR_OPEN and introduce a sysctl_nr_open
In-Reply-To: Your message of "Tue, 27 Nov 2007 08:09:19 +0100."
             <474BC29F.4060706@cosmosbay.com>
From: Valdis.Kletnieks@vt.edu
References: <200711200023.lAK0NtEe004292@imap1.linux-foundation.org> <20071120004832.393cc5a8@the-village.bc.nu> <474291E7.5060700@cosmosbay.com> <20071120001411.4db1eb04.akpm@linux-foundation.org> <474420EE.4060603@cosmosbay.com> <20071126201717.450e44eb.akpm@linux-foundation.org>
            <474BC29F.4060706@cosmosbay.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196148356_2790P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Nov 2007 02:25:56 -0500
Message-ID: <4651.1196148356@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196148356_2790P
Content-Type: text/plain; charset=us-ascii

On Tue, 27 Nov 2007 08:09:19 +0100, Eric Dumazet said:

> Changing NR_OPEN is not considered safe because of vmalloc space potential 
> exhaust.

Verbiage about this point...


> +nr_open
> +-------
> +
> +Denotes the maximum number of file-handles a process can
> +allocate. Default value is 1024*1024 (1048576) which should be
> +enough for most machines. Actual limit depends on RLIMIT_NOFILE
> +resource limit.
> +

should probably be in here - can you add something of the form "Setting this
too high can cause vmalloc failures, especially on smaller-RAM machines",
and/or *say* how much RAM the default takes?  Sure, it's 1M entries, but
my tuning on a 2G-RAM machine will differ if these are byte-sized, or 128-byte
sized - one is off in a corner, the other is 1/16th of my entire memory.

Also, would it be useful to *lower* the value drastically, if you know a priori
that no process should get up to 1K file handles, much less 1M? Does that
buy me anything different than setting RLIMIT_NOFILE=1024?

--==_Exmh_1196148356_2790P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHS8aEcC3lWbTT17ARAl7fAJ9aWzumE0ZgwMMJJPLWU9MHwmmGcQCgxvDC
MTSt0wnw4F94gVdK0Gjvyio=
=jBe5
-----END PGP SIGNATURE-----

--==_Exmh_1196148356_2790P--
