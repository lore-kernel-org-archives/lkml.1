Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbZI0L6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbZI0L6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 07:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbZI0L6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 07:58:32 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:40748 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbZI0L6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 07:58:31 -0400
Date: Sun, 27 Sep 2009 13:58:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tim Abbott <tabbott@ksplice.com>, Roman Zippel <zippel@linux-m68k.org>,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] m68k: Make thread_info.h usable from assembly.
Message-ID: <20090927115833.GA10316@merkur.ravnborg.org>
References: <1253119466-19488-1-git-send-email-tabbott@ksplice.com> <1253119466-19488-2-git-send-email-tabbott@ksplice.com> <10f740e80909270255y18c2840bh14c6a4ddfdb0a916@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10f740e80909270255y18c2840bh14c6a4ddfdb0a916@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 11:55:55AM +0200, Geert Uytterhoeven wrote:
> On Wed, Sep 16, 2009 at 18:44, Tim Abbott <tabbott@ksplice.com> wrote:
> > Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Roman Zippel <zippel@linux-m68k.org>
> > Cc: linux-m68k@lists.linux-m68k.org
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> > ---
> >  arch/m68k/include/asm/thread_info_mm.h |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/m68k/include/asm/thread_info_mm.h b/arch/m68k/include/asm/thread_info_mm.h
> > index b6da388..5f36cf1 100644
> > --- a/arch/m68k/include/asm/thread_info_mm.h
> > +++ b/arch/m68k/include/asm/thread_info_mm.h
> > @@ -8,6 +8,7 @@
> >  #include <asm/types.h>
> >  #include <asm/page.h>
> >
> > +#ifndef __ASSEMBLY__
> >  struct thread_info {
> >        struct task_struct      *task;          /* main task structure */
> >        unsigned long           flags;
> > @@ -16,6 +17,7 @@ struct thread_info {
> >        __u32 cpu; /* should always be 0 on m68k */
> >        struct restart_block    restart_block;
> >  };
> > +#endif /* __ASSEMBLY__ */
> >
> >  #define PREEMPT_ACTIVE         0x4000000
> 
> This is not sufficient. <asm/thread_info_mm.h> pulls in <asm/current.h>,
> which contains C only. So you also need:
> 
> --- a/arch/m68k/include/asm/thread_info_mm.h
> +++ b/arch/m68k/include/asm/thread_info_mm.h
> @@ -4,11 +4,12 @@
>  #ifndef ASM_OFFSETS_C
>  #include <asm/asm-offsets.h>
>  #endif
> -#include <asm/current.h>
>  #include <asm/types.h>
>  #include <asm/page.h>
> 
>  #ifndef __ASSEMBLY__
> +#include <asm/current.h>
> +
>  struct thread_info {
>  	struct task_struct	*task;		/* main task structure */
>  	unsigned long		flags;


upstream m68k does not build for me so I could not test.
But I think the correct fix is to drop the include or current from thread_info.
No-one except m68k needs to include current.h in thread_info.h.

	Sam
