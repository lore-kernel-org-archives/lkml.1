Return-Path: <linux-kernel-owner+w=401wt.eu-S965899AbZLHTeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965899AbZLHTeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 14:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965877AbZLHTeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 14:34:17 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51940 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965880AbZLHTeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 14:34:16 -0500
Date: Tue, 8 Dec 2009 14:34:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <alpine.LFD.2.00.0912081043280.3560@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0912081431490.3046-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009, Linus Torvalds wrote:

> Side note: if this was a real lock, you'd also needed an smp_wmb() in the 
> 'wait_lock()' path after the atomic_inc(), to make sure that others see 
> the atomic lock was seen by other people before the suspend started. 
> 
> In your usage scenario, I don't think it would ever be noticeable, since 
> the other users are always going to start running from the same thread 
> that did the wait_lock(), so even if they run on other CPU's, we'll have 
> scheduled _to_ those other CPU's and done enough memory ordering to 
> guarantee that they will see the thing.
> 
> So it would be ok in this situation, simply because it acts as an 
> initializer and never sees any real SMP issues.

Yes.  I would have brought this up, but you made the point for me.

> But it's an example of how you now don't just depend on the locking 
> primitives themselves doing the right thing, you end up depending very 
> subtly on exactly how the lock is used.  The standard locks do have the 
> same kind of issue for initializers, but we avoid it elsewhere because 
> it's so risky.

No doubt there are other reasons why the "wait-lock" pattern doesn't 
get used enough to be noticed.

Alan Stern

