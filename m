Return-Path: <linux-kernel-owner+w=401wt.eu-S1763299AbXFBTPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763299AbXFBTPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 15:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759958AbXFBTOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 15:14:54 -0400
Received: from h80ad2262.async.vt.edu ([128.173.34.98]:40568 "EHLO
	h80ad2262.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490AbXFBTOy (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 15:14:54 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: david@lang.hm
Cc: David Wagner <daw-usenet@taverner.cs.berkeley.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
In-Reply-To: Your message of "Sat, 02 Jun 2007 07:27:13 PDT."
             <Pine.LNX.4.64.0706020723030.954@asgard.lang.hm>
From: Valdis.Kletnieks@vt.edu
References: <653438.15244.qm@web36612.mail.mud.yahoo.com> <f3il25$pcp$1@taverner.cs.berkeley.edu> <20070524144726.GB3920@ucw.cz> <12508.1180719875@turing-police.cc.vt.edu> <f3qrp6$ftn$1@taverner.cs.berkeley.edu> <14604.1180770021@turing-police.cc.vt.edu>
            <Pine.LNX.4.64.0706020723030.954@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1180811687_4213P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 02 Jun 2007 15:14:47 -0400
Message-ID: <6419.1180811687@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1180811687_4213P
Content-Type: text/plain; charset=us-ascii

On Sat, 02 Jun 2007 07:27:13 PDT, david@lang.hm said:

> > The type of hardening that AppArmor can provide network-facing daemons is only
> > protecting the system against attacks that aren't even a large part of the
> > threat model.   Exploiting a broken PHP script? Happens all the time, and
> > AppArmor can't do much for it.
> 
> actually, this is _exactly_ where AppArmor is the most useful. if the PHP 
> script is restricted by AppArmor it won't be able to go out and touch 
> things that it's not supposed to.

OK. I'll bite.  AppArmor basically only mediates filename objects.

What filename do you specify to stop it when the exploited PHP script is used
bu a spammer to send mail to millions, when it was intended to send mail only
to a specific set of people?  Wait, that's a tcp connection to localhost:25.

What filename do you specifu to stop blog comment spam and other abuses of a
content management system (remember that the PHP code *does* need write access
to the files in question)?

It might be able to stop J Random SkriptKiddy from scribbling "Y0uz Ben Pwned"
all over your home page, but it doesn't do much to control lots of other abuses
of web apps.  To be fair, SELinux can't help a lot more, because the problem
often ends up being abuse of an access privilege that the program *should*
have - for example, if it's supposed to query the database, it's hard to stop it from making
an inappropriate query at the level that AppArmor and SELinux work at.

I'm not convinced that it's solving enough *actual* problems, given that we've
rejected a lot of other "helps a little in some cases" code for kernel
inclusion.

> if you are targeting one specific company or one specific server then you 
> are correct,

There's a lot of that going around.  And they're the attacks that you need to
worry about, because you're likely to end up as a headline.

>              however most attacks are not that targeted,

There's a big difference between "most attacks" and "most attacks you should
worry about".

>                                                          they do things 
> like useing google to find random servers that are running vunerable 
> software and attack that

Rmember that at a minimum, that also means that you're Goggleable as vulnerable
to attacks that AppArmor can't stop.  And yes, Googling for vulnerable software
*is* one of the primary ways that blog spammers find the vulerable blogs.

If your site is run in such a way that you you have to worry about random
attackers who use google, your site has *bigger* security issues, and thinking
that AppArmor is going to improve things is exactly the sort of smoke screen
magic bullet that we don't want putting in the kernel.

--==_Exmh_1180811687_4213P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGYcGncC3lWbTT17ARAnrzAKCplx1u42S72sYeux2STheJoXc43gCgs5Qo
9loLEZLPIk1/PWYu/kgc3qY=
=72Yq
-----END PGP SIGNATURE-----

--==_Exmh_1180811687_4213P--
