Return-Path: <linux-kernel-owner+w=401wt.eu-S965543AbXCOMby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965543AbXCOMby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 08:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965547AbXCOMby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 08:31:54 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:25912 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965544AbXCOMbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 08:31:53 -0400
X-AuditID: d80ac287-9edd6bb000000de9-22-45f93cb826ed 
Date: Thu, 15 Mar 2007 12:31:50 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oneukum@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       gregkh@suse.de, Richard Purdie <rpurdie@rpsys.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
In-Reply-To: <20070315112725.7eadb7b7@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.64.0703151219540.12584@blonde.wat.veritas.com>
References: <20070314194337.5d439dab@gondolin.boeblingen.de.ibm.com>
 <Pine.LNX.4.44L0.0703141516150.7723-100000@iolanthe.rowland.org>
 <20070315112725.7eadb7b7@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 15 Mar 2007 12:31:51.0978 (UTC) FILETIME=[E8AD50A0:01C766FD]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, Cornelia Huck wrote:
> On Wed, 14 Mar 2007 15:23:10 -0400 (EDT),
> Alan Stern <stern@rowland.harvard.edu> wrote:
> > 
> > sysfs_work_struct is too generic; other parts of sysfs might also want to
> > use workqueues for different purposes.
> 
> > I don't like calling it "delayed"-anything, because the operations aren't
> > necessarily delayed!  On an SMP system they might even execute before the
> > sysfs_access_in_other_task() call returns.  (Although the two examples we
> > have so far can't do that because of lock contention.)
> 
> Sure. But then you shouldn't refer to "delay" in the comments for the
> functions as well :)
> 
> > The major feature added here is that the work takes place in a different 
> > task's context, not that it is delayed.  Hence the choice of names.
> 
> Hm. Perhaps device_schedule_access()?

It's really none of my business, I'm merely the reporter the
deadlock being fixed, and I don't know my way around sysfs at all ...

... but I have to say I share your discomfort with Alan's
"sysfs_access_in_other_task" naming, it sounded very weird to me.

Quite apart from this mysterious "other task", I don't understand
"access" either.

Perhaps "defer" would best capture the idea of another-task and
maybe-delay?  sysfs_defer_work(), struct sysfs_deferred_work?

Hugh
