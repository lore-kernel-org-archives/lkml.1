Return-Path: <linux-kernel-owner+w=401wt.eu-S1760355AbYCUTjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355AbYCUTjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbYCUTjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:39:24 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52685 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371AbYCUTjX (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:39:23 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3-mm1 - BUG at system shutdown time
In-Reply-To: Your message of "Fri, 21 Mar 2008 14:41:28 BST."
             <20080321134128.GO27245@elte.hu>
From: Valdis.Kletnieks@vt.edu
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <10815.1204862325@turing-police.cc.vt.edu> <20080312003227.a94580e8.akpm@linux-foundation.org> <4351.1205374751@turing-police.cc.vt.edu>
            <20080321134128.GO27245@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1206128318_2979P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Mar 2008 15:38:38 -0400
Message-ID: <3343.1206128318@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1206128318_2979P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <3337.1206128318.1@turing-police.cc.vt.edu>

On Fri, 21 Mar 2008 14:41:28 BST, Ingo Molnar said:
> 
> * Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:
> 
> > I may have to try again to figure out how to bisect the git-x86 tree - 
> > Ingo send me a pointer to his git-x86 cheat sheet, I looked at it but 
> > I couldn't figure out how to tell 'git bisect' that the starting good 
> > spot was "whatever corresponded to the git-x86 patch in 24-rc8-mm1" 
> > and bad was "25-rc3-mm1". I tried using the first commit ID listed in 
> > the patch, but that gave me this:
> 
> the best way to bisect the x86.git-only commits is to do:
> 
>   git-bisect bad x86/latest
>   git-bisect good x86/base

OK, *that* got the bisect running.  However, after a few bisections, things
are getting weird...

(Note - I haven't done a git pull or update for a week and a bit, so the tree is
as of 03/14 or so...)

'git bisect log' reports:

git-bisect start
# bad: [21a418440c44b6a2cdf38fea2533a5398d6fd939] Move mp_bus_id_to_node to numa.c
git-bisect bad 21a418440c44b6a2cdf38fea2533a5398d6fd939
# good: [dba92d3bc49c036056a48661d2d8fefe4c78375a] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband
git-bisect good dba92d3bc49c036056a48661d2d8fefe4c78375a
# good: [53f0f2bc547fd13a70a6adb86592301ec83b9fc7] x86 mmiotrace: comment about user space ABI
git-bisect good 53f0f2bc547fd13a70a6adb86592301ec83b9fc7
# good: [53f0f2bc547fd13a70a6adb86592301ec83b9fc7] x86 mmiotrace: comment about user space ABI
git-bisect good 53f0f2bc547fd13a70a6adb86592301ec83b9fc7
# good: [53f0f2bc547fd13a70a6adb86592301ec83b9fc7] x86 mmiotrace: comment about user space ABI
git-bisect good 53f0f2bc547fd13a70a6adb86592301ec83b9fc7
# good: [2702dd1be087ac7307b731d884ee48db6e1cdff6] x86: create smpcommon.c
git-bisect good 2702dd1be087ac7307b731d884ee48db6e1cdff6
# good: [ad42b55d36238ebb9fa4d7a538ef691a76397c46] x86: add KERN_INFO to show_unhandled_signals printout
git-bisect good ad42b55d36238ebb9fa4d7a538ef691a76397c46
# good: [56b412e63863ea82a5720315076c7dbd1d9888cd] x86: change x86 to use generic find_next_bit
git-bisect good 56b412e63863ea82a5720315076c7dbd1d9888cd
# good: [42de918f25dc9a49fb9688e22c2a3f2b156cc1bf] x86: prevent unconditional writes to DebugCtl MSR
git-bisect good 42de918f25dc9a49fb9688e22c2a3f2b156cc1bf

At this point, 'git bisect visualize' shows 9 commits left to bisect through,
and all are dated 03/10 or later.  However, since 25-rc3-mm1 had the problem,
it had to be something in-tree as of 03/05.

Is it possible that the problem code was in the git-x86 tree when Andrew
pulled for -rc3-mm1 and -rc5-mm1, but had been reverted by the time I grabbed
the tree, so the /x86/base' was in fact *good* by that point?


--==_Exmh_1206128318_2979P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFH5A6+cC3lWbTT17ARApIaAKCUkw36qYrRZkiPozSWnFgJaHc99wCdHkXB
lb0sRBjio0QU92Ci56xA9/o=
=N84n
-----END PGP SIGNATURE-----

--==_Exmh_1206128318_2979P--
