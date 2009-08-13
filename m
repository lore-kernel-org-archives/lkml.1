Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbZHMMYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbZHMMYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 08:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbZHMMYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 08:24:06 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52665 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbZHMMYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 08:24:05 -0400
Subject: Re: [PROBLEM] perf report is broken in latest linus git
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       paulus@samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <1250164938.4941.2.camel@penberg-laptop>
References: <1250155708.6052.2.camel@penberg-laptop>
	 <20090813093648.GA22762@elte.hu>  <1250156837.8141.4.camel@penberg-laptop>
	 <1250163212.5241.9.camel@twins>  <1250164938.4941.2.camel@penberg-laptop>
Date: Thu, 13 Aug 2009 15:24:04 +0300
Message-Id: <1250166244.4796.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 15:02 +0300, Pekka Enberg wrote:
> On Thu, 2009-08-13 at 13:33 +0200, Peter Zijlstra wrote:
> > > > Perhaps it's this commit:
> > > > 
> > > > 4d1e00a: perf symbol: Fix symbol parsing in certain cases: use the build-id as a symlink
> > > > 
> > > > it does not revert cleanly, so you might want to check out these two 
> > > > commits:
> > > > 
> > > >   4d1e00a
> > > >   4d1e00a~1
> > > > 
> > > > and build perf on both, and check with your anomalous perf.data 
> > > > (without changing it) whether the output makes most sense.
> > > 
> > > The commit seems fine. Like I said, the perf.data file is busted even
> > > with 2.6.31-rc4 userspace so I think it's a kernel bug.
> > 
> > Hrmm, does a -tip kernel work as expected? I'll go audit the kernel
> > changes between -rc4 and -rc5.
> 
> tip/master seems to be broken too:
> 
> penberg@penberg-laptop:~/testing/jato$ perf report
> # Samples: 65806
> #
> # Overhead  Command                            Shared Object  Symbol
> # ........  .......  .......................................  ......
> #
>     64.31%     perf  /home/penberg/bin/perf                   [.] strlist__load
>      3.10%     perf  /home/penberg/bin/jato                   [.] 0x0000000000c6e8
>      1.61%     perf  [kernel]                                 [k] get_page_from_freelist
>      1.13%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] _int_malloc
>      1.11%     perf  /lib/tls/i686/cmov/libpthread-2.8.90.so  [.] 0x00000000012532
>      1.08%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] _fitoa
>      0.96%     perf                                 a7d23660  [.] 0x000000a7d23660
>      0.86%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] ____strtold_l_internal
>      0.85%     perf  /usr/lib/libz.so.1.2.3.3                 [.] 0x0000000000eef2
>      0.83%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] __GI_strcmp
>      0.74%     perf  /home/penberg/bin/jato                   [.] zalloc
>      0.69%     perf  [kernel]                                 [k] scsi_dispatch_cmd
>      0.66%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] getsubopt
>      0.56%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] __realpath
>      0.50%     perf  /usr/lib/libzip.so.1.0.0                 [.] _zip_get_name
> 
> penberg@penberg-laptop:~/src/linux/tools/perf$ git log|head -10
> commit d1fa7782b090a3ab0f55c9003d7315b5f0f5e9d6
> Merge: e93673b... daac07b...
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Thu Aug 13 10:37:33 2009 +0200
> 
>     Merge branch 'perfcounters/urgent'
> 
> commit daac07b2e6b77f1bd44104aa2f0593e5505f27d4
> Author: Frederic Weisbecker <fweisbec@gmail.com>
> Date:   Thu Aug 13 10:27:19 2009 +0200

v2.6.31-rc5 is fine:

# Samples: 62768
#
# Overhead  Command                                  Shared Object  Symbol
# ........  .......  .............................................  ......
#
    68.45%     jato  /home/penberg/bin/jato                         [.] gc_map_init
     2.08%     jato  /lib/tls/i686/cmov/libc-2.8.90.so              [.] _int_malloc
     1.79%     jato  /lib/tls/i686/cmov/libc-2.8.90.so              [.] __GI_strcmp
     1.49%     jato  [kernel]                                       [k] get_page_from_freelist
     1.33%     jato  /lib/tls/i686/cmov/libc-2.8.90.so              [.] __GI___libc_malloc
     1.11%     jato  /home/penberg/bin/jato                         [.] zalloc
     1.04%     jato                                       a7c02842  [.] 0x000000a7c02842
     0.92%     jato  /usr/lib/libzip.so.1.0.0                       [.] _zip_get_name
     0.76%     jato  /home/penberg/bin/jato                         [.] cafebabe_constant_info_utf8_compare
     0.72%     jato  /lib/tls/i686/cmov/libpthread-2.8.90.so        [.] 0x00000000007a2e
     0.64%     jato  /usr/lib/libz.so.1.2.3.3                       [.] 0x00000000001a0a
     0.53%     jato  /home/penberg/bin/jato                         [.] allocate_registers
     0.51%     jato  /home/penberg/bin/jato                         [.] analyze_liveness
     0.51%     jato  /home/penberg/bin/jato                         [.] split_interval_at


