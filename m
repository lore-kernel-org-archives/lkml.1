Return-Path: <linux-kernel-owner+w=401wt.eu-S1751690AbXEFWGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbXEFWGl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 18:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXEFWGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 18:06:41 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3915 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751677AbXEFWGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 18:06:40 -0400
Date: Sun, 6 May 2007 18:06:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Ray Lee <ray-lk@madrabbit.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Max Krasnyansky <maxk@qualcomm.com>, <marcel@holtmann.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] make hci_notifier a blocking notifier (was Re: BUG:
 sleeping function called from invalid context at net/core/sock.c:1523)
In-Reply-To: <a781481a0705060816v59c1ae70m1d5067fcaba5a25d@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0705061801330.21407-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 May 2007, Satyam Sharma wrote:

> Anyway, the hci_notifier is called from the following six call sites:
> 
> hci_dev_open() and hci_dev_close() -> both called from
> hci_sock_ioctl() => both can sleep
> hci_register_dev() and hci_unregister_dev() => again both are capable
> of sleeping
> hci_suspend_dev() and hci_resume_dev() -> called from the .suspend()
> and .resume() of the hci_usb_driver, and again both of these can sleep
> 
> Is there any other reason why hci_notifier must be an atomic notifier?
> 
> (CC'ing Alan Stern just in case, apparently hci_notifier became atomic
> when notifier chains were classified into atomic / blocking)

I don't remember exactly why this particular choice was made.  Perhaps we 
found that the notifier callout routines didn't use any blocking 
primitives (we may have been mistaken about this -- there was a lot of 
code to check) and so therefore the choice didn't matter.  In that case we 
probably just decided to make it an atomic notifier to keep things simple.

As you found, changing it to a blocking notifier is very easy.  Provided 
all the callers are non-atomic it should work just fine.

Alan Stern

