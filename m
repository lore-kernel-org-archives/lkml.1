Return-Path: <linux-kernel-owner+w=401wt.eu-S1758370AbZLIWh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370AbZLIWh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 17:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758305AbZLIWhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 17:37:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55515 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758292AbZLIWhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 17:37:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: spinlock in completion_done() (was: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33))
Date: Wed, 9 Dec 2009 23:37:52 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Chinner <david@fromorbit.com>, Lachlan McIlroy <lachlan@sgi.com>
References: <Pine.LNX.4.44L0.0912081633540.3046-100000@iolanthe.rowland.org> <200912082248.14138.rjw@sisk.pl> <20091209092922.GC28428@elte.hu>
In-Reply-To: <20091209092922.GC28428@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912092337.52492.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 December 2009, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Tuesday 08 December 2009, Alan Stern wrote:
> > > On Tue, 8 Dec 2009, Rafael J. Wysocki wrote:
> > > 
> > > > BTW, is there a good reason why completion_done() doesn't use spin_lock_irqsave
> > > > and spin_unlock_irqrestore?  complete() and complete_all() use them, so why not
> > > > here?
> > > 
> > > And likewise in try_wait_for_completion().  It looks like a bug.  Maybe 
> > > these routines were not intended to be called with interrupts disabled, 
> > > but that requirement doesn't seem to be documented.  And it isn't a 
> > > natural requirement anyway.
> > 
> > OK, let's ask Ingo about that.
> > 
> > Ingo, is there any particular reason why completion_done() and
> > try_wait_for_completion() don't use spin_lock_irqsave() and
> > spin_unlock_irqrestore()?
> 
> that's a bug that should be fixed - all the wakeup side (and atomic) 
> variants of completetion API should be irq safe.
> 
> It appears that these new completion APIs were added via the XFS tree 
> about a year ago:
> 
>   39d2f1a: [XFS] extend completions to provide XFS object flush requirements
> 
> Please Cc: scheduler folks to all scheduler patches.

If you haven't fixed it locally yet, would you mind me posting a fix?

Rafael
