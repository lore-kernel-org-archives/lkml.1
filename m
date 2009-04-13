Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382AbZDMV6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbZDMV6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZDMV6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:58:13 -0400
Received: from mx2.netapp.com ([216.240.18.37]:36773 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbZDMV6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:58:12 -0400
X-IronPort-AV: E=Sophos;i="4.40,181,1239001200"; 
   d="scan'208";a="154071355"
Subject: Re: [PATCH] slow_work_thread() should do the exclusive wait
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>, Steve Dickson <steved@redhat.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Daire Byrne <Daire.Byrne@framestore.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090413214852.GA1127@redhat.com>
References: <1239649429.16771.9.camel@heimdal.trondhjem.org>
	 <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com>
	 <20090413214852.GA1127@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Mon, 13 Apr 2009 17:57:21 -0400
Message-Id: <1239659841.16771.26.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
X-OriginalArrivalTime: 13 Apr 2009 21:58:10.0094 (UTC) FILETIME=[EF285CE0:01C9BC82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-13 at 23:48 +0200, Oleg Nesterov wrote:
> On 04/13, David Howells wrote:
> >
> > Trond Myklebust <Trond.Myklebust@netapp.com> wrote:
> >
> > > Should that really be TASK_INTERRUPTIBLE? I don't see anything obvious
> > > in the enclosing for(;;) loop that checks for or handles signals...
> >
> > If it were TASK_UNINTERRUPTIBLE, it would sit there in the D-state when not
> > doing anything.  I must admit, I thought I was calling daemonize(), but that
> > seems to have got lost somewhere.
> 
> daemonize() is not needed, kthread_create() creates the kernel thread which
> ignores all signals. So it doesn't matter which state we use to sleep,
> TASK_INTERRUPTIBLE or TASK_UNINTERRUPTIBLE.

Yes, but that is precisely why it is cleaner to use
TASK_UNINTERRUPTIBLE. It documents the fact that signal handling isn't
needed (whether or not the thread is blocking them).

Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
