Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbZJ0NAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbZJ0NAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbZJ0NAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:00:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54816 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbZJ0NAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:00:10 -0400
Date: Tue, 27 Oct 2009 14:00:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 3/3] perf top: Support userspace symbols too
Message-ID: <20091027130000.GA32628@elte.hu>
References: <y> <1256592199-9608-1-git-send-email-acme@redhat.com> <1256592199-9608-2-git-send-email-acme@redhat.com> <1256592199-9608-3-git-send-email-acme@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256592199-9608-3-git-send-email-acme@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Example:
> 
> Compiling the kernel with 'make -k 22 allyesconfig'
> 
> [root@emilia linux-2.6-tip]# perf top -r 90
> ------------------------------------------------------------------------------
>    PerfTop:    3669 irqs/sec  kernel:59.9% [1000Hz cycles],  (all, 8 CPUs)
> ------------------------------------------------------------------------------
> 
>              samples  pcnt function                                 DSO
>              _______ _____ ________________________________ ________________
> 
>              3062.00  6.5% clear_page_c                     [kernel]
>              2233.00  4.8% _int_malloc                      /lib64/libc-2.5.so
>              2100.00  4.5% yylex                            /home/acme/git/build/allyesconfig/scripts/genksyms/genksyms
>              2029.00  4.3% memset                           /lib64/libc-2.5.so
>              1224.00  2.6% page_fault                       [kernel]
>              1075.00  2.3% __GI_strlen                      /lib64/libc-2.5.so
>               863.00  1.8% sub_preempt_count                [kernel]
>               822.00  1.8% __GI_memcpy                      /lib64/libc-2.5.so
>               810.00  1.7% __GI_vfprintf                    /lib64/libc-2.5.so
>               786.00  1.7% _int_free                        /lib64/libc-2.5.so
>               775.00  1.7% __GI_strcmp                      /lib64/libc-2.5.so
>               748.00  1.6% _spin_lock                       [kernel]
>               699.00  1.5% main                             /home/acme/git/build/allyesconfig/scripts/basic/fixdep
>               659.00  1.4% add_preempt_count                [kernel]
>               649.00  1.4% yyparse                          /home/acme/git/build/allyesconfig/scripts/genksyms/genksyms
>               645.00  1.4% preempt_trace                    [kernel]
>               635.00  1.4% __GI___libc_free                 /lib64/libc-2.5.so
>               597.00  1.3% trace_preempt_on                 [kernel]
>               551.00  1.2% __GI___libc_malloc               /lib64/libc-2.5.so
>               516.00  1.1% _spin_lock_irqsave               [kernel]
>               481.00  1.0% copy_user_generic_string         [kernel]
>               479.00  1.0% unmap_vmas                       [kernel]
>               429.00  0.9% _IO_file_xsputn_internal         /lib64/libc-2.5.so
>               425.00  0.9% __GI_strncpy                     /lib64/libc-2.5.so
>               416.00  0.9% get_page_from_freelist           [kernel]
>               414.00  0.9% malloc_consolidate               /lib64/libc-2.5.so
>               406.00  0.9% get_parent_ip                    [kernel]
>               362.00  0.8% __rmqueue                        [kernel]
>               347.00  0.7% in_lock_functions                [kernel]
>               316.00  0.7% __d_lookup                       [kernel]
> 
> [root@emilia linux-2.6-tip]#

That's a really nice feature! I tried it and works well here too.

	Ingo
