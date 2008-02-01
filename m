Return-Path: <linux-kernel-owner+w=401wt.eu-S1764584AbYBABpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764584AbYBABpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 20:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYBABpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 20:45:38 -0500
Received: from mx2.netapp.com ([216.240.18.37]:20353 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbYBABph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 20:45:37 -0500
X-IronPort-AV: E=Sophos;i="4.25,287,1199692800"; 
   d="dif'208?scan'208,208";a="148200030"
Subject: Re: Pull request: TASK_KILLABLE
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Liam Howlett <howlett@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802011146180.3198@www.l.google.com>
References: <20080129000447.GC31101@parisc-linux.org>
	 <alpine.LFD.1.00.0801292237480.3505@www.l.google.com>
	 <20080131234504.GB25967@parisc-linux.org>
	 <alpine.LFD.1.00.0802011146180.3198@www.l.google.com>
Content-Type: multipart/mixed; boundary="=-CFP+viqGudrT/581QzgQ"
Organization: Network Appliance Inc
Date: Thu, 31 Jan 2008 20:45:04 -0500
Message-Id: <1201830304.3087.2.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 01 Feb 2008 01:45:06.0067 (UTC) FILETIME=[11FA7630:01C86474]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CFP+viqGudrT/581QzgQ
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Fri, 2008-02-01 at 11:48 +1100, Linus Torvalds wrote:
> 
> On Thu, 31 Jan 2008, Matthew Wilcox wrote:
> > 
> > To allow tasks to be interrupted by fatal signals, we introduce a new
> > TASK_* bit; TASK_WAKEKILL.  We also add a predicate fatal_signal_pending;
> > the counterpart of signal_pending().  Then we add killable versions
> > of lock_page(), mutex_lock(), schedule_timeout(), wait_event(), and
> > wait_for_completion().  Finally, we can make the NFS 'intr' mount option
> > a no-op.
> 
> Ok, I've pulled this. It conflicted with some NFS changes, but I did what 
> appeared to be the obvious conflict resolution, and it all at least 
> compiles and it looked sane to me. But I don't have NFS enabled normally, 
> and I certainly don't have a good way to test with my laptop while in 
> Melbourne, so Trond/Matthew, can you please double- and triple-check my 
> merge?

Hmm... The current code won't compile as a module. We're at least going
to require something like the attached patch.

Cheers
  Trond

--=-CFP+viqGudrT/581QzgQ
Content-Disposition: inline; filename=linux-2.6.24-000-export_fatal_signal_pending.dif
Content-Type: message/rfc822; name=linux-2.6.24-000-export_fatal_signal_pending.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Thu, 31 Jan 2008 20:40:29 -0500
Subject: Ensure that we export __fatal_signal_pending()
Message-Id: <1201830304.3087.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0

It may be used by the modules nfs.ko and sunrpc.ko

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 kernel/signal.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 8054dd4..1f2d4e1 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -998,6 +998,7 @@ int fastcall __fatal_signal_pending(struct task_struct *tsk)
 {
 	return sigismember(&tsk->pending.signal, SIGKILL);
 }
+EXPORT_SYMBOL_GPL(__fatal_signal_pending);
 
 /*
  * Must be called under rcu_read_lock() or with tasklist_lock read-held.

--=-CFP+viqGudrT/581QzgQ--
