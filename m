Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbXC1EOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbXC1EOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 00:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbXC1EOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 00:14:10 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36584 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753918AbXC1EOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 00:14:09 -0400
Date: Wed, 28 Mar 2007 06:14:07 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Sid Boyce <g3vbv@blueyonder.co.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       auxsvr@gmail.com
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
Message-ID: <20070328041407.GM16477@stusta.de>
References: <45EFBC73.2030005@blueyonder.co.uk> <46016EAF.6010801@blueyonder.co.uk> <20070321193420.GP752@stusta.de> <m17itabbbv.fsf@ebiederm.dsl.xmission.com> <4601DCB4.4060804@blueyonder.co.uk> <20070321184258.758a5a29.randy.dunlap@oracle.com> <20070322105908.GS752@stusta.de> <4608919C.4050007@blueyonder.co.uk> <m1y7liyeyt.fsf@ebiederm.dsl.xmission.com> <4609E04D.408@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4609E04D.408@blueyonder.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 04:26:05AM +0100, Sid Boyce wrote:
> Eric W. Biederman wrote:
> >Sid Boyce <g3vbv@blueyonder.co.uk> writes:
> >
> >  
> >>This is what I've got so far on the first boot, I shall have to check the
> >>manpage for git-bisect again to see if there is anything else to be added,
> >>nothing enlightening seen so far - further reboots to be done.
> >>    
> >
> >I'm a little confused at what I am seeing below.
> >Normally what happens is that after a kernel compile and test.  You call
> >"git-bisect bad" or "git-bisect good" and then git-bisect picks the next
> >kernel to test.  Then you compile and test that one.  It looks like
> >you called git-bisect bad several times in a row without testing....
> >
> >
> >Eric
> >
> >  
> This is the procedure I followed.
> <--  snip  -->
> 
> # install git and cogito on your computer
> 
> # clone Linus' tree:
> cg-clone  
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 
> # start bisecting:
> cd linux-2.6
> git bisect start
> git bisect bad 86a71dbd3e81e8870d0f0e56b87875f57e58222b
> git bisect good ac98695d6c1508b724f246f38ce57fb4e3cec356
> 
> # start round
> cp /path/to/.config .
> make oldconfig
> make
> # install kernel, check whether it's good or bad, then:
> git bisect [bad|good]
> ========================================================
> I built and installed the kernel downloaded using "cg-clone", booted it 
> up  and ran "git bisect bad".  I'm also somewhat confused as the first 
> failing kernel is 2.6.20-git11, the Makefile says the kernel got with 
> cg-clone is actually 2.6.21-rc4 and it built as  2.6.20-g208367ee.
> Regards
> Sid.
> 
> >>barrabas:/usr/src/GIT/linux-2.6 # git bisect bad
> >>Bisecting: 22 revisions left to test after this
> >>[3fc605a2aa38899c12180ca311f1eeb61a6d867e] knfsd: allow the server to 
> >>provide a
> >>gid list when using AUTH_UNIX authentication
> >>rrabas:/usr/src/GIT/linux-2.6 # git bisect bad
>...

I think I got your problem:

After rebooting, you do "git bisect [bad|good]"  *once*.

Then recompile the kernel from the current tree, reboot, and again
*once* "git bisect [bad|good]".

etc.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

