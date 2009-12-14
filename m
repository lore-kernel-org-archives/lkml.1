Return-Path: <linux-kernel-owner+w=401wt.eu-S1758329AbZLNVdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329AbZLNVdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758317AbZLNVdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:33:42 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34648 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758313AbZLNVdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:33:40 -0500
Date: Mon, 14 Dec 2009 16:33:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Warn people about flush_scheduled_work()
Message-ID: <Pine.LNX.4.44L0.0912141619410.2690-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun:

You've spent some time working on the workqueue implementation, right?  
I'd like to add comments or kerneldoc warning people about how 
dangerous it can be to use flush_scheduled_work() and related 
functions.  Something like this:

	Think twice before calling this function!  It's very easy
	to get into trouble if you don't take great care.  Either
	of the following situations will lead to deadlock:

		Your code is running in the context of a scheduled
		work routine.

		Your code or its caller holds a lock needed by
		one of the work items currently on the workqueue.

	Since you generally don't know who your caller is, what locks
	it holds, or what locks are needed by the items on the 
	workqueue, avoiding these situations is quite difficult.

	Consider using cancel_work_sync() or cancel_delayed_work_sync()
	instead.  In most situations they will accomplish what you 
	need.

Does this sound like a good idea?  Certainly flush_scheduled_work()  
is used in places where it shouldn't be.

If comments like this are added, where do you think would be a good 
place to put them?

Alan Stern

