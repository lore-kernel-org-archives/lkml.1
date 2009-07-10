Return-Path: <linux-kernel-owner+w=401wt.eu-S1751376AbZGJEB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbZGJEB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 00:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbZGJEBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 00:01:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59261 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbZGJEBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 00:01:17 -0400
Date: Fri, 10 Jul 2009 06:01:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 tip] perf report: Adjust column width to the values
	sampled
Message-ID: <20090710040104.GB5077@elte.hu>
References: <20090706192157.GA3320@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090706192157.GA3320@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
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
> [acme@doppio pahole]$  perf report --sort comm,dso,symbol | head -13
> 
>     12.79%   pahole  /usr/lib64/libdw-0.141.so    [.] __libdw_find_attr
>      8.90%   pahole  /lib64/libc-2.10.1.so        [.] _int_malloc
>      8.68%   pahole  /usr/lib64/libdw-0.141.so    [.] __libdw_form_val_len
>      8.15%   pahole  /lib64/libc-2.10.1.so        [.] __GI_strcmp
>      6.80%   pahole  /lib64/libc-2.10.1.so        [.] __tsearch
>      5.54%   pahole  ./build/libdwarves.so.1.0.0  [.] tag__recode_dwarf_type
> [acme@doppio pahole]$
> 
> [acme@doppio pahole]$  perf report --sort comm,dso,symbol -d /lib64/libc-2.10.1.so | head -10
> 
>     21.92%   pahole  /lib64/libc-2.10.1.so  [.] _int_malloc
>     20.08%   pahole  /lib64/libc-2.10.1.so  [.] __GI_strcmp
>     16.75%   pahole  /lib64/libc-2.10.1.so  [.] __tsearch
> [acme@doppio pahole]$
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Suggested-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/builtin-report.c            |   93 ++++++++++++++++++++++++--------
>  tools/perf/util/include/linux/kernel.h |    8 +++
>  tools/perf/util/symbol.c               |    1 +
>  tools/perf/util/symbol.h               |    1 +
>  4 files changed, 80 insertions(+), 23 deletions(-)

Ok, that's certainly a nice feature.

The only worry is that this makes it harder to post-process the 
output via scripts. Mind eliminating this worry and completing this 
patch by adding two other variants of this as well:

  -w, --field-width=<COLS>

  Force column width to <COLS>, for large terminal readability.

  ( Optional: perhaps also allow for special syntax -w 10,20,10 for
    separate width for separate columns. )

  -t, --field-separator=<SEP>

  Use special separator character <SEP> and dont pad with spaces, 
  and replace all occurances of '<SEP>' in symbol names (and other 
  output) with a '.' character.

  This is for easier output parsing for scripts.

	Ingo
