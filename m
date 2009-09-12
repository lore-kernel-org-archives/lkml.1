Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbZILUzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbZILUzt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 16:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbZILUzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 16:55:48 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33502 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbZILUzr (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 16:55:47 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Avi Kivity <avi@redhat.com>, Beth Kon <eak@us.ibm.com>,
       rostedt@goodmis.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Wierdness - linux-next KVM patch breaks Dell Latitude D820, KVM not in kernel
In-Reply-To: Your message of "Wed, 09 Sep 2009 14:59:12 EDT."
             <25165.1252522752@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <3850.1252332427@turing-police.cc.vt.edu> <4AA65CFE.50402@us.ibm.com> <22130.1252438888@turing-police.cc.vt.edu> <21211.1252517690@turing-police.cc.vt.edu> <4AA7E82B.3080203@redhat.com>
            <25165.1252522752@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1252788933_4384P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 12 Sep 2009 16:55:33 -0400
Message-ID: <125228.1252788933@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1252788933_4384P
Content-Type: text/plain; charset=us-ascii

On Wed, 09 Sep 2009 14:59:12 EDT, Valdis.Kletnieks@vt.edu said:

> So hopefully excluding kvm.git I'll track down the *original* hang...
> 
> Wish me luck. ;)

And luck was not to be had.  Apparently 'git bisect skip' has some bad O(n**2)
issues - I tried to exclude the kvm.git tree, and it ended up running literally
overnight with no signs of stopping (see the gory details here:
https://bugzilla.redhat.com/show_bug.cgi?id=522599 )  Now, I probably *could*
cobble up something to do the skip as a series of little 20-40 commit skips,
but that's just getting nuts. ;)

Given that I'm having little luck bisecting this issue in linux-next and
we're now into the merge window, does anybody have a *better* idea than letting
the issue get into Linus's tree around -rc1, and hope that bisects more nicely
than linux-next did, so -rc2 has a fix for it?

--==_Exmh_1252788933_4384P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKrArFcC3lWbTT17ARAuBmAKDrfkjEqlsy0QX0yMXl6duG7EujXgCcD8tg
IGIIC3+Dx5Bi3bGII1DWhU0=
=0Z7a
-----END PGP SIGNATURE-----

--==_Exmh_1252788933_4384P--
