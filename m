Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbZLNXa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbZLNXa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758255AbZLNXa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:30:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:53364 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758252AbZLNXa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:30:56 -0500
Date: Mon, 14 Dec 2009 21:30:26 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 3/3] perf diff: Introduce tool to show performance
	difference
Message-ID: <20091214233026.GC21796@ghostprotocols.net>
References: <1260828571-3613-1-git-send-email-acme@infradead.org> <1260828571-3613-3-git-send-email-acme@infradead.org> <20091214224708.GF6679@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214224708.GF6679@linux.vnet.ibm.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 14, 2009 at 02:47:08PM -0800, Paul E. McKenney escreveu:
> On Mon, Dec 14, 2009 at 08:09:31PM -0200, Arnaldo Carvalho de Melo wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > I guess it is enough to show some examples:
> 
> Very cool!!!
> 
> Some questions on the numbers below...

Lets go!
 
> > [root@doppio linux-2.6-tip]# rm -f perf.data*
> > [root@doppio linux-2.6-tip]# ls -la perf.data*
> > ls: cannot access perf.data*: No such file or directory
> > [root@doppio linux-2.6-tip]# perf record -f find / > /dev/null
> > [ perf record: Woken up 1 times to write data ]
> > [ perf record: Captured and wrote 0.062 MB perf.data (~2699 samples) ]
> > [root@doppio linux-2.6-tip]# ls -la perf.data*
> > -rw------- 1 root root 74440 2009-12-14 20:03 perf.data
> > [root@doppio linux-2.6-tip]# perf record -f find / > /dev/null
> > [ perf record: Woken up 1 times to write data ]
> > [ perf record: Captured and wrote 0.062 MB perf.data (~2692 samples) ]
> > [root@doppio linux-2.6-tip]# ls -la perf.data*
> > -rw------- 1 root root 74280 2009-12-14 20:03 perf.data
> > -rw------- 1 root root 74440 2009-12-14 20:03 perf.data.old
> > [root@doppio linux-2.6-tip]# perf diff | head -5
> >    1        -34994580     /lib64/libc-2.10.1.so   _IO_vfprintf_internal
> >    2        -15307806         [kernel.kallsyms]   __kmalloc
> >    3    +1   +3665941     /lib64/libc-2.10.1.so   __GI_memmove
> >    4    +4  +23508995     /lib64/libc-2.10.1.so   _int_malloc
> >    5    +7  +38538813         [kernel.kallsyms]   __d_lookup
> 
> The first column seems to be the sequence number.  The second column is
> the change in position, in other words, __GI_memmove moved up one row?
> The third column looks like the change in profile counts.

Yeap, its something I wanted to have in this new baby, something I
followed closely for over a year while my football (or soccer, as some
region of the world calls it), i.e. what happened from the last round,
how many positions one entry moved up or down.

So, yes, __GI_memmove moved one row up, one way to double check that is
to:

perf record -i perf.data.old

in one xterm

then:

perf record

in another, and look at what happen when you flip those xterms

Yeap, its something I wanted to have in this new baby, something I
followed closely for over a year while my football (or soccer, as some
region of the world calls it), i.e. what happened from the last round,
how many positions one entry moved up or down.

So, yes, __GI_memmove moved one row up, one way to double check that is
to:

perf record -i perf.data.old

in one xterm

then:

perf record

in another, and look at what happen when you flip those xterms.

And if you want to see an html rendering of what I wanted to get coming
accross:

http://esporte.uol.com.br/futebol/campeonatos/brasileiro/2009/serie-a/classificacao.jhtm

> > [root@doppio linux-2.6-tip]# perf diff -p | head -5
> >    1        +1.00%     /lib64/libc-2.10.1.so   _IO_vfprintf_internal
> >    2                       [kernel.kallsyms]   __kmalloc
> >    3    +1             /lib64/libc-2.10.1.so   __GI_memmove
> >    4    +4             /lib64/libc-2.10.1.so   _int_malloc
> >    5    +7  -1.00%         [kernel.kallsyms]   __d_lookup
> 
> The third column is percent of total execution time?  Or percent change
> in profile ticks?  My guess is the former.

counter percentage wrt the total number of hits for that particualr
session. The unit is whatever is specified in --event, i.e. the counter
specified, whichever it is.
 
> > [root@doppio linux-2.6-tip]# perf diff -v | head -5
> >    1        361449551 326454971 -34994580     /lib64/libc-2.10.1.so   _IO_vfprintf_internal
> >    2        151009241 135701435 -15307806         [kernel.kallsyms]   __kmalloc
> >    3    +1  101805328 105471269  +3665941     /lib64/libc-2.10.1.so   __GI_memmove
> >    4    +4   78041440 101550435 +23508995     /lib64/libc-2.10.1.so   _int_malloc
> >    5    +7   59536172  98074985 +38538813         [kernel.kallsyms]   __d_lookup
> > [root@doppio linux-2.6-tip]# perf diff -vp | head -5
> >    1        9.00% 8.00% +1.00%     /lib64/libc-2.10.1.so   _IO_vfprintf_internal
> >    2        3.00% 3.00%                [kernel.kallsyms]   __kmalloc
> >    3    +1  2.00% 2.00%            /lib64/libc-2.10.1.so   __GI_memmove
> >    4    +4  2.00% 2.00%            /lib64/libc-2.10.1.so   _int_malloc
> >    5    +7  1.00% 2.00% -1.00%         [kernel.kallsyms]   __d_lookup
> 
> If these examples are all using the same numbers, then the percentages
> must be of total execution time rather than percent change in the
> profiling ticks?

Its all using the same perf.data.old + perf.data files, so the numbers
are for the default -e metrics, which is PERF_COUNT_HW_CPU_CYCLES.

> > [root@doppio linux-2.6-tip]#
> > 
> > This should be enough for diffs where the system is non volatile, i.e. when one
> > doesn't updates binaries.
> > 
> > For volatile environments, stay tuned for the next perf tool feature: a buildid
> > cache populated by 'perf record', managed by 'perf buildid-cache' a-la ccache,
> > and used by all the report tools.
> 
> For scalability studies, it would be very cool to have a ratio as well
> as a difference, but again, good stuff!!!

Point taken!

Please let me know about any other issue or suggestion you may come to!

- Arnaldo
