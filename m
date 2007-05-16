Return-Path: <linux-kernel-owner+w=401wt.eu-S1762307AbXEPTkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307AbXEPTkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757309AbXEPTkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:40:04 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:28096 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036AbXEPTkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:40:01 -0400
Date: Wed, 16 May 2007 21:38:52 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Oliver Falk <oliver@linux-kernel.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] Missing defines in asm-alpha/unistd.h!?
Message-ID: <20070516193852.GA10227@osiris.ibm.com>
References: <464AC75D.1090701@linux-kernel.at> <464AD1DB.3050609@linux-kernel.at> <464AE8D1.5000500@linux-kernel.at> <464B02BC.1040101@linux-kernel.at> <464B1275.6020007@linux-kernel.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464B1275.6020007@linux-kernel.at>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> arch/alpha/kernel/built-in.o:(.data+0x2d60): undefined reference to
> >> `sys_pselect6'
> >> arch/alpha/kernel/built-in.o:(.data+0x2d68): undefined reference to
> >> `sys_ppoll'
> > 
> >> I don't understand this... Any clue(s)?
> > 
> > Needed to replace sys_pselect6 and sys_ppoll with alpha_ni_syscall... If
> > this is very correct way to fix it!? :-/
> > 
> > Can someone please have a look and correct me!?
> 
> Sergey just told me, that this is wrong. Patch is fine, but we need
> another. Please apply as well.
>
> --- linux-2.6.21.alpha/include/asm-alpha/thread_info.h.alpha_thread	2007-05-16 16:08:18.000000000 +0200
> +++ linux-2.6.21.alpha/include/asm-alpha/thread_info.h	2007-05-16 16:08:07.000000000 +0200
> @@ -76,12 +76,14 @@
>  #define TIF_UAC_NOFIX		7
>  #define TIF_UAC_SIGBUS		8
>  #define TIF_MEMDIE		9
> +#define TIF_RESTORE_SIGMASK	11
> 
>  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
>  #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
>  #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
> +#define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)

If you want to wire up pselect6 and ppoll you need to add full
TIF_RESTORE_SIGMASK support. With your patches it compiles but is broken.
Search the git commits for "TIF_RESTORE_MASK" and see how this was
implemented on other architectures.
Also you should put the alpha maintainers on cc when sending such patches.
