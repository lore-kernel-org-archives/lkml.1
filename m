Return-Path: <linux-kernel-owner+w=401wt.eu-S1751168AbZHaJ5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168AbZHaJ5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 05:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbZHaJ5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 05:57:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59663 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbZHaJ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 05:57:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [GIT PULL, v4] S+core architecture (arch/score) support
Date: Mon, 31 Aug 2009 09:56:33 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
References: <OF0579E5F2.3B710FBD-ON48257623.002611FB-48257623.002B92AD@sunplusct.com>
In-Reply-To: <OF0579E5F2.3B710FBD-ON48257623.002611FB-48257623.002B92AD@sunplusct.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200908310956.33802.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+go7yuj8WOfCZOP6nQGk4N9AO1RoYz8dMb1YN
 hIAhiBX0HF67agPwvJPkC91yc2mpTGEF4WlATOX+X2AfVW1dhm
 gLN+E8zZbT7Y3yyCOV0lw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 August 2009 07:48:33 liqin.chen@sunplusct.com wrote:
> Arnd Bergmann <arnd@arndb.de> Ð´ÓÚ 2009-08-27 22:00:37:
> 
> > 
> > I understand your problem here, and I think it would be good
> > to have second opinion from someone else here. The four
> > #defines you mention are roughly in reverse order of importance.
> > 
> > I think you really need to remove __ARCH_WANT_SYSCALL_DEPRECATED
> > and get that working. Please tell us if some system call is
> > giving you problems and we can find a solution together.
> > 
> > Removing __ARCH_WANT_SYSCALL_OFF_T should not be too hard, because
> > glibc uses the loff_t versions by default anyway. I have not tried
> > it though, so it may be more complicated than I thought.
> > 
> 
> in __ARCH_WANT_SYSCALL_DEPRECATED,
> asm-generic/unistd.h haven't define __NR_ipc and __NR__llseek
> which used in glibc.

__NR_ipc definitely should not be defined, it is a multiplexer
for other system calls that have their own number, e.g. msgctl
and semop. Look at e.g. how parisc does it in glibc.

I'm not sure what the problem with __NR_llseek could be, AFAICT
it is defined in asm-generic/unistd.h because you take the
default __BITSPERLONG=32 definition. You should however not
see __NR_lseek, which is used only on 64 bit systems these days.

> Now we have maintained 3 sets of syscall API code use for glibc.
> 1: Old syscall interface, which linux/score system work well.

Yes, and I guess this will continue to work, but it will never
work with upstream kernels.

> 2: New syscall interface, define all 4 macro __ARCH_WANT_SYSCALL_XXX,
>         linux/score system work now, but we still debug the glibc code.
> 3: New syscall interface, without define __ARCH_WANT_SYSCALL_DEPRECATED
>         and __ARCH_WANT_SYSCALL_OFF_T, linux/score system couldn't work.
>         because glibc have many place need to fix.

Do you have a patch against the glibc git tree for score so I can look
at what needs to be done? None of the changes should be specific to
score after all, ideally it should all work without any glibc changes,
though I realize that we are not there yet.

	Arnd <><
