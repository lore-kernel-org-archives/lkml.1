Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbZIIS73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbZIIS73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 14:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZIIS72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 14:59:28 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37039 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbZIIS71 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 14:59:27 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Avi Kivity <avi@redhat.com>
Cc: Beth Kon <eak@us.ibm.com>, rostedt@goodmis.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Wierdness - linux-next KVM patch breaks Dell Latitude D820, KVM not in kernel
In-Reply-To: Your message of "Wed, 09 Sep 2009 20:38:51 +0300."
             <4AA7E82B.3080203@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <3850.1252332427@turing-police.cc.vt.edu> <4AA65CFE.50402@us.ibm.com> <22130.1252438888@turing-police.cc.vt.edu> <21211.1252517690@turing-police.cc.vt.edu>
            <4AA7E82B.3080203@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1252522752_3993P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 09 Sep 2009 14:59:12 -0400
Message-ID: <25165.1252522752@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1252522752_3993P
Content-Type: text/plain; charset=us-ascii

On Wed, 09 Sep 2009 20:38:51 +0300, Avi Kivity said:

> > And *every single one* of those 4,000 commits between 'good' and 'bad' was a
> > KVM commit, stretching all the way back to 2007.  Unless that's an artifact
> > of the way linux-next is built, I would have expected only "new-ish" commits
> > to be in the bisect window, and not just out of one tree...
> >
> > So I ended up doing a 'WTF?', an 'rm -r', and am cloning over today's linux-next
> > and will see if that brings me any better joy.

> Oh, it's an artifact of kvm.git, not linux-next.  I really should feed 
> something better to -next.

OK... knowing that my kernel doesn't have kvm, and every single kvm commit
appears to be in one long stream in linux-next, I can probably use 'git bisect
skip rev..rev' to just lop out that tree entirely, and re-try.

I looked closer at my failure mode on 'bad' commits - I suspect what actually
happened was:

1) My *original* 'bad' was a solid hang at boot.
2) 'git bisect' dropped me into the KVM tree.
3) Bisecting in there hit an area where it would triple-fault reboot instead
because I basically had a 31-rc8 "rest of tree" and the kvm tree was somewhere
back to 2007, causing a mismatch kersplat.

So hopefully excluding kvm.git I'll track down the *original* hang...

Wish me luck. ;)


--==_Exmh_1252522752_3993P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKp/sAcC3lWbTT17ARAjt7AKD17El4D3r1KgLFwwFdiMbYEK6EbACgvjzb
fGKa4/fH8H0q+sDfVPEmR+U=
=1ZHo
-----END PGP SIGNATURE-----

--==_Exmh_1252522752_3993P--
