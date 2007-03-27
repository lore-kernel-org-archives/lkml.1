Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbXC0NtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbXC0NtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 09:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbXC0NtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 09:49:10 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40100 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbXC0NtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 09:49:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: g3vbv@blueyonder.co.uk
Cc: Adrian Bunk <bunk@stusta.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, auxsvr@gmail.com
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
References: <45E59D64.3070202@blueyonder.co.uk>
	<200702281805.13822.auxsvr@gmail.com>
	<20070307214730.87859590.akpm@linux-foundation.org>
	<45EFBC73.2030005@blueyonder.co.uk>
	<46016EAF.6010801@blueyonder.co.uk> <20070321193420.GP752@stusta.de>
	<m17itabbbv.fsf@ebiederm.dsl.xmission.com>
	<4601DCB4.4060804@blueyonder.co.uk>
	<20070321184258.758a5a29.randy.dunlap@oracle.com>
	<20070322105908.GS752@stusta.de> <4608919C.4050007@blueyonder.co.uk>
Date: Tue, 27 Mar 2007 07:48:42 -0600
In-Reply-To: <4608919C.4050007@blueyonder.co.uk> (Sid Boyce's message of "Tue,
	27 Mar 2007 04:38:04 +0100")
Message-ID: <m1y7liyeyt.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sid Boyce <g3vbv@blueyonder.co.uk> writes:

> This is what I've got so far on the first boot, I shall have to check the
> manpage for git-bisect again to see if there is anything else to be added,
> nothing enlightening seen so far - further reboots to be done.

I'm a little confused at what I am seeing below.
Normally what happens is that after a kernel compile and test.  You call
"git-bisect bad" or "git-bisect good" and then git-bisect picks the next
kernel to test.  Then you compile and test that one.  It looks like
you called git-bisect bad several times in a row without testing....


Eric

> barrabas:/usr/src/GIT/linux-2.6 # git bisect bad
> Bisecting: 22 revisions left to test after this
> [3fc605a2aa38899c12180ca311f1eeb61a6d867e] knfsd: allow the server to provide a
> gid list when using AUTH_UNIX authentication
> rrabas:/usr/src/GIT/linux-2.6 # git bisect bad
> Bisecting: 11 revisions left to test after this
> [ed8b4d4d7a31923db32f4684535944d69eb43677] qconf: hide empty list items
> barrabas:/usr/src/GIT/linux-2.6 #
> rrabas:/usr/src/GIT/linux-2.6 # git bisect bad
> Bisecting: 6 revisions left to test after this
> [66e7c7230fed159e138fc1292ee662b8bbdb74d6] qconf: relocate Search Command
> barrabas:/usr/src/GIT/linux-2.6 #
>
> barrabas:/usr/src/GIT/linux-2.6 # git bisect bad
> Bisecting: 3 revisions left to test after this
> [895a39a084e5478121a74752a291165c4502378f] Make mkcompile_h use LANG=C and
> LC_ALL=C for $CC -v
>
> barrabas:/usr/src/GIT/linux-2.6 # git bisect bad
> Bisecting: 2 revisions left to test after this
> [8c7e4498adfdb4aea5a0d056590ec18d099ba062] search a little harder for mkimage
>
> barrabas:/usr/src/GIT/linux-2.6 # git bisect bad
> Bisecting: 1 revisions left to test after this
> [b7de8e7e3c7b79a72c20c7fd58bd65df3d146b13] ia64: fix noncoherent DMA API so
> devres builds
>
> # git bisect bad
> b7de8e7e3c7b79a72c20c7fd58bd65df3d146b13 is first bad commit
> commit b7de8e7e3c7b79a72c20c7fd58bd65df3d146b13
> Author: Roland Dreier <rdreier@cisco.com>
> Date:   Wed Feb 14 00:32:53 2007 -0800
>
>    [PATCH] ia64: fix noncoherent DMA API so devres builds
>
>    On ia64, drivers/base/dma-mapping.c doesn't build because it calls
>    dma_alloc_noncoherent() and dma_free_noncoherent(), which appear to be
>    terminally broken; the calls end up generating errors like
>
>        drivers/base/dma-mapping.c: In function 'dmam_noncoherent_release':
>        drivers/base/dma-mapping.c:32: error: 'struct ia64_machine_vector' has no
> member named 'platform_dma_free_coherent'
>
>    because the multiple levels of macro expansion in <asm/dma-mapping.h> and
>    <asm/machvec.h> end up turning a call to dma_free_noncoherent() into
>    ia64_mv.platform_dma_free_coherent (instead of the intended
>    ia64_mv.dma_free_coherent).
>
>    This patch fixes this by converting dma_{alloc,free}_noncoherent() into
>    inline functions that call the corresponding coherent functions, instead of
>    trying to do this with macros.
>
>    Signed-off-by: Roland Dreier <rolandd@cisco.com>
>    Acked-by: Tony Luck <tony.luck@intel.com>
>    Cc: Al Viro <viro@zeniv.linux.org.uk>
>    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> :040000 040000 ac36019577dc1846a5655918cf9d6b2541c398cf
> ba536f54303cc9495b7839763ed1121d3a22154c M      include
>
> barrabas:/usr/src/GIT/linux-2.6 # git bisect bad
> 86a71dbd3e81e8870d0f0e56b87875f57e58222b
> Bisecting: 44 revisions left to test after this
> [208367eeec8d6f6fcee1a0672af2149aeee7b658] sysctl: cdrom: remove unnecessary
> insert_at_head flag
>
> barrabas:/usr/src/GIT/linux-2.6 # git bisect good
> ac98695d6c1508b724f246f38ce57fb4e3cec356
> Bisecting: 44 revisions left to test after this
> [208367eeec8d6f6fcee1a0672af2149aeee7b658] sysctl: cdrom: remove unnecessary
> insert_at_head flag
>
> Regards
> Sid.
>
> -- 
> Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
> Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support Specialist,
> Cricket Coach
> Microsoft Windows Free Zone - Linux used for all Computing Tasks
