Return-Path: <linux-kernel-owner+w=401wt.eu-S965356AbXCAQjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965356AbXCAQjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965349AbXCAQjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:39:37 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2934 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965359AbXCAQjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:39:35 -0500
Date: Thu, 1 Mar 2007 16:39:08 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH -mm 2/7] Freezer: Close theoretical race between refrigerator and thaw_tasks
Message-ID: <20070301163907.GA4710@ucw.cz>
References: <200702260800.49603.rjw@sisk.pl> <200703011605.46692.rjw@sisk.pl> <200703011608.13758.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703011608.13758.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-03-01 16:08:12, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> If the freezing of tasks fails and a task is preempted in refrigerator() before
> calling frozen_process(), then thaw_tasks() may run before this task is frozen.
> In that case the task will freeze and no one will thaw it.
> 
> To fix this race we can call freezing(current) in refrigerator() along with
> frozen_process(current) under the task_lock() which also should be taken in
> the error path of try_to_freeze_tasks() as well as in thaw_process().  Moreover,
> if thaw_process() additionally clears TIF_FREEZE for tasks that are not frozen,
> we can be sure that all tasks are thawed and there are no pending "freeze"
> requests after thaw_tasks() has run.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ack.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
