Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbZFZVNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbZFZVNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 17:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZFZVN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 17:13:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33056 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751723AbZFZVN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 17:13:28 -0400
Date: Fri, 26 Jun 2009 17:13:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of
 I/O devices (rev. 6)
In-Reply-To: <200906262246.39464.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906261707260.4155-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009, Rafael J. Wysocki wrote:

> > It occurs to me that the problem would be solved if were a cancel_work
> > routine.  In the same vein, it ought to be possible for
> > cancel_delayed_work to run in interrupt context.  I'll see what can be
> > done.
> 
> Having looked at the workqueue code I'm not sure if there's a way to implement
> that in a non-racy way.  Which may be the reason why there are no such
> functions already. :-)

Well, I'll give it a try.

Speaking of races, have you noticed that the way power.work_done gets 
used is racy?  You can't wait for the completion before releasing the 
lock, but then anything could happen.

A safer approach would be to use a wait_queue.

> In the meantime I reworked the patch (below) to use more RPM_* flags and I
> removed the runtime_break and runtime_notify bits from it.  Also added some
> comments to explain some non-obvious steps (hope that helps).
> 
> I also added the pm_runtime_put_atomic() and pm_runtime_put() as per the
> comment above.
> 
> It seems to be a bit cleaner this way, but that's my personal view. :-)

I'll look at it over the weekend.  And I'll try to see if proper 
cancel_work and cancel_delayed_work functions can help clean it up.

Alan Stern

