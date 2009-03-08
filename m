Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbZCHMhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbZCHMhZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 08:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZCHMhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 08:37:10 -0400
Received: from netrider.rowland.org ([192.131.102.5]:49286 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751256AbZCHMhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 08:37:09 -0400
Date: Sun, 8 Mar 2009 08:37:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [linux-pm] [RFC][PATCH][1/8] PM: Rework handling of interrupts
 during suspend-resume (rev. 5)
In-Reply-To: <200903081100.43757.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0903080834150.32373-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Mar 2009, Rafael J. Wysocki wrote:

> > > > So perhaps you're worried about drivers that aren't sufficiently
> > > > clever.  Or is something deeper going on?

> > In other words, why not simply abort the suspend if IRQ_PENDING is set
> > for _any_ interrupt during sysdev_suspend()?
> 
> The "wake-up" ones are _intentionally_ left enabled, while the other ones may
> be left enabled by mistake.  The check is intended to prevent the current
> behavior from changing (ie. suspend is aborted if any "wake-up" interrupts
> are pending) and since the platforms only check for the "wake-up" interrupts,
> it doesn't go any further.  Moreover, I think it might introduce a regression
> if it did.

So it _is_ because you are worried about drivers that aren't
sufficiently clever.  If the drivers did their job correctly then there
wouldn't be any pending non-"wake-up" interrupts to confuse matters.

Alan Stern

