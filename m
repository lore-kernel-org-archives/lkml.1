Return-Path: <linux-kernel-owner+w=401wt.eu-S933434AbXLMVd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434AbXLMVd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933326AbXLMVck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:32:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54916 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933322AbXLMVci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:32:38 -0500
Date: Thu, 13 Dec 2007 22:32:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 1/3] x86: clean up asm-x86/page*.h
Message-ID: <20071213213226.GA11442@elte.hu>
References: <476030CE.4050203@goop.org> <20071213102110.GP8977@elte.hu> <47619D0D.4010909@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47619D0D.4010909@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> I can't reproduce that specific compile error, but I found & fixed a 
> couple of problems with your config.
> 
> BTW, I'm having a workflow problem using git to fetch your tree.  When 
> I do:
> 
>     $ git-pull git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git mm
>     remote: Generating pack...
>     remote: Done counting 3454 objects.
>     Result has 2947 objects.
>     remote: Deltifying 2947 objects...
>     remote:  100% (2947/2947) done
>     Indexing 2947 objects...
>     remote: Total 2947 (delta 2559), reused 2432 (delta 2066)
>      100% (2947/2947) done
>     Resolving 2559 deltas...
>      100% (2559/2559) done
>     458 objects were added to complete this thin pack.
>     Renamed arch/x86/crypto/twofish_64.c->arch/x86/crypto/twofish.c
>     Auto-merged arch/x86/crypto/twofish.c
>     Renamed arch/x86/ia32/vsyscall-syscall.S->arch/x86/vdso/vdso32/syscall.S
>     Auto-merged arch/x86/vdso/vdso32/syscall.S
>     Renamed arch/x86/kernel/ldt_32.c->arch/x86/kernel/ldt.c
>     Auto-merged arch/x86/kernel/ldt.c
>     CONFLICT (content): merge conflict in arch/x86/kernel/ldt.c
>     Renamed arch/x86/kernel/sysenter_32.c->arch/x86/vdso/vdso32-setup.c
>     Auto-merged arch/x86/vdso/vdso32-setup.c
>     Renamed arch/x86/kernel/vsyscall-int80_32.S->arch/x86/vdso/vdso32/int80.S
>     Auto-merged arch/x86/vdso/vdso32/int80.S
>     ...
>       
> 
> I haven't made any local changes and I don't want to merge anything - 
> I just want to get an up to date copy of your tree.  What am I missing 
> here?  I end up having to ssh into master.kernel.org, look at 
> linux-2.6-x86.git/refs/heads/mm and then do "git reset --hard XXX" 
> from that, which doesn't seem like the right answer...

yeah. x86.git is "history-less" tree, as it frequently shrinks and grows 
we dont want to burden upstream's history with that pach management 
noise.

This means that it's a fresh new git tree every time i update it, not 
the usual append-only git history that is a descendant of the previous 
x86.git tree that you pulled.

You can force git to non-append jump-pull the remote via changing 
.git/refs/remotes/origin/HEAD from:

 ref: refs/remotes/origin/master

to:

 ref: +refs/remotes/origin/master

or you can use git-pull --force, but IMHO it's safer to edit the refspec 
because a mistaken --force can mess up some other tree by accident. Hope 
this helps,

	Ingo
