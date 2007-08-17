Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbXHQPko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbXHQPko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 11:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756396AbXHQPkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 11:40:36 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39176 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379AbXHQPkg (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 11:40:36 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Thinking outside the box on file systems
In-Reply-To: Your message of "Fri, 17 Aug 2007 11:19:21 EDT."
             <46C5BC79.9090204@cfl.rr.com>
From: Valdis.Kletnieks@vt.edu
References: <106259.96671.qm@web52501.mail.re2.yahoo.com> <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org> <46C2F96D.5030908@partiallystapled.com> <20070815133021.GB9412@csclub.uwaterloo.ca> <ECFEFFF7-0210-4D16-B508-5284FCE58B28@mac.com> <46C33934.7060802@cfl.rr.com> <DE34FF90-3143-4978-BBC5-3CF74B8C3C07@mac.com> <46C3644C.9020102@cfl.rr.com> <87EEB1B3-7FFA-472C-B539-1A7AA2843869@mac.com> <46C37AD4.5060006@cfl.rr.com> <A93D7AFB-6883-48E4-96A9-CAD76E39132E@mac.com> <46C4689C.8020702@cfl.rr.com> <5D526964-3F46-4B6D-A12A-437A7EF5E0D8@mac.com>
            <46C5BC79.9090204@cfl.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187365183_3142P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 17 Aug 2007 11:39:43 -0400
Message-ID: <1942.1187365183@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187365183_3142P
Content-Type: text/plain; charset=us-ascii

On Fri, 17 Aug 2007 11:19:21 EDT, Phillip Susi said:
> Kyle Moffett wrote:
>> Problem 1: "updating cached acls of descendent objects":  How do you 
>> find out what a 'descendent object' is?  Answer:  You can't without 
>> recursing through the entire in-memory dentry tree.

I suspect Kyle is not quite correct - it's probably the case that you don't
have to consider just the in-memory dentries, but *all* the descendent objects
in the entire file system.

If you have a clever proof that on-disk can't *possibly* be affected, feel
free to present it.

(Does anybody know offhand what means 'chacl -r' uses to avoid race conditions
with directories being moved in/out from under it, or does it just say "we'll
make a best stab at it"?)

> Yes, it would take some cpu time, and yes, it would have to use a lock 
> to protect the acl which would also lock out moves.  Is that such a high 
> cost?  Changing acls and moving whole directory trees around is not THAT 
> common of an operation... if it takes a wee bit more cpu time, I doubt 
> anyone will complain.

It will become even *more* of a "not that common" if the lock will block moves
and ACL changes *across the filesystem* for potentially *minutes* at a time.


--==_Exmh_1187365183_3142P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGxcE/cC3lWbTT17ARAsQqAJ95p+iF5p9grk9NbN3jhnmflGKxRACbBFmj
SBHIkRd2QSK2W5LqDV37lQk=
=ZEl6
-----END PGP SIGNATURE-----

--==_Exmh_1187365183_3142P--
