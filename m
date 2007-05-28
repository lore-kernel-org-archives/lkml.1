Return-Path: <linux-kernel-owner+w=401wt.eu-S1760699AbXE1RiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699AbXE1RiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 13:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbXE1RiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 13:38:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60615 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbXE1RiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 13:38:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Date: Mon, 28 May 2007 19:43:24 +0200
User-Agent: KMail/1.9.5
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Oliver Neukum <oliver@neukum.org>
References: <Pine.LNX.4.44L0.0705281151250.22682-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0705281151250.22682-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281943.25129.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 May 2007 17:55, Alan Stern wrote:
> On Sun, 27 May 2007, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Use a hibernation and suspend notifier to disable the firmware requesting
> > mechanism before a hibernation/suspend and enable it after the operation.
> 
> You're using the PM_PRE_FREEZE and PM_POST_THAW notifiers for both this 
> and the userspace helper change.  Is it your intention that drivers 
> should continue to request these services but encounter an error if the 
> request occurs at the wrong time?  Or do you expect drivers to use the 
> notifier chains to know when they shouldn't make any requests?

In fact, I'd like drivers to use notifiers to actually load the firmware into
memory before hibernation/suspend.  Namely, if there's PM_PRE_FREEZE, the
driver calls request_firmware() from within the notifier and saves the firmware
in memory for future use, if need be.  Later, when PM_POST_THAW comes, the
memory holding the firmware is released.

Unfortunately there are drivers that call request_firmware() directly from
.resume() which blocks until timeout expires and fails anyway.  I just wanted
this to fail immediately, without waiting.

> In the second case you may have a problem, because there's no 
> specification about the order in which the notifiers are sent.  The 
> service may get disabled before the driver learns it isn't available, 
> or the driver may think the service is once again available before it 
> gets enabled.

Yes.

Greetings,
Rafael
