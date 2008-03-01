Return-Path: <linux-kernel-owner+w=401wt.eu-S1761980AbYCAONB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761980AbYCAONB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 09:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756502AbYCAOMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 09:12:54 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:41406 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539AbYCAOMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 09:12:53 -0500
Date: Sat, 1 Mar 2008 15:11:55 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card
 is inserted]
Message-ID: <20080301151155.55209ebb@mjolnir.drzeus.cx>
In-Reply-To: <Pine.LNX.4.44L0.0802251451050.5536-100000@iolanthe.rowland.org>
References: <20080225193134.104b386d@mjolnir.drzeus.cx>
	<Pine.LNX.4.44L0.0802251451050.5536-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 15:00:51 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> 
> Maybe a better approach would be to leave the workqueue unfreezable,
> and keep cancel_delayed_work_sync() in mmc_suspend_host().  It would
> then be necessary to add a test to verify, if there is a card attached,
> that the card is indeed suspended.  After all, it's possible that the
> cancel_delayed_work_sync() ended up waiting for a job already running
> on the workqueue to register a new card!  (The same would be true even 
> with flush_scheduled_work.)

How would that be handled? I'd prefer a patch as I'm evidently not up to date with how to fondle the pm stuff properly. :)

> 
> Also, as a bit of defensive programming, it might be a good idea to add
> a "suspended" flag to the mmc_host structure.  If mmc_rescan() sees
> that the flag is set then it should return immediately.  This would
> protect against host drivers that aren't careful to disable detect
> IRQs before calling mmc_suspend_host().

Indeed. I'll add that to my todo.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
