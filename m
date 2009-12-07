Return-Path: <linux-kernel-owner+w=401wt.eu-S935623AbZLGWVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935623AbZLGWVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933422AbZLGWVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:21:32 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41485 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932789AbZLGWVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:21:31 -0500
Date: Mon, 7 Dec 2009 17:21:36 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <alpine.LFD.2.00.0912071403520.3560@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0912071716080.15701-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Linus Torvalds wrote:

> I also suspect that even if you do the USB host controller suspend 
> synchronously, doing the actual USB devices asynchronously would still 
> help - even if it's only "asynchronously per bus" thing. 
> 
> So in fact, it's probably a good first step to start off doing only the 
> USB devices, not the controller.

Interesting you should say that.  The patch I asked Arjan to test 
involved not suspending USB devices at all (root hubs being the 
exception).  That is in fact just what we do when CONFIG_USB_SUSPEND 
isn't set.

There's no need to suspend the individual devices when the whole system 
is going down.  They will automatically suspend when the controller 
stops sending out SOF packets, which occurs when the root hub is 
suspended.  The USB spec describes this, grandiosely, as a "global 
suspend".

But yes, I agree.  Doing just the USB devices is a good first step.

Alan Stern

