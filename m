Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbZJ2HYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbZJ2HYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 03:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbZJ2HYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 03:24:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45328 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756668AbZJ2HYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 03:24:44 -0400
Date: Thu, 29 Oct 2009 08:24:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] perf tools: Delay loading symtabs till we hit a map
	with it
Message-ID: <20091029072433.GF12874@elte.hu>
References: <1256773881-4191-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256773881-4191-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> So that we can have a quicker start on perf top and even speedups in the
> other tools, as we can have maps with no hits, so no need to load its
> symtabs.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/builtin-annotate.c |    4 ++--
>  tools/perf/builtin-report.c   |    4 ++--
>  tools/perf/builtin-top.c      |    5 ++---
>  tools/perf/util/event.h       |    4 +++-
>  tools/perf/util/map.c         |   40 ++++++++++++++++++++++++----------------
>  tools/perf/util/symbol.c      |   16 +++++++++-------
>  tools/perf/util/symbol.h      |    4 ++--
>  7 files changed, 44 insertions(+), 33 deletions(-)

ok, that's a really nice feature - i noticed the occasional symtab 
loading overhead in tools.

	Ingo
