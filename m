Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbZHCIrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbZHCIrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 04:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbZHCIrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 04:47:09 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55068 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbZHCIrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 04:47:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 3 Aug 2009 17:45:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Paul Menage <menage@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm v2] mm: introduce oom_adj_child
Message-Id: <20090803174519.74673413.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0908030107110.30778@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907282125260.554@chino.kir.corp.google.com>
	<20090730180029.c4edcc09.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0907300219580.13674@chino.kir.corp.google.com>
	<20090730190216.5aae685a.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0907301157100.9652@chino.kir.corp.google.com>
	<20090731093305.50bcc58d.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0907310231370.25447@chino.kir.corp.google.com>
	<7f54310137837631f2526d4e335287fc.squirrel@webmail-b.css.fujitsu.com>
	<alpine.DEB.2.00.0907311212240.22732@chino.kir.corp.google.com>
	<77df8765230d9f83859fde3119a2d60a.squirrel@webmail-b.css.fujitsu.com>
	<alpine.DEB.2.00.0908011303050.22174@chino.kir.corp.google.com>
	<20090803104244.b58220ba.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0908030050160.30778@chino.kir.corp.google.com>
	<20090803170217.e98b2e46.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0908030107110.30778@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Aug 2009 01:08:42 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Mon, 3 Aug 2009, KAMEZAWA Hiroyuki wrote:
> 
> > > You can't recalculate it if all the remaining threads have a different 
> > > oom_adj value than the effective oom_adj value from the thread that is now 
> > > exited.  
> > 
> > Then, crazy google apps pass different oom_adjs to each thread ?
> > And, threads other than thread-group-leader modifies its oom_adj.
> > 
> 
> Nope, but I'm afraid you've just made my point for me: it shows that 
> oom_adj really isn't sanely used as a per-thread attribute and actually 
> only represents a preference on oom killing a quantity of memory in all 
> other cases other than vfork() -> change /proc/pid-of-child/oom_adj -> 
> exec() for which we now appropriately have /proc/pid/oom_adj_child for.
> 
Maybe you're man I can't persuade. but making progress will be necessary.

The most ugly thing which annoies me is this part. 

@@ -679,6 +679,7 @@ good_mm:                    #  a label in copy_mm.
 
 	tsk->mm = mm;
 	tsk->active_mm = mm;
+	tsk->oom_adj_child = mm->oom_adj;
 	return 0;

Why ?

I wonder oom_adj_exec "change oom_adj to this value when execve() is called"
is much more straightforward, simple and easy to understand than oom_adj_child.

"just inherit at fork, change at exec" is an usual manner, I think.
If oom_adj_exec rather than oom_adj_child, I won't complain, more.


Thanks,
-Kame



