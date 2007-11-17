Return-Path: <linux-kernel-owner+w=401wt.eu-S1761651AbXKQM3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761651AbXKQM3P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 07:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbXKQM3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 07:29:01 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59973 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbXKQM3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 07:29:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Subject: Re: apm emulation driver broken ?
Date: Sat, 17 Nov 2007 13:46:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-pm@lists.linux-foundation.org, lkml <linux-kernel@vger.kernel.org>
References: <cda58cb80711160706l2cfac2b1p81c7a1090f228f2e@mail.gmail.com> <200711171059.57462.rjw@sisk.pl> <473ED715.9000004@gmail.com>
In-Reply-To: <473ED715.9000004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711171346.51363.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 17 of November 2007, Franck Bui-Huu wrote:
> Rafael J. Wysocki wrote:
> > On Saturday, 17 of November 2007, Franck Bui-Huu wrote:
> >> Rafael J. Wysocki wrote:
> >>> However, using PF_NOFREEZE to prevent this from happening doesn't seem to be
> >>> a good idea.
> >>>
> >> Indeed but...
> >>
> >>> I'd probably use wait_event_freezable() (defined in
> >>> include/linux/freezer.h) for that.
> >> ...I would just revert this bits from now to make sure this driver
> >> work again for v2.6.24.
> > 
> > I'd prefer not to.
> > 
> > The PF_NOFREEZE was not present in 2.6.23 already and I wouldn't like to
> > reintroduce it now.
> > 
> > Why do you think that using wait_event_freezable() would not work, BTW?
> > 
> 
> I've never claimed this. I just said it may be safer to revert the
> changes for v2.6.24 and improve the current code for next releases.
> 
> >>> It tries to send them fake signals and waits for them to freeze.  If
> >>> they don't freeze within the timeout, it fails and clears their
> >>> TIF_FREEZE bits.
> >> But send_fake_signal() seems to wake up task in INTERRUPTIBLE state
> >> only. Looking at signal_wake_up(), it basically do:
> >>
> >> 	wake_up_state(t, TASK_INTERRUPTIBLE);
> >>
> >> What am I missing ?
> > 
> > Nothing. :-)
> > 
> > I didn't remember the change that made the freezer use TASK_INTERRUPTIBLE
> > explicitly in there (should have looked at the current code before replying).
> > 
> 
> ok so now we agreed on this point, can we assert that a user
> land thread waiting for an event in an UNINTERRUPTIBLE state
> will prevent a suspend to happen ?

Yes.

Rafael
