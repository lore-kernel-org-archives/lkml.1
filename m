Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYJVDHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYJVDHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 23:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbYJVDHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 23:07:32 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:44485 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYJVDHb (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 23:07:31 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jonathan Johnson <johnsonn@matc.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How do I self diagnose slow write to HDD performance issue
In-Reply-To: Your message of "Tue, 21 Oct 2008 14:34:01 CDT."
             <48FDE860.8C56.0056.0@matc.edu>
From: Valdis.Kletnieks@vt.edu
References: <48FDE860.8C56.0056.0@matc.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1224644845_3562P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 21 Oct 2008 23:07:25 -0400
Message-ID: <111655.1224644845@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1224644845_3562P
Content-Type: text/plain; charset=us-ascii

On Tue, 21 Oct 2008 14:34:01 CDT, Jonathan Johnson said:

> Before I setup the array I tested the SATA 2 drives connected to the mobo SATA connect and got approx 60mb/s
> write and even better read speeds per drive.

Remember that streaming read/write speed is usually only a small part of the
total disk performance story.  Sure, if you don't have to move the heads much,
you can go 60 megabytes/sec.  However, even the *hottest* drives out there
have a hard time sustaining 200 seeks per second.

In other words, every time you have to move the heads, it costs you 300Kbytes/sec
of throughput (1/200th of that 60M).

And bonnie++ probably moves the heads a lot.

To *add* insult to injury, if you're running in RAID6 mode, each time you write
to the RAID set, it has to do *several* I/Os to do all the parity computations.
So you take a 300K hit for each of those I/Os.

There's a *reason* why RAID1 is still used - you can (assuming a smart enough
controller) launch both the write and the mirroring write at the same time in
parallel, taking little or no performance penalty.


--==_Exmh_1224644845_3562P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI/pjtcC3lWbTT17ARAgcYAKCdoA4tEiQUCcC6wqM5xfm/qyloawCgxfoM
Gf1vU0Ox8uY7msfFAhK4yjo=
=4D9Y
-----END PGP SIGNATURE-----

--==_Exmh_1224644845_3562P--
