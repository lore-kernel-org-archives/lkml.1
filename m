Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbZKVLmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbZKVLmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 06:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbZKVLmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 06:42:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbZKVLmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 06:42:24 -0500
Date: Sun, 22 Nov 2009 13:39:42 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: support static build
Message-ID: <20091122113942.GD13644@redhat.com>
References: <20091029152002.GA5406@redhat.com> <20091104110604.GE13194@elte.hu> <20091117092331.GA23585@elte.hu> <20091122112726.GC13644@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091122112726.GC13644@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 22, 2009 at 01:27:27PM +0200, Michael S. Tsirkin wrote:
> On Tue, Nov 17, 2009 at 10:23:31AM +0100, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > * Michael S. Tsirkin <mst@redhat.com> wrote:
> > > 
> > > > This makes it possible to build perf statically, by performing make 
> > > > LDFLAGS=-static
> > > >
> > > > Since static libraries are only searched in the order they are 
> > > > specified, move library list from LDFLAGS to EXTLIBS, so that they are 
> > > > put at the end of linker command line.
> > > > 
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > ---
> > > > 
> > > > Changes in v2: updated to latest tip.
> > > 
> > > The Makefile changed again so your v2 patch is conflicting too - mind 
> > > updating it to latest -tip?
> > 
> > i've applied your patch to latest -tip and resolved the conflicts 
> > manually. Normal build works, but static one does not yet:
> > 
> >   aldebaran:~/linux/linux/tools/perf> make -j LDFLAGS=-static
> >   Makefile:484: *** No libelf.h/libelf found, please install 
> >   libelf-dev/elfutils-libelf-devel and glibc-dev[el].  Stop.
> > 
> > mind double checking my changes in
> > 
> >   http://people.redhat.com/mingo/tip.git/README
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> Looking at it.
> For now, here's a patch that shows what went
> wrong with configure.

Seems to work fine here on a 32 bit Fedora,
provided that I supply NO_64BIT (my kernel
is 64 bit with 32 bit userspace).

So this worked for me:
[perf]$ $make -s -j LDFLAGS=-static NO_64BIT=yes 
Makefile:498: No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231
PERF_VERSION = 0.0.2.PERF
Makefile:498: No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231
    * new build flags or prefix
/usr/lib/gcc/i586-redhat-linux/4.4.1/../../../libpthread.a(libpthread.o): In function `sem_open':
(.text+0x69ea): warning: the use of `mktemp' is dangerous, better use `mkstemp'
[perf]$ ldd perf
        not a dynamic executable

Ingo, could you please apply my debugging patch and then run with V=2?

Btw, why is it a good idea to force 64/32 bit mode?
Why not use the default gcc mode?

-- 
MST
