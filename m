Return-Path: <linux-kernel-owner+w=401wt.eu-S1759913AbXIZOjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913AbXIZOjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 10:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbXIZOjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 10:39:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:32893 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753491AbXIZOjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 10:39:11 -0400
Date: Wed, 26 Sep 2007 10:39:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: Jonathan Corbet <corbet@lwn.net>, <ebiederm@xmission.com>,
       <cornelia.huck@de.ibm.com>, <greg@kroah.com>, <kay.sievers@vrfy.org>,
       <linux-kernel@vger.kernel.org>, <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload()
In-Reply-To: <46F996AD.2070107@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0709261037390.4267-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007, Tejun Heo wrote:

> >> Hmmm... I might be missing something here.  Who else can wake up a
> >> thread in uninterruptible sleep?
> > 
> > In principle, anything can.  There has never been any guarantee in the 
> > kernel that a task sleeping on a waitqueue will remain asleep until 
> > the waitqueue is signalled.  That's part of the reason why things like 
> > __wait_event() are coded as loops.
> 
> Hmmm... I always thought the queue was because the condition can change
> inbetween waking up and actually running.  For example, if the condition
> is !(queue empty), another task can enter the critical section and
> consume the element which triggered wake up before the woken up task do.

That's the other part of the reason for using a loop.  :-)

Alan Stern

