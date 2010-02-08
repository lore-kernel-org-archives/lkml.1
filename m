Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0BHPoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 10:44:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab0BHPoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 10:44:37 -0500
Date: Mon, 8 Feb 2010 10:43:25 -0500
From: Jason Baron <jbaron@redhat.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       rostedt@goodmis.org, fweisbec@gmail.com, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com
Subject: Re: [PATCH 4/6] tracing: add tracing support for compat syscalls
Message-ID: <20100208154325.GB2688@redhat.com>
References: <cover.1265142153.git.jbaron@redhat.com> <bec426992cb9ab8f8abe07efb2baa785577a3855.1265142153.git.jbaron@redhat.com> <20100203125251.GA30003@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203125251.GA30003@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 01:52:51PM +0100, Heiko Carstens wrote:
> On Tue, Feb 02, 2010 at 04:21:51PM -0500, Jason Baron wrote:
> > Add core support to event tracing for compat syscalls. The basic idea is that we
> > check if we have a compat task via 'is_compat_task()'. If so, we lookup in the
> > new compat_syscalls_metadata table, the corresponding struct syscall_metadata, to
> > check syscall arguments and whether or not we are enabled.
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > ---
> >  include/linux/compat.h        |    8 +++++
> >  include/trace/syscall.h       |    4 ++
> >  kernel/trace/trace.h          |    2 +
> >  kernel/trace/trace_syscalls.c |   63 +++++++++++++++++++++++++++++++++++-----
> >  4 files changed, 69 insertions(+), 8 deletions(-)
> > 
> > diff --git a/include/linux/compat.h b/include/linux/compat.h
> > index ef68119..ab2cda2 100644
> > --- a/include/linux/compat.h
> > +++ b/include/linux/compat.h
> > @@ -353,5 +353,13 @@ asmlinkage long compat_sys_newfstatat(unsigned int dfd, char __user * filename,
> >  asmlinkage long compat_sys_openat(unsigned int dfd, const char __user *filename,
> >  				  int flags, int mode);
> > 
> > +#else /* CONFIG_COMPAT */
> > +
> > +#define NR_syscalls_compat 0
> > +static inline int is_compat_task(void)
> > +{
> > +	return 0;
> > +}
> > +
> >  #endif /* CONFIG_COMPAT */
> >  #endif /* _LINUX_COMPAT_H */
> 
> This part will break compilation on s390, since it has already the same
> function defined for !CONFIG_COMPAT.

If multiple arches want this definition, then it seems the the common
include/linux/compat.h is good place for it.

> In order to avoid the whole ifdef mess some s390 files do include
> asm/compat.h instead of linux/compat.h. This will get messy :)

is there a way for s390 to use the common include/linux/compat.h file?
what other arch defs are required? 

thanks,

-Jason
