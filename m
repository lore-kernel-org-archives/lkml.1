Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbZDMVxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbZDMVxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZDMVxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:53:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42045 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbZDMVxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:53:04 -0400
Date: Mon, 13 Apr 2009 23:48:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>, Steve Dickson <steved@redhat.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Daire Byrne <Daire.Byrne@framestore.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slow_work_thread() should do the exclusive wait
Message-ID: <20090413214852.GA1127@redhat.com>
References: <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32260.1239658818@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13, David Howells wrote:
>
> Trond Myklebust <Trond.Myklebust@netapp.com> wrote:
>
> > Should that really be TASK_INTERRUPTIBLE? I don't see anything obvious
> > in the enclosing for(;;) loop that checks for or handles signals...
>
> If it were TASK_UNINTERRUPTIBLE, it would sit there in the D-state when not
> doing anything.  I must admit, I thought I was calling daemonize(), but that
> seems to have got lost somewhere.

daemonize() is not needed, kthread_create() creates the kernel thread which
ignores all signals. So it doesn't matter which state we use to sleep,
TASK_INTERRUPTIBLE or TASK_UNINTERRUPTIBLE.

Oleg.

