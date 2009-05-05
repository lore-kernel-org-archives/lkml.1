Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbZEFADg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbZEFADg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 20:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbZEFAD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 20:03:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43525 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbZEFADZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 20:03:25 -0400
Date: Wed, 6 May 2009 01:57:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: chrisw@sous-sol.org, roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ptrace: ptrace_attach: check PF_KTHREAD +
	exit_state instead of ->mm
Message-ID: <20090505235736.GA7526@redhat.com>
References: <20090505224722.GA954@redhat.com> <20090505164733.54cd4ca4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505164733.54cd4ca4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05, Andrew Morton wrote:
>
> On Wed, 6 May 2009 00:47:22 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > - Add PF_KTHREAD check to prevent attaching to the kernel thread
> >   with a borrowed ->mm.
> >
> >   With or without this change we can race with daemonize() which
> >   can set PF_KTHREAD or clear ->mm after ptrace_attach() does the
> >   check, but this doesn't matter because reparent_to_kthreadd()
> >   does ptrace_unlink().
> >
> > - Kill "!task->mm" check. We don't really care about ->mm != NULL,
> >   and the task can call exit_mm() right after we drop task_lock().
> >   What we need is to make sure we can't attach after exit_notify(),
> >   check task->exit_state != 0 instead.
> >
>
> These patches make a mess of utrace-core.patch.  Do we really want to do that?

Aaaah. Sorry! forgot to clearify...

These patches depend on

	utrace-core-kill-exclude_xtrace-logic.patch

which hopefully can be folded into utrace-core.patch. In that case these
changes do not depend on utrace, and they can go ahead of utrace.

Is this acceptable for you ?

Oleg.

