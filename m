Return-Path: <linux-kernel-owner+w=401wt.eu-S1757728AbYG3UCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728AbYG3UCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYG3UB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:01:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752895AbYG3UB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:01:59 -0400
Date: Wed, 30 Jul 2008 13:01:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: vapier.adi@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blackfin / h8300 build error fix
Message-Id: <20080730130117.3495cba9.akpm@linux-foundation.org>
In-Reply-To: <87hca7npmp.wl%ysato@users.sourceforge.jp>
References: <87provuzwk.wl%ysato@users.sourceforge.jp>
	<8bd0f97a0807300911n4ae81b70v97276abf612f6b3e@mail.gmail.com>
	<87hca7npmp.wl%ysato@users.sourceforge.jp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 15:22:38 -0400
Yoshinori Sato <ysato@users.sourceforge.jp> wrote:

> At Wed, 30 Jul 2008 12:11:37 -0400,
> Mike Frysinger wrote:
> > 
> > On Wed, Jul 30, 2008 at 11:58 AM, Yoshinori Sato wrote:
> > > init/main.c:781: undefined reference to `___early_initcall_end'
> > >
> > > Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
> > >
> > > ---
> > >  include/asm-generic/vmlinux.lds.h |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> > > index 6d88a92..07b2784 100644
> > > --- a/include/asm-generic/vmlinux.lds.h
> > > +++ b/include/asm-generic/vmlinux.lds.h
> > > @@ -362,7 +362,7 @@
> > >
> > >  #define INITCALLS                                                      \
> > >        *(.initcallearly.init)                                          \
> > > -       __early_initcall_end = .;                                       \
> > > +       VMLINUX_SYMBOL(__early_initcall_end) = .;                       \
> > >        *(.initcall0.init)                                              \
> > >        *(.initcall0s.init)                                             \
> > >        *(.initcall1.init)                                              \
> > > --
> > > 1.5.6.3
> > 
> > nice catch, thanks ... looks like BUG_TABLE, TRACEDATA, and PERCPU are
> > also broken, but blackfin/etc... arent using those which is why we
> > havent noticed yet ...
> > -mike
> 
> Thanks.
> I fixed same.
> 
> Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
> 
>  include/asm-generic/vmlinux.lds.h |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 6d88a92..04cae96 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -333,9 +333,9 @@
>  #define BUG_TABLE							\
>  	. = ALIGN(8);							\
>  	__bug_table : AT(ADDR(__bug_table) - LOAD_OFFSET) {		\
> -		__start___bug_table = .;				\
> +		VMLINUX_SYMBOL(__start___bug_table) = .;		\
>  		*(__bug_table)						\
> -		__stop___bug_table = .;					\
> +		VMLINUX_SYMBOL(__stop___bug_table) = .;			\
>  	}

Sorry, but I haven't been following this topic very well and I rather
dislike plucking unchangelogged patches out of the middle of email
discussions.

If there's some patch which I should be applying then please resend it,
with a meaningful title, a description of what it does, etc.

Thanks.
