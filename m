Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbZKQGox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbZKQGox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 01:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZKQGox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 01:44:53 -0500
Received: from mail.gmx.net ([213.165.64.20]:45204 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753325AbZKQGow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 01:44:52 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18c1L9dZ08cvOldSsy8OkmNP3VkHCdxXwu1hSlfKM
	IDJ/ej6pWG17rE
Subject: Re: [PATCH 1/2] perf top: Introduce --hide_{user,kernel}_symbols
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20091117063332.GA8614@elte.hu>
References: <1258415125-15019-1-git-send-email-acme@infradead.org>
	 <20091117063332.GA8614@elte.hu>
Content-Type: text/plain
Date: Tue, 17 Nov 2009 07:44:55 +0100
Message-Id: <1258440295.15006.26.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 07:33 +0100, Ingo Molnar wrote:
> btw., the user symbol printouts of perf top cause some display problems 
> - such as below. The DSO printout is way too long to fit into 92 cols, 
> wrapping around in my terminal and making much of the output unreadable.
> 
> Could we cut it by default please?

An option to turn off userland would be nice too.  If you're interested
in the kernel, a display like below is.. suboptimal. (--dso?)

> Also, it would be nice to only print the basename() portion of the DSO. 
> Both the /lib64 and the /opt/crossgcc/cross/libexec/ portion is 
> repetitive and not really important in understanding perf top output. 
> There should perhaps be a 'dso-abs' symbol column that prints out the 
> full pathname?
> 
> 	Ingo
> 
> ------------->
> 
> $ echo $COLUMNS $LINES
> 92 28
> 
> $ perf top
> 
> ------------------------------------------------------------------------------
>    PerfTop:   13676 irqs/sec  kernel:14.3% [1000Hz cycles],  (all, 16 CPUs)
> ------------------------------------------------------------------------------
> 
>              samples  pcnt function                                 DSO
>              _______ _____ ________________________________ ________________
> 
>              2315.00  4.6% ht_lookup_with_hash              /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
>              2202.00  4.4% _cpp_lex_direct                  /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
>              1490.00  3.0% _int_malloc                      /lib64/libc-2.10.90.so
>              1172.00  2.3% _cpp_clean_line                  /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
>               887.00  1.8% lex_identifier                   /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
>               845.00  1.7% clear_page_c                     [kernel]
>               836.00  1.7% cpp_get_token                    /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
>               795.00  1.6% ggc_alloc_stat                   /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
>               675.00  1.3% cpp_output_token                 /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
>               675.00  1.3% __GI_memset                      /lib64/libc-2.10.90.so
>               622.00  1.2% _int_free                        /lib64/libc-2.10.90.so
>               609.00  1.2% page_fault                       [kernel]
>               568.00  1.1% gimplify_expr                    /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
>               567.00  1.1% _cpp_lex_token                   /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
>               440.00  0.9% yylex                            /home/mingo/tip/scripts/genksyms/genksyms
>               423.00  0.8% __GI___libc_malloc               /lib64/libc-2.10.90.so
>               417.00  0.8% walk_tree_1                      /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
>               416.00  0.8% __GI_memcpy                      /lib64/libc-2.10.90.so
>               377.00  0.7% enter_macro_context              /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
> 

