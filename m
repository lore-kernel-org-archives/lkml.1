Return-Path: <linux-kernel-owner+w=401wt.eu-S1765503AbZDAS0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765503AbZDAS0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 14:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762296AbZDAS0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 14:26:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49986 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707AbZDAS0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 14:26:01 -0400
Date: Wed, 1 Apr 2009 20:22:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       roland@redhat.com
Subject: Re: + signals-tracehook_notify_jctl-change.patch added to -mm tree
Message-ID: <20090401182224.GA14720@redhat.com>
References: <200903302218.n2UMIvEb004737@imap1.linux-foundation.org> <20090401123634.GI12966@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401123634.GI12966@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01, Ingo Molnar wrote:
>
> * akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
>
> > Subject: signals: tracehook_notify_jctl change
> > From: Roland McGrath <roland@redhat.com>
> >
> > This changes tracehook_notify_jctl() so it's called with the siglock held,
> > and changes its argument and return value definition.  These clean-ups
> > make it a better fit for what new tracing hooks need to check.
> >
> > Tracing needs the siglock here, held from the time TASK_STOPPED was set,
> > to avoid potential SIGCONT races if it wants to allow any blocking in its
> > tracing hooks.
> >
> > This also folds the finish_stop() function into its caller
> > do_signal_stop().  The function is short, called only once and only
> > unconditionally.  It aids readability to fold it in.
> >
> > Signed-off-by: Roland McGrath <roland@redhat.com>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
> Roland: as i have asked you before, i'd like to see explicit Ack's
> from Oleg for all ptrace patches you submit.

I agree with Roland's patch.

In my opinion, we can simplify utrace_report_jctl() a bit, but this
requires more changes in kernel/signal.c, we can do this later.

Acked-by: Oleg Nesterov <oleg@redhat.com>

