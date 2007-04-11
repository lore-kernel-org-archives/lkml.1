Return-Path: <linux-kernel-owner+w=401wt.eu-S1030419AbXDKUEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030419AbXDKUEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 16:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030420AbXDKUED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 16:04:03 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59897 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030342AbXDKUEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 16:04:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] kthread: Don't depend on work queues (take 2)
References: <20070410185133.GA104@tv-sign.ru>
	<m13b37v517.fsf@ebiederm.dsl.xmission.com>
	<20070411000316.52f2551e.akpm@linux-foundation.org>
	<m1hcrmsr4g.fsf_-_@ebiederm.dsl.xmission.com>
	<20070411192809.GA106@tv-sign.ru>
	<m14pnmsnrs.fsf@ebiederm.dsl.xmission.com>
	<20070411194921.GA171@tv-sign.ru>
Date: Wed, 11 Apr 2007 14:02:24 -0600
In-Reply-To: <20070411194921.GA171@tv-sign.ru> (Oleg Nesterov's message of
	"Wed, 11 Apr 2007 23:49:21 +0400")
Message-ID: <m1zm5er86n.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> Ah yes, we still need to export kthreadd_task... I just worried about subtle
> dependency this patch adds... This "kthreadd_task = find_task_by_pid" assumes
> that init/main.c:init() takes lock_kernel() before the first kthread_create().

There is a small element of that.  Mostly it assumes we are running in the idle
thread until we call schedule.  Anyway the assumption and the code is out
there in the open in the main code path so it is easy to find, and the code works
today.

At this point I am queuing up patches that kill daemonize.  I will be
happy to revisit this part once daemonize is gone and the only interesting
file is kthread.c

Eric
