Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbZKIUq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbZKIUq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 15:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbZKIUq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 15:46:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52501 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706AbZKIUqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 15:46:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Help needed: Resume problems in 2.6.32-rc, perhaps related to preempt_count leakage in keventd
Date: Mon, 9 Nov 2009 21:48:03 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31.5-tst; KDE/4.3.1; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0911091527390.2858-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0911091527390.2858-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911092148.03815.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 November 2009, Alan Stern wrote:
> On Mon, 9 Nov 2009, Rafael J. Wysocki wrote:
> 
> > Still, RIP always points to list_del_init(cwq->worklist.next); in
> > run_workqueue().
> 
> Use a big hammer: Create a new global variable, set it to 1 while
> resuming and back to 0 after the tasks have been thawed.  While the
> variable is nonzero, print in the log the list pointers in
> cwq->worklist just before executing the list_del_init().  Maybe also 
> print some other interesting information about cwq.

I've just sent a message containing full call trace.

It shows the problem is a general protection fault that happens _after_ we've
thawed tasks.

Thanks,
Rafael
