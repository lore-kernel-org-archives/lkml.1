Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbYIRRgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbYIRRgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 13:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbYIRRgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 13:36:31 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:47317 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbYIRRga (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 13:36:30 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: evilsocket <evilsocket@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Stack buffer size issue
In-Reply-To: Your message of "Thu, 18 Sep 2008 14:30:12 +0200."
             <48D249D4.8000400@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <48D249D4.8000400@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1221759388_3536P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Sep 2008 13:36:28 -0400
Message-ID: <21780.1221759388@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1221759388_3536P
Content-Type: text/plain; charset=us-ascii

On Thu, 18 Sep 2008 14:30:12 +0200, evilsocket said:

> char * abuffer[123];

Note that this '123' isn't anything that's known to the kernel, or passed to
it.

> This *should* give the output :
> 
> SIZE : 123

Why "should' it do so?  The kernel doesn't know or care much about what your
stack layout is, except if you overflow the provided space.

Minor nit:  'char *abuffer[123];' allocates an array of 123 pointers-to-ints,
which means it's actually 123*4 or 123*8 bytes in size, depending on the size
of a pointer (different for 32 and 64 bit programs).  So if you got 123 as
an answer, that would *still* be wrong...

> I'm using the struct task_struct in the kernel module, looping the mmap 
> to find the vm area the address resides in and then to set
> 
> mm_size = vm_end - vm_start

Right.  That's the size of the mm you're looking at. There isn't one mm
for each variable in your program.

> But doing so i obtaing only the size of the vm page the buffer resides .

That's probably because the struct mm that covers your program stack is only
one page in size.

Do a 'cat /proc/self/maps', which will show the maps in use for the /bin/cat
process, and ponder why there's a lot fewer lines than /bin/cat has variables.

--==_Exmh_1221759388_3536P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI0pGccC3lWbTT17ARAiIQAKCLmfJ2dXDlelpjdrbvQP88jKnZiACfdblT
ZBC1Np2P1nwSgp3Dq/zHpg4=
=FvEx
-----END PGP SIGNATURE-----

--==_Exmh_1221759388_3536P--
