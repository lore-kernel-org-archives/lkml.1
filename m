Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbYEPFRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbYEPFRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 01:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYEPFRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 01:17:37 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:39470 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbYEPFRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 01:17:34 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: spontaneous reboots and hangs on x86_64
Date: Fri, 16 May 2008 07:17:31 +0200
User-Agent: KMail/1.9.7
Cc: Adrian Bunk <bunk@kernel.org>, kernel-testers@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200805152201.49154.m.kozlowski@tuxland.pl> <20080515203120.GF1936@cs181133002.pp.htv.fi> <20080516140625.25fac6a2.sfr@canb.auug.org.au>
In-Reply-To: <20080516140625.25fac6a2.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805160717.31618.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

> On Thu, 15 May 2008 23:31:21 +0300 Adrian Bunk <bunk@kernel.org> wrote:
> >
> > > ~/linux/linux-next $ git bisect start
> > > fatal: ref HEAD is not a symbolic ref
> > > Bad HEAD - I need a symbolic ref
> 
> This would indicate something wrong with your clone of linux-next.  How
> did you create the repository?
> 
> > > - how does one bisect on linux-next?
> 
> Any day's linux-next tree is a git tree like any other ...
> 

Hm it can be that I did something wrong but I simply followed advice seen 
in one of threads on lkml:

"
Dmitry: you cannot just "git pull" on linux-next, because each version of 
linux-next is independent of the next one. What you should do is basically

        # Set this up just once..
        git remote add linux-next git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

and then after that, you keep on just doing

        git fetch linux-next
        git checkout linux-next/master
"

This is from today:

$ git fetch linux-next
remote: Counting objects: 3749, done.
remote: Compressing objects: 100% (748/748), done.
Indexing 2309 objects...
remote: Total 2309 (delta 1918), reused 1951 (delta 1560)
 100% (2309/2309) done
Resolving 1918 deltas...
 100% (1918/1918) done
496 objects were added to complete this thin pack.
* refs/remotes/linux-next/history: fast forward to branch 'history' of git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next
  old..new: b26fb88..75f1411
* refs/remotes/linux-next/master: forcing update to non-fast forward branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next
  old...new: 703d73f...f1d3dea
* refs/remotes/linux-next/stable: fast forward to branch 'stable' of git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next
  old..new: dd28642..7371fd1
Auto-following refs/tags/next-20080516
* refs/tags/next-20080516: storing tag 'next-20080516' of git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next
  commit: f1d3dea

$ git checkout linux-next/master
HEAD is now at f1d3dea... Add linux-next specific files

$ git bisect start
fatal: ref HEAD is not a symbolic ref
Bad HEAD - I need a symbolic ref
