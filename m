Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbXELLAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbXELLAj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 07:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbXELLAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 07:00:33 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49938 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242AbXELLAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 07:00:32 -0400
Date: Sat, 12 May 2007 16:22:47 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Message-ID: <20070512105247.GA30887@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200705110035.32229.rjw@sisk.pl> <200705121127.37655.rjw@sisk.pl> <20070512101317.GB8860@in.ibm.com> <200705121241.55556.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705121241.55556.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2007 at 12:41:54PM +0200, Rafael J. Wysocki wrote:
> 
> Still, the following scenario is possible while we're freezing users space
> tasks:
> 
> (1) user space task calls daemonize()
> (2) freezer checks if this is a user space task and the test returns 'true'
> (3) task calls exit_mm() and clears its TIF_FREEZE
> (4) freezer sets TIF_FREEZE for the task
> (5) task calls try_to_freeze() and freezes itself (bad!)
> 
> To prevent this from happening, I think, we should acquire task_lock() around
> the entire block in which the test is made and TIF_FREEZE is set for the task,
> so something more sophisticated than
> freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch is needed.
>

Hmmm, turns out Linus was right, after all! The caller needs to acquire
the task_lock().

> Well, I think we should ask Andrew to drop this patch and try to address the
> issue in the next series of patches.

I think it's a good idea. 

I would want to review the patches again. The more I look at them,
the better I seem to understand the subtleties in the freezer code.

> 
> Greetings,
> Rafael

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
