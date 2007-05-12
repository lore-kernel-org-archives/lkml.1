Return-Path: <linux-kernel-owner+w=401wt.eu-S1758782AbXELL3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782AbXELL3q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 07:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbXELL3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 07:29:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34644 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323AbXELL3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 07:29:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Date: Sat, 12 May 2007 13:34:16 +0200
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200705110035.32229.rjw@sisk.pl> <200705121241.55556.rjw@sisk.pl> <20070512105247.GA30887@in.ibm.com>
In-Reply-To: <20070512105247.GA30887@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705121334.17565.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 12 May 2007 12:52, Gautham R Shenoy wrote:
> On Sat, May 12, 2007 at 12:41:54PM +0200, Rafael J. Wysocki wrote:
> > 
> > Still, the following scenario is possible while we're freezing users space
> > tasks:
> > 
> > (1) user space task calls daemonize()
> > (2) freezer checks if this is a user space task and the test returns 'true'
> > (3) task calls exit_mm() and clears its TIF_FREEZE
> > (4) freezer sets TIF_FREEZE for the task
> > (5) task calls try_to_freeze() and freezes itself (bad!)
> > 
> > To prevent this from happening, I think, we should acquire task_lock() around
> > the entire block in which the test is made and TIF_FREEZE is set for the task,
> > so something more sophisticated than
> > freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch is needed.
> >
> 
> Hmmm, turns out Linus was right, after all! The caller needs to acquire
> the task_lock().
> 
> > Well, I think we should ask Andrew to drop this patch and try to address the
> > issue in the next series of patches.
> 
> I think it's a good idea. 
> 
> I would want to review the patches again. The more I look at them,
> the better I seem to understand the subtleties in the freezer code.

Okay, I'll put the entire series on the web later today and I'll let you know
when it's ready.

Andrew, could you please drop
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch?

I believe that the other six freezer patches currently in -mm are correct.

Greetings,
Rafael
