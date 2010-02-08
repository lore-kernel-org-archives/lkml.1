Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab0BHPtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 10:49:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab0BHPtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 10:49:49 -0500
Date: Mon, 8 Feb 2010 10:48:56 -0500
From: Jason Baron <jbaron@redhat.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       rostedt@goodmis.org, fweisbec@gmail.com, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com
Subject: Re: [PATCH 5/6] syscalls: add define syscall prefix macro
Message-ID: <20100208154856.GC2688@redhat.com>
References: <cover.1265142153.git.jbaron@redhat.com> <ce5ccbcc86e34954948239b17010c5537fb62917.1265142153.git.jbaron@redhat.com> <20100203130104.GB30003@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203130104.GB30003@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 02:01:04PM +0100, Heiko Carstens wrote:
> On Tue, Feb 02, 2010 at 04:21:55PM -0500, Jason Baron wrote:
> > Add a new 'SYSCALL_PREFIX_DEFINE#()' style macro to include/linux/syscalls.h.
> > This allows us to create syscalls via:
> > 
> > SYSCALL_PREFIX_DEFINE1(32_, mmap, struct mmap_arg_struct __user *, arg);
> > 
> > The standard 'SYSCALL_DEFINE#()' macro forces 'sys_blah', but for the 32 compat
> > calls we want 'sys32_blah'.
> 
> Not really. That's what you want for x86. But the generic name for compat syscalls
> is compat_sys_whatever. The arch specific compat syscalls don't follow a common
> naming scheme (yet).
> Especially if you consider the idea to get automated correct sign extension via
> hpa's planned script for compat syscalls it would be good if you would just name
> that define something like SYSCALL_COMPAT.. or COMPAT_SYSCALL..
> That way it would be easy to add a hook in there.

So I was trying to keep the names of the arch ia32 compat sys calls the
same, ie 'sys32_blah'. However, I agree a common naming scheme makes
more sense. what about 'arch_compat_sys_blah'? So as to distinguish from
the common compat syscalls 'compat_sys_blah'.

thanks,

-Jason
