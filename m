Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbZJHR1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbZJHR1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 13:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbZJHR1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 13:27:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39165 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255AbZJHR1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 13:27:10 -0400
Date: Thu, 8 Oct 2009 19:26:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>
Subject: Re: [PATCH 1/1] perf tools: Install the docs by default
Message-ID: <20091008172619.GA24985@elte.hu>
References: <1254925619-6705-1-git-send-email-acme@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254925619-6705-1-git-send-email-acme@redhat.com>
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

> So that we get matching docs when installing a new version of the tools.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>
> Suggested-by: Jesse Brandeburg <jesse.brandeburg@gmail.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/Makefile |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 5a42996..e714bd1 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -895,6 +895,7 @@ ifneq (,$X)
>  	$(foreach p,$(patsubst %$X,%,$(filter %$X,$(ALL_PROGRAMS) $(BUILT_INS) perf$X)), $(RM) '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/$p';)
>  endif
>  endif
> +	$(MAKE) -C Documentation install
>  
>  install-doc:
>  	$(MAKE) -C Documentation install

hm, i didnt want to do that because many systems dont have asciidoc and 
xmlto installed by default.

We can still do it, if you can auto-detect these two new tools and emit 
a warning (and dont build+install) documentation if they are missing - 
instead of failing the build.

	Ingo
