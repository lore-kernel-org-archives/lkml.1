Return-Path: <linux-kernel-owner+w=401wt.eu-S1763699AbYBACEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763699AbYBACEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 21:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYBACD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 21:03:56 -0500
Received: from mx2.netapp.com ([216.240.18.37]:35443 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbYBACDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 21:03:55 -0500
X-IronPort-AV: E=Sophos;i="4.25,287,1199692800"; 
   d="dif'208?scan'208,208";a="148203510"
Subject: Re: Pull request: TASK_KILLABLE
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Liam Howlett <howlett@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802011252450.3198@www.l.google.com>
References: <20080129000447.GC31101@parisc-linux.org>
	 <alpine.LFD.1.00.0801292237480.3505@www.l.google.com>
	 <20080131234504.GB25967@parisc-linux.org>
	 <alpine.LFD.1.00.0802011146180.3198@www.l.google.com>
	 <1201830304.3087.2.camel@heimdal.trondhjem.org>
	 <alpine.LFD.1.00.0802011252450.3198@www.l.google.com>
Content-Type: multipart/mixed; boundary="=-9Ag4SAQxIMG9IexPqIh8"
Organization: Network Appliance Inc
Date: Thu, 31 Jan 2008 21:03:53 -0500
Message-Id: <1201831433.3087.14.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 01 Feb 2008 02:03:54.0083 (UTC) FILETIME=[B2540B30:01C86476]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9Ag4SAQxIMG9IexPqIh8
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Fri, 2008-02-01 at 12:54 +1100, Linus Torvalds wrote:
> No need to make that one-liner function be a GPL-only export, it's not 
> like any of the other regular sigpending functions are we export are 
> GPL-only either (dequeue_signal() is, but that is because we *really* 
> don't want people using that, and it's really about internal signal 
> handling behavior).

No. It was more in the spirit of "let's not export a function that
others may implement trivially using established interfaces". However if
you don't care, then here's a replacement.

Cheers
  Trond

--=-9Ag4SAQxIMG9IexPqIh8
Content-Description: 
Content-Type: message/rfc822
Content-Disposition: inline; filename=linux-2.6.24-000-export_fatal_signal_pending.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Thu, 31 Jan 2008 20:40:29 -0500
Subject: Ensure that we export __fatal_signal_pending()
Message-Id: <1201831343.3087.12.camel@heimdal.trondhjem.org>
Mime-Version: 1.0

It may be used by the modules nfs.ko and sunrpc.ko

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 kernel/signal.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 8054dd4..4333b6d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -998,6 +998,7 @@ int fastcall __fatal_signal_pending(struct task_struct *tsk)
 {
 	return sigismember(&tsk->pending.signal, SIGKILL);
 }
+EXPORT_SYMBOL(__fatal_signal_pending);
 
 /*
  * Must be called under rcu_read_lock() or with tasklist_lock read-held.

--=-9Ag4SAQxIMG9IexPqIh8--
