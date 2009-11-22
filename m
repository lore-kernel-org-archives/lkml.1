Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbZKVMOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbZKVMOc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbZKVMOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:14:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbZKVMOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:14:31 -0500
Date: Sun, 22 Nov 2009 14:11:45 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: support static build
Message-ID: <20091122121144.GA21562@redhat.com>
References: <20091029152002.GA5406@redhat.com> <20091104110604.GE13194@elte.hu> <20091117092331.GA23585@elte.hu> <20091122112726.GC13644@redhat.com> <20091122113942.GD13644@redhat.com> <20091122120243.GA6217@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091122120243.GA6217@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 22, 2009 at 01:02:43PM +0100, Ingo Molnar wrote:
> 
> * Michael S. Tsirkin <mst@redhat.com> wrote:
> 
> > Seems to work fine here on a 32 bit Fedora,
> > provided that I supply NO_64BIT (my kernel
> > is 64 bit with 32 bit userspace).
> > 
> > So this worked for me:
> > [perf]$ $make -s -j LDFLAGS=-static NO_64BIT=yes 
> > Makefile:498: No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231
> > PERF_VERSION = 0.0.2.PERF
> > Makefile:498: No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231
> >     * new build flags or prefix
> > /usr/lib/gcc/i586-redhat-linux/4.4.1/../../../libpthread.a(libpthread.o): In function `sem_open':
> > (.text+0x69ea): warning: the use of `mktemp' is dangerous, better use `mkstemp'
> > [perf]$ ldd perf
> >         not a dynamic executable
> >
> > Ingo, could you please apply my debugging patch and then run with V=2?
> 
> Still doesnt work here (on a 32-bit/32-bit system, F11) - i've applied 
> your debug patch and added V=2:
> 
>  earth4:~/tip/tools/perf> make -s -j LDFLAGS=-static NO_64BIT=yes V=2
>  /usr/bin/ld: cannot find -lpthread
>  collect2: ld returned 1 exit status
>  Makefile:493: *** No libelf.h/libelf found, please install 
>  libelf-dev/elfutils-libelf-devel and glibc-dev[el].  Stop.

Aha, you need to install glibc-static in fedora.
That will provide libpthread.a. Maybe add a comment
about that?

You also need zlib-static if you want libbfd to work.

Fedora does not package a static version of libdwarf,
so users will need to build that from source if they want
dwarf support in a static binary.
Fedora guidelines say:
	In general, packagers are strongly encouraged not to ship static libs
	unless a compelling reason exists. 
Do you think the ability to create a portable perf binary that
I can copy around linux systems qualify as a compelling reason?

> > Btw, why is it a good idea to force 64/32 bit mode?
> > Why not use the default gcc mode?
> 
> Sure, we could do that - mind sending a patch for that?
> 
> 	Ingo

In a minute.

