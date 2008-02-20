Return-Path: <linux-kernel-owner+w=401wt.eu-S1763300AbYBTRbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763300AbYBTRbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbYBTRau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:30:50 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:50680 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292AbYBTRat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:30:49 -0500
Date: Wed, 20 Feb 2008 18:30:41 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
Message-ID: <20080220183041.46c16ef0@mjolnir.drzeus.cx>
In-Reply-To: <Pine.LNX.4.44L0.0802201136170.5630-100000@iolanthe.rowland.org>
References: <20080219232338.E9A24108068@picon.linux-foundation.org>
	<Pine.LNX.4.44L0.0802201136170.5630-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 11:42:56 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> > 
> > ------- Comment #14 from rjw@sisk.pl  2008-02-19 15:23 -------
> > Thanks a lot for the debugging work!
> > 
> > First, the patch triggers, which means that the problem discovered by Alan is
> > troubling us.  [Alan, do you have an idea how to fix that cleanly?]
> 
> I suggest we ask the maintainer for the MMC subsystem.
> 
> Pierre, you can find the details in the bugzilla entry.  Briefly,
> there's a pathway in the MMC core suspend routine (if the driver
> doesn't implement a resume hook) which could lead to the host being
> removed during a system suspend.  This is an illegal operation and it
> will deadlock.
> 
> Do you have a suggestion for a way to fix it?
> 

Not really. But you have some things confused. What it checks is if the mmc bus handler (not a proper driver model, just a way of separating the MMC, SD and SDIO stuff) has a resume function. And if it doesn't, it removes the card (since it cannot revive it at resume).

So the only thing I can think of is to delay the removal until the resume routine, if that is safer.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
