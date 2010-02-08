Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0BHRMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 12:12:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab0BHRML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 12:12:11 -0500
Date: Mon, 8 Feb 2010 12:11:14 -0500
From: Jason Baron <jbaron@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       fweisbec@gmail.com, mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       mhiramat@redhat.com
Subject: Re: [PATCH 5/6] syscalls: add define syscall prefix macro
Message-ID: <20100208171113.GD2688@redhat.com>
References: <cover.1265142153.git.jbaron@redhat.com> <ce5ccbcc86e34954948239b17010c5537fb62917.1265142153.git.jbaron@redhat.com> <20100203130104.GB30003@osiris.boeblingen.de.ibm.com> <20100208154856.GC2688@redhat.com> <4B704188.4020009@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B704188.4020009@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 08:53:28AM -0800, Randy Dunlap wrote:
> On 02/08/10 07:48, Jason Baron wrote:
> > On Wed, Feb 03, 2010 at 02:01:04PM +0100, Heiko Carstens wrote:
> >> On Tue, Feb 02, 2010 at 04:21:55PM -0500, Jason Baron wrote:
> >>> Add a new 'SYSCALL_PREFIX_DEFINE#()' style macro to include/linux/syscalls.h.
> >>> This allows us to create syscalls via:
> >>>
> >>> SYSCALL_PREFIX_DEFINE1(32_, mmap, struct mmap_arg_struct __user *, arg);
> >>>
> >>> The standard 'SYSCALL_DEFINE#()' macro forces 'sys_blah', but for the 32 compat
> >>> calls we want 'sys32_blah'.
> >>
> >> Not really. That's what you want for x86. But the generic name for compat syscalls
> >> is compat_sys_whatever. The arch specific compat syscalls don't follow a common
> >> naming scheme (yet).
> >> Especially if you consider the idea to get automated correct sign extension via
> >> hpa's planned script for compat syscalls it would be good if you would just name
> >> that define something like SYSCALL_COMPAT.. or COMPAT_SYSCALL..
> >> That way it would be easy to add a hook in there.
> > 
> > So I was trying to keep the names of the arch ia32 compat sys calls the
> > same, ie 'sys32_blah'. However, I agree a common naming scheme makes
> > more sense. what about 'arch_compat_sys_blah'? So as to distinguish from
> > the common compat syscalls 'compat_sys_blah'.
> 
> Hi,
> I can't find my copy of the original posting... sorry about that.
> 

http://marc.info/?l=linux-kernel&m=126514576917582&w=2

> Are these new SYSCALL macros just a shorthand/shortcut to cut down on typing
> (and/or errors)?
> 

Most of the copat syscall are currently not using the 'SYCALL_DEFINE()'
family of macros. For my purposes, the use of these macros allows them
to be tied into the event tracing system. These macros append 'sys_' to
the begging of the system call name. However, for compat syscall which
are named 'sys32_blah', these macros are not sufficient. Thus, the need
to introduce some new macros for the compat syscalls. 

> The added level of indirection makes problems for scripts/kernel-doc (well, if any of
> the syscalls have kernel-doc notation, that is).  I'd prefer not to see 2 levels of macros
> for defining a syscall, but if it has to live, please look into updating scripts/kernel-doc
> also.
> 

good point. I'll make sure the docs work properly.

thanks,

-Jason
