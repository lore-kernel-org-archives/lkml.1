Return-Path: <linux-kernel-owner+w=401wt.eu-S966116AbZLHUvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966116AbZLHUvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966106AbZLHUvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:51:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49141 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966079AbZLHUvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:51:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
Date: Tue, 8 Dec 2009 21:52:21 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912081542350.3046-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912081542350.3046-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912082152.21910.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 December 2009, Alan Stern wrote:
> On Tue, 8 Dec 2009, Rafael J. Wysocki wrote:
> 
> > > This is a little more awkward because it requires the parent to iterate 
> > > through its children.
> > 
> > I can live with that.
> > 
> > > But it does solve the off-tree dependency  problem for suspends.
> > 
> > That's a plus, but I still think we're trying to create a barrier-alike
> > mechanism using lock.
> > 
> > There's one more possibility to consider, though.  What if we use a completion
> > instead of the flag + wait queue?  It surely is a standard synchronization
> > mechanism and it seems it might work here.
> 
> You're right.  I should have thought of that.  Linus's original
> approach couldn't use a completion because during suspend it needed to
> make one task (the parent) wait for a bunch of others (the children).
> But if you iterate through the children by hand, that objection no
> longer applies.

BTW, is there a good reason why completion_done() doesn't use spin_lock_irqsave
and spin_unlock_irqrestore?  complete() and complete_all() use them, so why not
here?

Rafael
