Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbYGME2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbYGME2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 00:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbYGME2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 00:28:14 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:49136 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716AbYGME2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 00:28:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtEEALcgeUhMRKxB/2dsb2JhbACBWqZV
Date: Sun, 13 Jul 2008 00:28:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Hideo AOKI <haoki@redhat.com>,
       Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [PATCH -mm] markers: avoid call_rcu_sched if old is NULL
Message-ID: <20080713042810.GA17339@Krystal>
References: <4873CE05.2030001@redhat.com> <20080709030200.GA4378@Krystal> <20080711121842.070c1342.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080711121842.070c1342.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:25:13 up 38 days,  9:06,  3 users,  load average: 0.14, 0.31,
	0.40
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Tue, 8 Jul 2008 23:02:01 -0400 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Masami Hiramatsu (mhiramat@redhat.com) wrote:
> > > Introduce marker_entry_free_old() and check old pointer is NULL before
> > > setting call_rcu_sched(), because marker_entry_remove/add_probe() can
> > > return NULL.
> > > 
> > 
> > Hi Masami,
> > 
> > I doubt this is a bug per se, because kfree accepts NULL pointers (and
> > kfree is the only action done on the oldptr by free_old_closure).
> > 
> > This cleans up the code, so I think it's good to merge your patch, but I
> > would definitely not classify this as a bugfix.
> > 
> > Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> I cannot get this to apply on the rather dated tree which I have on this
> rather not-on-the-internet machine.  Please merge this patch locally, test,
> rewrite the changelog and resend it to someone ;)
> 

Hi Andrew,

As I pointed out in a reply to this email, I NACK this patch because it
removes a necessary quiescent state wait from the marker code. The other
reply here explains why I changed my mind about this patch.

http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-07/msg03514.html

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
