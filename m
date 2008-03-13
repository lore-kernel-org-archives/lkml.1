Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbYCMD5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbYCMD5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 23:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbYCMD52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 23:57:28 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52407 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYCMD51 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 23:57:27 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3-mm1 - BUG at system shutdown time
In-Reply-To: Your message of "Wed, 12 Mar 2008 19:32:30 PDT."
             <20080312193230.da330ff7.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <10815.1204862325@turing-police.cc.vt.edu> <20080312003227.a94580e8.akpm@linux-foundation.org> <4351.1205374751@turing-police.cc.vt.edu>
            <20080312193230.da330ff7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1205380632_3120P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Mar 2008 23:57:12 -0400
Message-ID: <9373.1205380632@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1205380632_3120P
Content-Type: text/plain; charset=us-ascii

On Wed, 12 Mar 2008 19:32:30 PDT, Andrew Morton said:

> Yes, it's all a bit mysterious.  I just look in the changelog, which was
> pull edout of the git diff via various means.
> 
> See how
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/broken-out
> starts with 5813a19cba5735b629cdeb156863dab814759128 and ends with
> 816543f9bf2fb77ff52083216a4537eb4e3058ec.  Use
> 5813a19cba5735b629cdeb156863dab814759128 as good and
> 816543f9bf2fb77ff52083216a4537eb4e3058ec as bad.

I *hope* I'm mis-reading Ingo's directions when I cut-n-pasted them -
first I pulled down the two trees, tried to bisect, had it give me the
"need a single revision" error, then I checked out a tree - and got a
*different* funky opaque error message when I tried to bisect:

[/usr/src/valdis/x86.git] git-init-db
Initialized empty Git repository in .git/
[/usr/src/valdis/x86.git] git-remote add linus git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
[/usr/src/valdis/x86.git] git-remote add x86 git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
[/usr/src/valdis/x86.git] git-remote update
Updating linus
warning: no common commits
(...)
Resolving deltas: 100% (598008/598008), done.
>From git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
 * [new branch]      master     -> linus/master
remote: Counting objects: 105, done.
(...)
>From git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
 * [new tag]         v2.6.12    -> v2.6.12
 * [new tag]         v2.6.12-rc2 -> v2.6.12-rc2
 (...)
 * [new tag]         v2.6.25-rc4 -> v2.6.25-rc4
 * [new tag]         v2.6.25-rc5 -> v2.6.25-rc5
Updating x86
remote: Counting objects: 2651, done.
(...)
Resolving deltas: 100% (1979/1979)
s: 100% (1979/1979), completed with 310 local objects.
>From git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86
 * [new branch]      base       -> x86/base
 * [new branch]      for-akpm   -> x86/for-akpm
 * [new branch]      for-linus  -> x86/for-linus
 * [new branch]      latest     -> x86/latest
 * [new branch]      master     -> x86/master
 * [new branch]      origin     -> x86/origin
 * [new branch]      testing    -> x86/testing
[/usr/src/valdis/x86.git] git bisect start
[/usr/src/valdis/x86.git] git bisect good 5813a19cba5735b629cdeb156863dab814759128
fatal: Needed a single revision
Bad rev commit: ^{commit}
[/usr/src/valdis/x86.git] git branch list
fatal: Not a valid object name: 'master'.
[/usr/src/valdis/x86.git] git checkout -b x86-off x86/for-akpm
warning: You appear to be on a branch yet to be born.
warning: Forcing checkout of x86/for-akpm.
Checking out files:  25% (5948/23789)
Checking out files:  31% (7375/23789)
Checking out files:  37% (8809/23789)
Checking out files:  43% (10230/23789)
Checking out files:  48% (11466/23789)
Checking out files:  54% (12847/23789)
Checking out files:  58% (13811/23789)
Checking out files:  64% (15225/23789)
Checking out files:  69% (16415/23789)
Checking out files:  75% (17842/23789)
Checking out files:  81% (19032/23789)
Checking out files:  87% (20659/23789)
Checking out files:  92% (21886/23789)
Checking out files:  97% (23076/23789)
Checking out files: 100% (23789/23789), done.
Branch x86-off set up to track remote branch refs/remotes/x86/for-akpm.
Switched to a new branch "x86-off"
[/usr/src/valdis/x86.git] git bisect start
won't bisect on seeked tree

(Google tells me that last message is gone in git 1.5.4.4 - I'm still
on 1.5.4.3).  Obviously I'm missing some important clue with working with
more than one remote tree....

--==_Exmh_1205380632_3120P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFH2KYYcC3lWbTT17ARAjCHAJ9VxPfNF5dc115YDVUOn+RT/UJ87QCg8yQR
jvG8o5Ap8cmIvIVcPrH4ojM=
=0dsj
-----END PGP SIGNATURE-----

--==_Exmh_1205380632_3120P--
