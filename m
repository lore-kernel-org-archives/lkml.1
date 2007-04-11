Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbXDKTW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbXDKTW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbXDKTW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:22:26 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57517 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997AbXDKTWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:22:24 -0400
Date: Wed, 11 Apr 2007 12:21:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] kthread: Don't depend on work queues (take 2)
Message-Id: <20070411122124.a7ce6705.akpm@linux-foundation.org>
In-Reply-To: <m1hcrmsr4g.fsf_-_@ebiederm.dsl.xmission.com>
References: <20070410185133.GA104@tv-sign.ru>
	<m13b37v517.fsf@ebiederm.dsl.xmission.com>
	<20070411000316.52f2551e.akpm@linux-foundation.org>
	<m1hcrmsr4g.fsf_-_@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 12:27:59 -0600
ebiederm@xmission.com (Eric W. Biederman) wrote:

> +	strcpy(tsk->comm, "kthreadd");

We have this dopey set_task_comm() thing which is there to avoid
races when userspace is looking at this task's name via /proc.

It obviously doesn't matter in this case, but I suppose one should
set a good example.  I'll make that change.
