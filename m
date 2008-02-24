Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbYBXUpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbYBXUpb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 15:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbYBXUpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 15:45:23 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2800 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751220AbYBXUpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 15:45:23 -0500
Date: Sun, 24 Feb 2008 15:45:21 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
In-Reply-To: <200802242125.44032.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0802241535130.11316-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Remove the code that acquires all device semaphores from the suspend
> code path as it causes multiple problems to appear (most notably,
> http://bugzilla.kernel.org/show_bug.cgi?id=10030) and revert the
> change introduced by commit 4145ed6dc597a9bea5f6ae8c574653b2de10620f
> depending on the code being removed.
> 
> Remove pm_sleep_lock()/pm_sleep_unlock() from device add to avoid
> the issue reported at http://bugzilla.kernel.org/show_bug.cgi?id=9874.

Do you actually know whether removing that lock fixes the reported bug?

I agree, the lock should be removed for now.  But I'd sure like to get 
some feedback about what's going wrong.  It's starting to look as 
though we'd be a lot better off blocking device registration during 
sleep instead of failing it.

Shouldn't resume_device() and suspend_device() now acquire the device 
semaphore before calling the various methods?  That's the way they 
used to work.

Alan Stern

