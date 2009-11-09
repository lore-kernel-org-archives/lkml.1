Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbZKIUbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbZKIUbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 15:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbZKIUbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 15:31:42 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56633 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753898AbZKIUbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 15:31:41 -0500
Date: Mon, 9 Nov 2009 15:31:46 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Help needed: Resume problems in 2.6.32-rc, perhaps
 related to preempt_count leakage in keventd
In-Reply-To: <200911092100.58187.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0911091527390.2858-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Nov 2009, Rafael J. Wysocki wrote:

> Still, RIP always points to list_del_init(cwq->worklist.next); in
> run_workqueue().

Use a big hammer: Create a new global variable, set it to 1 while
resuming and back to 0 after the tasks have been thawed.  While the
variable is nonzero, print in the log the list pointers in
cwq->worklist just before executing the list_del_init().  Maybe also 
print some other interesting information about cwq.

Alan Stern

