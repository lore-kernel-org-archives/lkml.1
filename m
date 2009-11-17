Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935AbZKQGdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbZKQGdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 01:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbZKQGdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 01:33:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50253 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469AbZKQGdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 01:33:50 -0500
Date: Tue, 17 Nov 2009 07:33:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] perf top: Introduce --hide_{user,kernel}_symbols
Message-ID: <20091117063332.GA8614@elte.hu>
References: <1258415125-15019-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258415125-15019-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


btw., the user symbol printouts of perf top cause some display problems 
- such as below. The DSO printout is way too long to fit into 92 cols, 
wrapping around in my terminal and making much of the output unreadable.

Could we cut it by default please?

Also, it would be nice to only print the basename() portion of the DSO. 
Both the /lib64 and the /opt/crossgcc/cross/libexec/ portion is 
repetitive and not really important in understanding perf top output. 
There should perhaps be a 'dso-abs' symbol column that prints out the 
full pathname?

	Ingo

------------->

$ echo $COLUMNS $LINES
92 28

$ perf top

------------------------------------------------------------------------------
   PerfTop:   13676 irqs/sec  kernel:14.3% [1000Hz cycles],  (all, 16 CPUs)
------------------------------------------------------------------------------

             samples  pcnt function                                 DSO
             _______ _____ ________________________________ ________________

             2315.00  4.6% ht_lookup_with_hash              /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
             2202.00  4.4% _cpp_lex_direct                  /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
             1490.00  3.0% _int_malloc                      /lib64/libc-2.10.90.so
             1172.00  2.3% _cpp_clean_line                  /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
              887.00  1.8% lex_identifier                   /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
              845.00  1.7% clear_page_c                     [kernel]
              836.00  1.7% cpp_get_token                    /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
              795.00  1.6% ggc_alloc_stat                   /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
              675.00  1.3% cpp_output_token                 /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
              675.00  1.3% __GI_memset                      /lib64/libc-2.10.90.so
              622.00  1.2% _int_free                        /lib64/libc-2.10.90.so
              609.00  1.2% page_fault                       [kernel]
              568.00  1.1% gimplify_expr                    /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
              567.00  1.1% _cpp_lex_token                   /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
              440.00  0.9% yylex                            /home/mingo/tip/scripts/genksyms/genksyms
              423.00  0.8% __GI___libc_malloc               /lib64/libc-2.10.90.so
              417.00  0.8% walk_tree_1                      /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1
              416.00  0.8% __GI_memcpy                      /lib64/libc-2.10.90.so
              377.00  0.7% enter_macro_context              /opt/crossgcc/cross/libexec/gcc/x86_64-linux/4.4.2/cc1


