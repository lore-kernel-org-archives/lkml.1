Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbXHKGLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbXHKGLY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 02:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbXHKGLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 02:11:17 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41058 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbXHKGLQ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 02:11:16 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: roland <devzero@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Software based ECC ?
In-Reply-To: Your message of "Fri, 10 Aug 2007 23:16:45 +0200."
             <000a01c7db93$c75b66c0$eeeea8c0@aldipc>
From: Valdis.Kletnieks@vt.edu
References: <000a01c7db93$c75b66c0$eeeea8c0@aldipc>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1186812675_3018P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 11 Aug 2007 02:11:15 -0400
Message-ID: <12507.1186812675@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1186812675_3018P
Content-Type: text/plain; charset=us-ascii

On Fri, 10 Aug 2007 23:16:45 +0200, roland said:

> http://pdos.csail.mit.edu/papers/softecc:ddopson-meng/softecc_ddopson-meng.pdf
> 
> "SoftECC : A System for Software Memory Integrity Checking"
> 
> Is it possible to implement something like this within the Linux virtual
> memory subsystem ?

Anything that can be simulated with a Turing machine is *possible*.

The question is how many rocket boosters the pig needs for takeoff.

Hint: The thesis talks about why he didn't implement it for Linux.

> If it can be done, wouldn`t this be a great feature ?

Read section 5.2 of that thesis, particularly this quote from 5.2.2:

"For random word writes, this implies that SoftECC will need an order of
magnitude more compute time than the user-mode code"

Basically, on every single memory page that gets dirtied, we have to then
re-checksum the page (blowing away cache lines in the process).  If you want
to get a feel for it, find the kernel code that recognizes that a page is
dirtied, and just add a few lines there:

	int foo = 0, i;
	for (i=0;i++;<1024) { // adjust for non-4K pages
		foo ^= *(page+i);
	}

and see how much your system crawls.

Personally, I'd recommend just shelling out the bucks for hardware ECC if
the reliability matters.


--==_Exmh_1186812675_3018P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGvVMDcC3lWbTT17ARAlwlAKCbYxBDiCwX6Egw7zEr0zKPlT2iCgCguRLo
JACp0IHavJaLEdeq+4gm0Fk=
=LydK
-----END PGP SIGNATURE-----

--==_Exmh_1186812675_3018P--
