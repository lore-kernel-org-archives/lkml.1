Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbYCNSvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbYCNSvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 14:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYCNSvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 14:51:25 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39177 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbYCNSvY (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 14:51:24 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3-mm1 - BUG at system shutdown time
In-Reply-To: Your message of "Wed, 12 Mar 2008 21:27:08 PDT."
             <20080312212708.b970077c.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <10815.1204862325@turing-police.cc.vt.edu> <20080312003227.a94580e8.akpm@linux-foundation.org> <4351.1205374751@turing-police.cc.vt.edu> <20080312193230.da330ff7.akpm@linux-foundation.org> <9373.1205380632@turing-police.cc.vt.edu>
            <20080312212708.b970077c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1205520633_3170P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Mar 2008 14:50:33 -0400
Message-ID: <383.1205520633@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1205520633_3170P
Content-Type: text/plain; charset=us-ascii

On Wed, 12 Mar 2008 21:27:08 PDT, Andrew Morton said:

> Try this:
> 
> echo "git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git#for-akpm" > .git/branches/git-foo
> git-fetch git-foo
> git-checkout git-foo
> git-bisect start
> git-bisect good 968f7910e8d10e5273977248f3d89193b32e8c20
> git-bisect bad c28550f4f68a894a3c05141762f388b5a14f33e3

Trying it against what I already pulled down:

[/usr/src/valdis/x86.git] echo "git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git#for-akpm" > .git/branches/git-foo
[/usr/src/valdis/x86.git] git-fetch git-foo
remote: Counting objects: 1642, done.
remote: Compressing objects: 100% (261/261), done.
remote: Total 1296 (delta 1090), reused 1238 (delta 1034)
Receiving objects: 100% (1296/1296), 197.24 KiB | 215 KiB/s, done.
Resolving deltas: 100% (1090/1090), completed with 218 local objects.
[/usr/src/valdis/x86.git] git-checkout git-foo
error: pathspec 'git-foo' did not match any file(s) known to git.
Did you forget to 'git add'?
[/usr/src/valdis/x86.git] git-bisect start
won't bisect on seeked tree
[/usr/src/valdis/x86.git] git-checkout -b git-foo git-foo
git checkout: updating paths is incompatible with switching branches/forcing
Did you intend to checkout 'git-foo' which can not be resolved as commit?

Trying again against a totally clean new directory:

[/usr/src/valdis] git --version
git version 1.5.4.3
[/usr/src/valdis] rm -rf x86.git
[/usr/src/valdis] mkdir x86.git
[/usr/src/valdis] cd x86.git
[/usr/src/valdis/x86.git] git-init-db
Initialized empty Git repository in .git/
[/usr/src/valdis/x86.git] git-remote add linus git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
[/usr/src/valdis/x86.git] git-remote update
Updating linus
warning: no common commits
remote: Counting objects: 721254, done.
remote: Compressing objects: 100% (130309/130309), done.
remote: Total 721254 (delta 598318), reused 711930 (delta 589976)
Receiving objects: 100% (721254/721254), 175.04 MiB | 3535 KiB/s, done.
Resolving deltas: 100% (598318/598318), done.
>From git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
 * [new branch]      master     -> linus/master
remote: Counting objects: 105, done.
remote: Compressing objects: 100% (105/105), done.
remote: Total 105 (delta 0), reused 102 (delta 0)
Receiving objects: 100% (105/105), 30.40 KiB, done.
>From git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
 * [new tag]         v2.6.12    -> v2.6.12
 * [new tag]         v2.6.12-rc2 -> v2.6.12-rc2
(...)
 * [new tag]         v2.6.25-rc3 -> v2.6.25-rc3
 * [new tag]         v2.6.25-rc4 -> v2.6.25-rc4
 * [new tag]         v2.6.25-rc5 -> v2.6.25-rc5
[/usr/src/valdis/x86.git] echo "git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git#for-akpm" > .git/branches/git-foo
[/usr/src/valdis/x86.git] git-fetch git-foo
remote: Counting objects: 1035, done.
remote: Compressing objects: 100% (171/171), done.
remote: Total 909 (delta 777), reused 868 (delta 738)
Receiving objects: 100% (909/909), 138.30 KiB, done.
Resolving deltas: 100% (777/777), completed with 117 local objects.
[/usr/src/valdis/x86.git] git-checkout git-foo
error: pathspec 'git-foo' did not match any file(s) known to git.
Did you forget to 'git add'?
[/usr/src/valdis/x86.git]  git-bisect start
[/usr/src/valdis/x86.git] git-bisect good 968f7910e8d10e5273977248f3d89193b32e8c20
fatal: Needed a single revision
Bad rev commit: ^{commit}

Try a third time, pulling down linus and x86 trees:

[/usr/src/valdis] rm -rf x86.git
[/usr/src/valdis] mkdir x86.git
[/usr/src/valdis] cd x86.git
[/usr/src/valdis/x86.git] git-remote add x86 git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
fatal: Not a git repository at /usr/lib/perl5/vendor_perl/5.10.0/Git.pm line 197.
[/usr/src/valdis/x86.git] git-init-db
Initialized empty Git repository in .git/
[/usr/src/valdis/x86.git] git-remote add x86 git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
[/usr/src/valdis/x86.git] git-remote add x86 git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
remote x86 already exists.
[/usr/src/valdis/x86.git] git-remote add linus git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
[/usr/src/valdis/x86.git] git-remote update
Updating linus
warning: no common commits
remote: Counting objects: 721254, done.
remote: Compressing objects: 100% (130309/130309), done.
remote: Total 721254 (delta 598318), reused 711930 (delta 589976)
Receiving objects: 100% (721254/721254), 175.04 MiB | 10032 KiB/s, done.
Resolving deltas: 100% (598318/598318), done.
>From git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
 * [new branch]      master     -> linus/master
remote: Counting objects: 105, done.
remote: Compressing objects: 100% (105/105), done.
remote: Total 105 (delta 0), reused 102 (delta 0)
Receiving objects: 100% (105/105), 30.40 KiB, done.
>From git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
 * [new tag]         v2.6.12    -> v2.6.12
 * [new tag]         v2.6.12-rc2 -> v2.6.12-rc2
 * [new tag]         v2.6.12-rc3 -> v2.6.12-rc3
(...}
 * [new tag]         v2.6.25-rc3 -> v2.6.25-rc3
 * [new tag]         v2.6.25-rc4 -> v2.6.25-rc4
 * [new tag]         v2.6.25-rc5 -> v2.6.25-rc5
Updating x86
remote: Counting objects: 2651, done.
remote: Compressing objects: 100% (340/340), done.
remote: Total 2320 (delta 1978), reused 2320 (delta 1978)
Receiving objects: 100% (2320/2320), 408.43 KiB | 588 KiB/s, done.
Resolving deltas: 100% (1978/1978), completed with 310 local objects.
>From git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86
 * [new branch]      base       -> x86/base
 * [new branch]      for-akpm   -> x86/for-akpm
 * [new branch]      for-linus  -> x86/for-linus
 * [new branch]      latest     -> x86/latest
 * [new branch]      master     -> x86/master
 * [new branch]      origin     -> x86/origin
 * [new branch]      testing    -> x86/testing
[/usr/src/valdis/x86.git] echo "git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git#for-akpm" > .git/branches/git-foo
[/usr/src/valdis/x86.git] git-fetch git-foo
[/usr/src/valdis/x86.git] git-checkout git-foo
error: pathspec 'git-foo' did not match any file(s) known to git.
Did you forget to 'git add'?
[/usr/src/valdis/x86.git] git-bisect start
[/usr/src/valdis/x86.git] git-bisect good 968f7910e8d10e5273977248f3d89193b32e8c20
fatal: Needed a single revision
Bad rev commit: ^{commit}

Obviously, I'm either a *total* git-idiot, or malevolent spirits have taken
up residence in my laptop and are conspiring to prevent me from troubleshooting
this problem... ;)


--==_Exmh_1205520633_3170P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFH2sj5cC3lWbTT17ARAsOxAKCqLfJF10bE2sjBKBHPQVhj90SBwwCgojBF
WW1RbtLrxrISMij0nAkNrgY=
=9VmN
-----END PGP SIGNATURE-----

--==_Exmh_1205520633_3170P--
