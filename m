Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbZLOFvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbZLOFvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 00:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZLOFvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 00:51:38 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39405 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbZLOFvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 00:51:37 -0500
Date: Mon, 14 Dec 2009 21:51:33 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 3/3] perf diff: Introduce tool to show performance
	difference
Message-ID: <20091215055133.GA6759@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1260828571-3613-1-git-send-email-acme@infradead.org> <1260828571-3613-3-git-send-email-acme@infradead.org> <20091214224708.GF6679@linux.vnet.ibm.com> <20091214233026.GC21796@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214233026.GC21796@ghostprotocols.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 09:30:26PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Mon, Dec 14, 2009 at 02:47:08PM -0800, Paul E. McKenney escreveu:
> > On Mon, Dec 14, 2009 at 08:09:31PM -0200, Arnaldo Carvalho de Melo wrote:
> > > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > 
> > > I guess it is enough to show some examples:
> > 
> > Very cool!!!
> > 
> > Some questions on the numbers below...
> 
> Lets go!

[ . . . ]

Thank you for the info!!!

> in another, and look at what happen when you flip those xterms.
> 
> And if you want to see an html rendering of what I wanted to get coming
> accross:
> 
> http://esporte.uol.com.br/futebol/campeonatos/brasileiro/2009/serie-a/classificacao.jhtm

Differential profiling applied to soccer statistics...  No -there- is a
scary thought!!!  ;-)

							Thanx, Paul

> > > [root@doppio linux-2.6-tip]# perf diff -p | head -5
> > >    1        +1.00%     /lib64/libc-2.10.1.so   _IO_vfprintf_internal
> > >    2                       [kernel.kallsyms]   __kmalloc
> > >    3    +1             /lib64/libc-2.10.1.so   __GI_memmove
> > >    4    +4             /lib64/libc-2.10.1.so   _int_malloc
> > >    5    +7  -1.00%         [kernel.kallsyms]   __d_lookup
> > 
> > The third column is percent of total execution time?  Or percent change
> > in profile ticks?  My guess is the former.
> 
> counter percentage wrt the total number of hits for that particualr
> session. The unit is whatever is specified in --event, i.e. the counter
> specified, whichever it is.
> 
> > > [root@doppio linux-2.6-tip]# perf diff -v | head -5
> > >    1        361449551 326454971 -34994580     /lib64/libc-2.10.1.so   _IO_vfprintf_internal
> > >    2        151009241 135701435 -15307806         [kernel.kallsyms]   __kmalloc
> > >    3    +1  101805328 105471269  +3665941     /lib64/libc-2.10.1.so   __GI_memmove
> > >    4    +4   78041440 101550435 +23508995     /lib64/libc-2.10.1.so   _int_malloc
> > >    5    +7   59536172  98074985 +38538813         [kernel.kallsyms]   __d_lookup
> > > [root@doppio linux-2.6-tip]# perf diff -vp | head -5
> > >    1        9.00% 8.00% +1.00%     /lib64/libc-2.10.1.so   _IO_vfprintf_internal
> > >    2        3.00% 3.00%                [kernel.kallsyms]   __kmalloc
> > >    3    +1  2.00% 2.00%            /lib64/libc-2.10.1.so   __GI_memmove
> > >    4    +4  2.00% 2.00%            /lib64/libc-2.10.1.so   _int_malloc
> > >    5    +7  1.00% 2.00% -1.00%         [kernel.kallsyms]   __d_lookup
> > 
> > If these examples are all using the same numbers, then the percentages
> > must be of total execution time rather than percent change in the
> > profiling ticks?
> 
> Its all using the same perf.data.old + perf.data files, so the numbers
> are for the default -e metrics, which is PERF_COUNT_HW_CPU_CYCLES.
> 
> > > [root@doppio linux-2.6-tip]#
> > > 
> > > This should be enough for diffs where the system is non volatile, i.e. when one
> > > doesn't updates binaries.
> > > 
> > > For volatile environments, stay tuned for the next perf tool feature: a buildid
> > > cache populated by 'perf record', managed by 'perf buildid-cache' a-la ccache,
> > > and used by all the report tools.
> > 
> > For scalability studies, it would be very cool to have a ratio as well
> > as a difference, but again, good stuff!!!
> 
> Point taken!
> 
> Please let me know about any other issue or suggestion you may come to!
> 
> - Arnaldo
