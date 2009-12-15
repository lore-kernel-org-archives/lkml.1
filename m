Return-Path: <linux-kernel-owner+w=401wt.eu-S1757202AbZLOHYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbZLOHYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 02:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757110AbZLOHYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 02:24:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53171 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757104AbZLOHYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 02:24:50 -0500
Date: Tue, 15 Dec 2009 08:24:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Fix no-hardware-breakpoint case
Message-ID: <20091215072439.GA14651@elte.hu>
References: <20091214140326.11689.80251.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214140326.11689.80251.stgit@warthog.procyon.org.uk>
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


* David Howells <dhowells@redhat.com> wrote:

> If there is no hardware breakpoint support, modify_user_hw_breakpoint() tries
> to return a NULL pointer through as an 'int' return value:
> 
> In file included from kernel/exit.c:53:
> include/linux/hw_breakpoint.h: In function 'modify_user_hw_breakpoint':
> include/linux/hw_breakpoint.h:96: warning: return makes integer from pointer without a cast
> 
> Return 0 instead.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  include/linux/hw_breakpoint.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
> index 69f07a9..e268388 100644
> --- a/include/linux/hw_breakpoint.h
> +++ b/include/linux/hw_breakpoint.h
> @@ -93,7 +93,7 @@ register_user_hw_breakpoint(struct perf_event_attr *attr,
>  			    struct task_struct *tsk)	{ return NULL; }
>  static inline int
>  modify_user_hw_breakpoint(struct perf_event *bp,
> -			  struct perf_event_attr *attr)	{ return NULL; }
> +			  struct perf_event_attr *attr)	{ return 0; }

Note, this patch is wrong as it only papers over the warning without 
understanding the underlying bug: the right fix is to return an error code.

The latest perf update has the right fix - AFAICS Linus did the conflict 
resolution correctly so upstream should be fine.

	Ingo
