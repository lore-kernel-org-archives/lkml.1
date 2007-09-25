Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbXIYPJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbXIYPJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbXIYPJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:09:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42297 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753161AbXIYPJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:09:08 -0400
Date: Tue, 25 Sep 2007 11:09:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: Jonathan Corbet <corbet@lwn.net>, <ebiederm@xmission.com>,
       <cornelia.huck@de.ibm.com>, <greg@kroah.com>, <kay.sievers@vrfy.org>,
       <linux-kernel@vger.kernel.org>, <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload()
In-Reply-To: <46F91B72.1080109@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0709251105540.3909-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007, Tejun Heo wrote:

> Alan Stern wrote:
> >> The unloading can proceed once module_unload_inhibit_cnt reaches zero.
> >> An unloading thread only has to care about inhibition put in effect
> >> before unloading has started, so there's no need to check again.
> > 
> > You haven't fully answered Jon's question.  Suppose
> > module_unload_inhibit_cnt is nonzero, so the task adds itself to the
> > module_unload_wait queue, changes to TASK_UNINTERRUPTIBLE, and calls
> > schedule.  There's nothing to prevent somebody else from waking the
> > task back up before the original inhibition has been lifted.
> 
> Hmmm... I might be missing something here.  Who else can wake up a
> thread in uninterruptible sleep?

In principle, anything can.  There has never been any guarantee in the 
kernel that a task sleeping on a waitqueue will remain asleep until 
the waitqueue is signalled.  That's part of the reason why things like 
__wait_event() are coded as loops.

Alan Stern

