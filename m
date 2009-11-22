Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbZKVM7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbZKVM7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbZKVM7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:59:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60201 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbZKVM7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:59:19 -0500
Date: Sun, 22 Nov 2009 13:59:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: use default compiler mode by default
Message-ID: <20091122125917.GA3366@elte.hu>
References: <20091122121335.GA24254@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091122121335.GA24254@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael S. Tsirkin <mst@redhat.com> wrote:

> gcc with no flags typically is a sane default for systems to use, and
> looking at the running kernel is probably broken for cross-builds
> anyway, so let's not do this.  Add EXTRA_CFLAGS so that users can
> override default gcc mode if they want to.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  tools/perf/Makefile |   20 +++-----------------
>  1 files changed, 3 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index d0bdaf2..ab35b0f 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -148,6 +148,8 @@ all::
>  # broken, or spawning external process is slower than built-in grep perf has).
>  #
>  # Define LDFLAGS=-static to build a static binary.
> +#
> +# Define EXTRA_CFLAGS=-m64 or EXTRA_CFLAGS=-m32 as appropriate for cross-builds.
>  
>  PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
>  	@$(SHELL_PATH) util/PERF-VERSION-GEN
> @@ -160,22 +162,6 @@ uname_R := $(shell sh -c 'uname -r 2>/dev/null || echo not')
>  uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
>  uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
>  
> -#
> -# Add -m32 for cross-builds:
> -#
> -ifdef NO_64BIT
> -  MBITS := -m32
> -else
> -  #
> -  # If we're on a 64-bit kernel (except ia64), use -m64:
> -  #
> -  ifneq ($(uname_M),ia64)
> -    ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
> -      MBITS := -m64
> -    endif
> -  endif
> -endif

iirc PowerPC had some trouble in this area. Paulus?

	Ingo
