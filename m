Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYAIIEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYAIIEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 03:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYAIIEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 03:04:43 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:47089 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYAIIEm (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 03:04:42 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Al Boldi <a1426z@gawab.com>
Cc: Rik van Riel <riel@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFD] Incremental fsck
In-Reply-To: Your message of "Wed, 09 Jan 2008 07:40:12 +0300."
             <200801090740.12989.a1426z@gawab.com>
From: Valdis.Kletnieks@vt.edu
References: <200801090022.55589.a1426z@gawab.com> <20080108164106.735c431d@bree.surriel.com>
            <200801090740.12989.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1199865859_3703P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 09 Jan 2008 03:04:19 -0500
Message-ID: <23019.1199865859@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1199865859_3703P
Content-Type: text/plain; charset=us-ascii

On Wed, 09 Jan 2008 07:40:12 +0300, Al Boldi said:

> But why wouldn't it be possible to do this on the current fs infrastructure, 
> using just a smart fsck, working incrementally on some sub-dir?

If you have /home/usera, /home/userb, and /home/userc, the vast majority of
fs screw-ups can't be detected by only looking at one sub-dir.  For example,
you can't tell definitively that all blocks referenced by an inode under
/home/usera are properly only allocated to one file until you *also* look at
the inodes under user[bc].  Heck, you can't even tell if the link count for
a file is correct unless you walk the entire filesystem - you can find a file
with a link count of 3 in the inode, and you find one reference under usera,
and a second under userb - you can't tell if the count is one too high or
not until you walk through userc and actually see (or fail to see) a third
directory entry referencing it.

--==_Exmh_1199865859_3703P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHhIADcC3lWbTT17ARAr5PAKCM0E9XY50I9miH28PWtQSIwHgHOwCfT2Oc
fGxDWRXnT4Jx5oWiJaeU1G4=
=c3fI
-----END PGP SIGNATURE-----

--==_Exmh_1199865859_3703P--
