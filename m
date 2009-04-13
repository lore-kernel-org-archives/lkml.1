Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbZDMW3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbZDMW3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbZDMW3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:29:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38390 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbZDMW3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:29:33 -0400
Date: Tue, 14 Apr 2009 00:24:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>, Steve Dickson <steved@redhat.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Daire Byrne <Daire.Byrne@framestore.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slow_work_thread() should do the exclusive wait
Message-ID: <20090413222451.GA2758@redhat.com>
References: <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239659841.16771.26.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13, Trond Myklebust wrote:
>
> On Mon, 2009-04-13 at 23:48 +0200, Oleg Nesterov wrote:
> > On 04/13, David Howells wrote:
> > >
> > > Trond Myklebust <Trond.Myklebust@netapp.com> wrote:
> > >
> > > > Should that really be TASK_INTERRUPTIBLE? I don't see anything obvious
> > > > in the enclosing for(;;) loop that checks for or handles signals...
> > >
> > > If it were TASK_UNINTERRUPTIBLE, it would sit there in the D-state when not
> > > doing anything.  I must admit, I thought I was calling daemonize(), but that
> > > seems to have got lost somewhere.
> >
> > daemonize() is not needed, kthread_create() creates the kernel thread which
> > ignores all signals. So it doesn't matter which state we use to sleep,
> > TASK_INTERRUPTIBLE or TASK_UNINTERRUPTIBLE.
>
> Yes, but that is precisely why it is cleaner to use
> TASK_UNINTERRUPTIBLE. It documents the fact that signal handling isn't
> needed (whether or not the thread is blocking them).

Agreed. But TASK_UNINTERRUPTIBLE can confuse a user which does
"cat /proc/loadavg" on the idle machine...

Note that, for example, worker_thread() uses TASK_INTERRUPTIBLE too, and I
think for the same reason.

I dunno.

Oleg.

