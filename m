Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab0BCNBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 08:01:11 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:47333 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257Ab0BCNBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 08:01:07 -0500
Date: Wed, 3 Feb 2010 14:01:04 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       rostedt@goodmis.org, fweisbec@gmail.com, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com
Subject: Re: [PATCH 5/6] syscalls: add define syscall prefix macro
Message-ID: <20100203130104.GB30003@osiris.boeblingen.de.ibm.com>
References: <cover.1265142153.git.jbaron@redhat.com>
 <ce5ccbcc86e34954948239b17010c5537fb62917.1265142153.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce5ccbcc86e34954948239b17010c5537fb62917.1265142153.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 04:21:55PM -0500, Jason Baron wrote:
> Add a new 'SYSCALL_PREFIX_DEFINE#()' style macro to include/linux/syscalls.h.
> This allows us to create syscalls via:
> 
> SYSCALL_PREFIX_DEFINE1(32_, mmap, struct mmap_arg_struct __user *, arg);
> 
> The standard 'SYSCALL_DEFINE#()' macro forces 'sys_blah', but for the 32 compat
> calls we want 'sys32_blah'.

Not really. That's what you want for x86. But the generic name for compat syscalls
is compat_sys_whatever. The arch specific compat syscalls don't follow a common
naming scheme (yet).
Especially if you consider the idea to get automated correct sign extension via
hpa's planned script for compat syscalls it would be good if you would just name
that define something like SYSCALL_COMPAT.. or COMPAT_SYSCALL..
That way it would be easy to add a hook in there.
