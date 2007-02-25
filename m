Return-Path: <linux-kernel-owner+w=401wt.eu-S964796AbXBYKoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796AbXBYKoZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 05:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964797AbXBYKoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 05:44:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:40390 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964796AbXBYKoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 05:44:15 -0500
Date: Sun, 25 Feb 2007 11:44:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
       ego@in.ibm.com, akpm@osdl.org, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       Aneesh Kumar <aneesh.kumar@gmail.com>
Subject: Re: [RFC][PATCH 3/7] Freezer: Close theoretical race between refrigerator and thaw_tasks
Message-ID: <20070225104412.GI2045@elf.ucw.cz>
References: <200702231116.23607.rjw@sisk.pl> <200702231121.21970.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702231121.21970.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

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

Looks ok to me.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
