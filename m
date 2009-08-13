Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbZHMMCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbZHMMCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 08:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbZHMMCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 08:02:20 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43588 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZHMMCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 08:02:19 -0400
Subject: Re: [PROBLEM] perf report is broken in latest linus git
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       paulus@samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <1250163212.5241.9.camel@twins>
References: <1250155708.6052.2.camel@penberg-laptop>
	 <20090813093648.GA22762@elte.hu>  <1250156837.8141.4.camel@penberg-laptop>
	 <1250163212.5241.9.camel@twins>
Date: Thu, 13 Aug 2009 15:02:18 +0300
Message-Id: <1250164938.4941.2.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 13:33 +0200, Peter Zijlstra wrote:
> > > Perhaps it's this commit:
> > > 
> > > 4d1e00a: perf symbol: Fix symbol parsing in certain cases: use the build-id as a symlink
> > > 
> > > it does not revert cleanly, so you might want to check out these two 
> > > commits:
> > > 
> > >   4d1e00a
> > >   4d1e00a~1
> > > 
> > > and build perf on both, and check with your anomalous perf.data 
> > > (without changing it) whether the output makes most sense.
> > 
> > The commit seems fine. Like I said, the perf.data file is busted even
> > with 2.6.31-rc4 userspace so I think it's a kernel bug.
> 
> Hrmm, does a -tip kernel work as expected? I'll go audit the kernel
> changes between -rc4 and -rc5.

tip/master seems to be broken too:

penberg@penberg-laptop:~/testing/jato$ perf report
# Samples: 65806
#
# Overhead  Command                            Shared Object  Symbol
# ........  .......  .......................................  ......
#
    64.31%     perf  /home/penberg/bin/perf                   [.] strlist__load
     3.10%     perf  /home/penberg/bin/jato                   [.] 0x0000000000c6e8
     1.61%     perf  [kernel]                                 [k] get_page_from_freelist
     1.13%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] _int_malloc
     1.11%     perf  /lib/tls/i686/cmov/libpthread-2.8.90.so  [.] 0x00000000012532
     1.08%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] _fitoa
     0.96%     perf                                 a7d23660  [.] 0x000000a7d23660
     0.86%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] ____strtold_l_internal
     0.85%     perf  /usr/lib/libz.so.1.2.3.3                 [.] 0x0000000000eef2
     0.83%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] __GI_strcmp
     0.74%     perf  /home/penberg/bin/jato                   [.] zalloc
     0.69%     perf  [kernel]                                 [k] scsi_dispatch_cmd
     0.66%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] getsubopt
     0.56%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] __realpath
     0.50%     perf  /usr/lib/libzip.so.1.0.0                 [.] _zip_get_name

penberg@penberg-laptop:~/src/linux/tools/perf$ git log|head -10
commit d1fa7782b090a3ab0f55c9003d7315b5f0f5e9d6
Merge: e93673b... daac07b...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Aug 13 10:37:33 2009 +0200

    Merge branch 'perfcounters/urgent'

commit daac07b2e6b77f1bd44104aa2f0593e5505f27d4
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Thu Aug 13 10:27:19 2009 +0200

			Pekka


