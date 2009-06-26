Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbZFZWcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbZFZWcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbZFZWcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:32:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60143 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbZFZWcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:32:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of I/O devices (rev. 6)
Date: Sat, 27 Jun 2009 00:32:44 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0906261707260.4155-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906261707260.4155-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906270032.45290.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 June 2009, Alan Stern wrote:
> On Fri, 26 Jun 2009, Rafael J. Wysocki wrote:
> 
> > > It occurs to me that the problem would be solved if were a cancel_work
> > > routine.  In the same vein, it ought to be possible for
> > > cancel_delayed_work to run in interrupt context.  I'll see what can be
> > > done.
> > 
> > Having looked at the workqueue code I'm not sure if there's a way to implement
> > that in a non-racy way.  Which may be the reason why there are no such
> > functions already. :-)
> 
> Well, I'll give it a try.
> 
> Speaking of races, have you noticed that the way power.work_done gets 
> used is racy?

Not really. :-)

> You can't wait for the completion before releasing the 
> lock, but then anything could happen.
> 
> A safer approach would be to use a wait_queue.

I'm not sure what you mean exactly.  What's the race?

> > In the meantime I reworked the patch (below) to use more RPM_* flags and I
> > removed the runtime_break and runtime_notify bits from it.  Also added some
> > comments to explain some non-obvious steps (hope that helps).
> > 
> > I also added the pm_runtime_put_atomic() and pm_runtime_put() as per the
> > comment above.
> > 
> > It seems to be a bit cleaner this way, but that's my personal view. :-)
> 
> I'll look at it over the weekend.  And I'll try to see if proper 
> cancel_work and cancel_delayed_work functions can help clean it up.

Great, thanks!

Best,
Rafael
