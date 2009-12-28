Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbZL1Xyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbZL1Xyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 18:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbZL1Xyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 18:54:50 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:56847 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZL1Xyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 18:54:49 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: daw-news@taverner.cs.berkeley.edu (David Wagner)
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: disablenetwork facility. (v4)
In-Reply-To: Your message of "Mon, 28 Dec 2009 22:10:28 GMT."
             <hhback$sor$1@taverner.cs.berkeley.edu>
From: Valdis.Kletnieks@vt.edu
References: <20091228163108.GC13266@heat> <14145.1262035489@localhost>
            <hhback$sor$1@taverner.cs.berkeley.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1262044487_4431P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 28 Dec 2009 18:54:47 -0500
Message-ID: <18731.1262044487@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A02020A.4B394547.00D0,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1262044487_4431P
Content-Type: text/plain; charset=us-ascii

On Mon, 28 Dec 2009 22:10:28 GMT, David Wagner said:

> Pavel responds:
> > Actually, I've seen a *lot* of similar [..] policies.

No, that was me, not Pavel.

> OK, so to translate: it sounds like the answer is No, you
> haven't seen this policy in real life.

As I point out in subsequent paragraphs, I *have* in fact seen systems that
implement essentially the same semantics.

> More to the point, the real question is whether this policy
> is embedded in code anywhere such that Michael's mechanism would
> introduce a new security hole, and if so, whether the cost of
> that would outweigh the benefit of his mechanism.

Granted - but "is it embedded in code anywhere" is different from "does
anybody use such a policy".  The semantic is used by many shops, but isn't
embedded in code anywhere that I know of - it's always done via system
config.

Take a standard stock Fedora install.  Configure it to use LDAP for user
authentication. Screw up the config with a typo.  Reboot to single user to fix,
you get a # prompt without entering a password. You now have Pavel's policy: 

>                 "If the network works, noone can
> log in locally, because administration is normally done over
> network. If the network fails, larger set of people is allowed in,
> because something clearly went wrong and we want anyone going around
> to fix it."

So yes, it *does* exist in the real world - unless there are *zero* Fedora
boxes that use LDAP, and haven't manually changed the init config to run
sulogin on a single-user boot.

> I think what Michael is trying to do has the potential to be very
> valuable and should be supported, and this is not a convincing
> argument against it.

In case you didn't notice, I've been on the "this looks sane if we can actually
do it correctly" side of the fence.  Michael's code isn't something I'd
personally run, because it doesn't address the threat models I worry about -
but I see the value for those people who do worry about them.

And hey, maybe we'll get lucky and we'll get the ability to have a stacker
that does MAC LSM + targeted add-ons, because in my world, the easiest fix
is the distributed SELinux 'mls' policy plus an add-on LSM - even though it's
likely that most of the stuff I want *could* be done via SELinux policy, in
many cases 20 lines of C is easier than retrofitting a policy patch or getting
the policy patch pushed upstream...

Out of curiosity, any of the other security types here ever included "getting
the damned semi-clued auditor who insists on cargo-cult checklists out of your
office" as part of your threat model?  Only a half-smiley on this one...


--==_Exmh_1262044487_4431P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLOUVHcC3lWbTT17ARAvclAKDB+s5x6HrMe5lobr9LmwSIXb9xmwCg+sjV
PogMALFdxejgEVgYTUqj3GM=
=nx8j
-----END PGP SIGNATURE-----

--==_Exmh_1262044487_4431P--

