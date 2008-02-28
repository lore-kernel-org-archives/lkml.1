Return-Path: <linux-kernel-owner+w=401wt.eu-S1757060AbYB1FX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbYB1FX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 00:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYB1FXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 00:23:37 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:65311 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbYB1FXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 00:23:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wAg0FspTfBcwo58mtckp0Z3LhUILf6L4lNaba8+47VD4idYzjsSfFHsn2tRMS3wHGo7+QXIVEI9ZPSIPSKv1j8FZpzu1CGI/+tNVjTD6Y+vBtYXxPTbarWTOGmRmXXxkKDEhmDPwJn732gY/98aJiNF/dqFYQAp75rSloNhgGE4=
Message-ID: <5d75f4610802272123g1cb1ec52l181406be9035dd5f@mail.gmail.com>
Date: Thu, 28 Feb 2008 12:23:34 +0700
From: "BuraphaLinux Server" <buraphalinuxserver@gmail.com>
To: serge@hallyn.com
Subject: Re: at program breaks with kernel 2.6.24
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080228030053.GA25033@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d75f4610802270427y789ffae9ie2682059206eed51@mail.gmail.com>
	 <20080227181740.GA14532@vino.hallyn.com>
	 <5d75f4610802271147m77d3b3e3r4d01ecf3740a7dbb@mail.gmail.com>
	 <20080228030053.GA25033@vino.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for the patch to try.  This patch works perfectly.  Is it
safe to apply this to 2.6.24.3?  I hope it is in 2.6.24.4


On 2/28/08, serge@hallyn.com <serge@hallyn.com> wrote:
> Quoting BuraphaLinux Server (buraphalinuxserver@gmail.com):
> > This is gmail which has broken line wrapping I cannot fix. Anyway, I
> > did build the new kernel but it still does not work for me. I tried to
> > strace, but that didn't work for me either. This is as a non-root user
> > (and same 'at'/'atd' binaries work on 2.6.23.X):
> >
> > bash-3.2$ at now
> > warning: commands will be executed using /bin/sh
> > at> echo "suid is busted"
> > at> <EOT>
> > job 4 at Thu Feb 28 02:16:00 2008
> > Can't signal atd (permission denied)
> > bash-3.2$ ls -ld $(which at)
> > -rws--x--x 1 daemon daemon 36468 Jan 11 15:37 /usr/bin/at
> > bash-3.2$ ps -ef | grep atd
> > daemon 2874 1 0 02:14 ? 00:00:00 /usr/sbin/atd -b 15 -l 1
> > bozo 3054 3049 0 02:16 pts/0 00:00:00 grep atd
> > bash-3.2$ ls -ld /var/spool/at*
> > drwxrwxrwt 2 daemon daemon 4096 Feb 28 02:16 /var/spool/atjobs
> > drwx------ 2 daemon daemon 4096 Feb 27 20:02 /var/spool/atspool
> > bash-3.2$ uname -a
> > Linux zappaman.cs.buu.ac.th 2.6.25-rc3 #1 SMP Thu Feb 28 01:29:46 ICT
> > 2008 i686 pentium4 i386 GNU/Linux
> > bash-3.2$ strace -s 99999 -v -o /tmp/pain at now
> > warning: commands will be executed using /bin/sh
> > Cannot open lockfile /var/spool/atjobs/.SEQ: Permission denied
> > bash-3.2$ at now
> > warning: commands will be executed using /bin/sh
> > at> echo "hi"
> > at> <EOT>
> > job 7 at Thu Feb 28 02:19:00 2008
> > Can't signal atd (permission denied)
> >
> > My kenrel .config is big, so it is attached so I don't get any cut and
> > paste error.
> >
> > On 2/28/08, serge@hallyn.com <serge@hallyn.com> wrote:
> > > Quoting BuraphaLinux Server (buraphalinuxserver@gmail.com):
> > > > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=463669
> > > >
> > > > I have the same problem - it is not debian specific. Did the
> > > > semantics of kill() change with the new kernel? I thought as long as
> > > > something is setuid, even with capability stuff around the setuid
> > > > programs just get _all_ capabilities and would keep working.
> > > >
> > > > I did a good search and found many people with the problem, but no
> > > > solutions except going back to 2.6.23.x kernels. I guess you'll flame
> > > > me, but at least include a link to the solution too.
> > >
> > > Why would we flame you?
> >
> > Because maybe I'm doing something stupid and didn't patch/rebuild
> > something when changing kernels like I should.  I haven't had trouble
> > with at for many years of kernel changes, but 2.6.24 was the first
> > with the new security stuff and maybe I need to have some
> > capability-aware 'at' program?
> >
> > >                                          I'll just apologize as I think
> it's my fault,
> > > and ask you to please try the newest available kernel where I believe it
> > > should be fixed.
> >
> > Do I need to recompile glibc and the at software to adjust so some
> > kernel interface changes?  Did the 'make oldconfig' generate some bad
> > config combination?  As root it works, so I don't think the at or atd
> > are broken (but maybe they have to be patched for >2.6.23.X ?)
> >
> > bash-3.2$ su - root
> > Password:
> > BLS #at now
> > warning: commands will be executed using /bin/sh
> > at> echo "uh-huh..."
> > at> <EOT>
> > job 8 at Thu Feb 28 02:30:00 2008
> >
> > (and I checked and the job completes normally)
> >
> > > thanks,
> > > -serge
> >
> > Thank you for reading.  Any ideas on what to try next?
>
> I'm working on setting up something I can test this on better, but just
> for good measure can you try the following patch?  It should simply
> prevent the extra signal checks from happening.
>
> thanks,
> -serge
>
> From f48d28fe525652cb7321d5f545f9dcdfb3ce97d8 Mon Sep 17 00:00:00 2001
> From: Serge Hallyn <serge@hallyn.com>
> Date: Wed, 27 Feb 2008 20:53:47 +0000
> Subject: [PATCH 1/1] file capabilities: get rid of cap_task_kill
>
> This is just a test to not use cap_task_kill.  We will see whether
> this fixes the atd problem
>
> Signed-off-by: Serge Hallyn <serge@hallyn.com>
> ---
>  include/linux/security.h |    2 +-
>  security/capability.c    |    1 -
>  2 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/security.h b/include/linux/security.h
> index fe52cde..4c43914 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -2138,7 +2138,7 @@ static inline int security_task_kill (struct
> task_struct *p,
>  				      struct siginfo *info, int sig,
>  				      u32 secid)
>  {
> -	return cap_task_kill(p, info, sig, secid);
> +	return 0;
>  }
>
>  static inline int security_task_wait (struct task_struct *p)
> diff --git a/security/capability.c b/security/capability.c
> index 9e99f36..2c6e06d 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -40,7 +40,6 @@ static struct security_operations capability_ops = {
>  	.inode_need_killpriv =		cap_inode_need_killpriv,
>  	.inode_killpriv =		cap_inode_killpriv,
>
> -	.task_kill =			cap_task_kill,
>  	.task_setscheduler =		cap_task_setscheduler,
>  	.task_setioprio =		cap_task_setioprio,
>  	.task_setnice =			cap_task_setnice,
> --
> 1.5.2.5
>
>
>
