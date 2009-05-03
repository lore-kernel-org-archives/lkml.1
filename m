Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbZECCFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbZECCFU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 22:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbZECCFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 22:05:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54624 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbZECCFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 22:05:02 -0400
Subject: Re: [PATCH 1/3] powerpc, Makefile: Make it possible to safely
	select CONFIG_FRAME_POINTER
From: Steven Rostedt <srostedt@redhat.com>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <68B2EF73-0FD2-41F9-966B-9A54965AFBA6@kernel.crashing.org>
References: <20090502001329.GA11549@oksana.dev.rtsoft.ru>
	 <20090502001421.GA9342@oksana.dev.rtsoft.ru>
	 <68B2EF73-0FD2-41F9-966B-9A54965AFBA6@kernel.crashing.org>
Content-Type: text/plain
Organization: Red Hat
Date: Sat, 02 May 2009 22:04:09 -0400
Message-Id: <1241316249.4243.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2009-05-02 at 21:48 +0200, Segher Boessenkool wrote:
> > This patch introduces HAVE_NORMAL_FRAME_POINTER Kconfig symbol. When
> > defined, the top level Makefile won't add -fno-omit-frame-pointer
> > cflag (the flag is useless for PowerPC kernels, and also makes gcc
> > generate wrong code).
> 
> > +++ b/arch/powerpc/Kconfig
> 
> > +	select HAVE_NORMAL_FRAME_POINTER
> 
> > +config HAVE_NORMAL_FRAME_POINTER
> > +	bool
> > +	help
> > +	  Architectures should select this symbol if their ABI implies
> > +	  having a frame pointer.
> 
> I am totally confused what you call a frame pointer here.
> None of the relevant PowerPC ABIs have a frame pointer
> separate from the stack pointer; the compiler can create
> one, of course.  A better config symbol name and help text
> would help understand this patch :-)

Yeah, I agree. This needs a better description. I only know what's going
on because I was there for the start of the discussion.

But just to be sure, this is what I think is happening.

When we add "-pg" to gcc, it automatically causes frame pointers to be
used.

But with PPC, it always has frame pointers and there's no problem.

But with Linux, when you add CONFIG_FRAME_POINTER, it automatically
adds:  -fno-omit-frame-pointer. Thus the config will add
"-fomit-frame-pointer" when CONFIG_FRAME_POINTER is not set, or it will
add "-fno-omit-frame-pointer" when it is set.

The problem with PPC is that "-fno-omit-frame-pointer" is buggy and
causes gcc to produce bad code.

Perhaps a better name would be:

HAVE_FRAME_POINTER_AS_DEFAULT

??

Or am I totally wrong in my analysis?

-- Steve


