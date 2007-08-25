Return-Path: <linux-kernel-owner+w=401wt.eu-S933666AbXHYSCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666AbXHYSCy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 14:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756967AbXHYSCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 14:02:45 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56941 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176AbXHYSCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 14:02:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, samuel@sortiz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sysctl: Properly register the irda binary sysctl numbers.
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<23568.1187876026@turing-police.cc.vt.edu>
	<20070823141652.d488a6e0.akpm@linux-foundation.org>
	<m1wsvlmvu6.fsf_-_@ebiederm.dsl.xmission.com>
	<6634.1188030574@turing-police.cc.vt.edu>
	<m16433n55e.fsf@ebiederm.dsl.xmission.com>
	<2371.1188050875@turing-police.cc.vt.edu>
Date: Sat, 25 Aug 2007 11:59:53 -0600
In-Reply-To: <2371.1188050875@turing-police.cc.vt.edu> (Valdis Kletnieks's
	message of "Sat, 25 Aug 2007 10:07:55 -0400")
Message-ID: <m1wsvjlckm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu writes:

> On Sat, 25 Aug 2007 06:57:17 MDT, Eric W. Biederman said:
>
>> It's good to have confirmation that my sysctl_check routine
>> didn't find something else wrong.
>
> If I understand the code, anything it whinges about is either an outright bug
> or it's a round of ammo already chambered. ;)

Pretty much.  The heuristics aren't prefect but they are pretty good.

> As far as "something else wrong", I'm still seeing these in -rc3-mm1, but
> they've been reported before against -rc2-mm2, I think:

Interesting.  No I haven't seen this one.  This appears to be one of
those silly little corner cases I failed to account for in my checks.
It looks like you don't have CONFIG_SYSCTL_SYSCALL defined, and it
appears utsname_syscall and ipcdata_syscall both become NULL pointers
if they aren't needed.  So the complaint is a false positive.

> [    0.628000] sysctl table check failed: /kernel/ostype .1.1 Missing strategy
> [ 0.628000] sysctl table check failed: /kernel/osrelease .1.2 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/version .1.4 Missing strategy
> [ 0.628000] sysctl table check failed: /kernel/hostname .1.7 Missing strategy
> [ 0.628000] sysctl table check failed: /kernel/domainname .1.8 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/shmmax .1.34 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/shmall .1.41 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/shmmni .1.45 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/msgmax .1.35 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/msgmni .1.42 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/msgmnb .1.36 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/sem .1.43 Missing strategy
>
> And this isn't on an allyesconfig or allmodconfig. There may well be sysctl
> code I didn't hit - my /lib/modules/2.6.23-rc3-mm1 is only about 10M, and
> the Fedora kernels are weighing in at about 75M of /lib/modules a
> pop.

Yes.  Thank you.  I figure as long as we are reasonably close people
we should catch most if not all things before this is merged into
Linus's tree.

Patch in a moment.

Eric
